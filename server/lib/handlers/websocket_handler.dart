import 'dart:convert';
import 'package:logging/logging.dart';
// ignore: depend_on_referenced_packages
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/game_models.dart';
import '../services/room_manager.dart';

/// WebSocket 连接管理器
class WebSocketManager {
  static final _logger = Logger('WebSocketManager');
  final RoomManager roomManager;

  // 玩家连接映射
  final Map<String, WebSocketChannel> _playerSockets = {};

  WebSocketManager(this.roomManager);

  /// 处理新的 WebSocket 连接
  void handleConnection(WebSocketChannel webSocket) {
    String? playerId;

    webSocket.stream.listen(
      (data) {
        try {
          final json = jsonDecode(data as String);
          final message = NetworkMessage.fromJson(json);
          playerId ??= message.playerId;

          if (playerId != null) {
            _playerSockets[playerId!] = webSocket;
          }

          _handleMessage(message, webSocket);
        } catch (e) {
          _logger.severe('处理消息时出错: $e');
          _sendError(webSocket, '消息格式错误');
        }
      },
      onError: (error) {
        _logger.warning('WebSocket错误: $error');
        if (playerId != null) {
          _handlePlayerDisconnect(playerId!);
        }
      },
      onDone: () {
        _logger.info('WebSocket连接关闭');
        if (playerId != null) {
          _handlePlayerDisconnect(playerId!);
        }
      },
    );
  }

  /// 处理客户端消息
  void _handleMessage(NetworkMessage message, WebSocketChannel webSocket) {
    _logger.info('收到消息: ${message.type} from ${message.playerId}');

    switch (message.type) {
      case MessageType.ping:
        _handlePing(message, webSocket);
        break;
      case MessageType.createRoom:
        _handleCreateRoom(message, webSocket);
        break;
      case MessageType.joinRoom:
        _handleJoinRoom(message, webSocket);
        break;
      case MessageType.leaveRoom:
        _handleLeaveRoom(message, webSocket);
        break;
      case MessageType.gameMove:
        _handleGameMove(message, webSocket);
        break;
      case MessageType.gameReset:
        _handleGameReset(message, webSocket);
        break;
      default:
        _sendError(webSocket, '未知的消息类型');
    }
  }

  /// 处理心跳
  void _handlePing(NetworkMessage message, WebSocketChannel webSocket) {
    final response = NetworkMessage(
      type: MessageType.pong,
      playerId: message.playerId,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    _sendMessage(webSocket, response);
  }

  /// 处理创建房间
  void _handleCreateRoom(NetworkMessage message, WebSocketChannel webSocket) {
    if (message.playerId == null || message.data == null) {
      _sendError(webSocket, '缺少必要参数');
      return;
    }

    final playerName = message.data!['playerName'] as String?;
    if (playerName == null || playerName.trim().isEmpty) {
      _sendError(webSocket, '玩家姓名不能为空');
      return;
    }

    try {
      final roomId = roomManager.createRoom(message.playerId!, playerName);
      final room = roomManager.getRoom(roomId)!;

      final response = NetworkMessage(
        type: MessageType.roomCreated,
        roomId: roomId,
        playerId: message.playerId,
        data: room.toRoomInfo().toJson(),
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );

      _sendMessage(webSocket, response);
    } catch (e) {
      _sendError(webSocket, '创建房间失败: $e');
    }
  }

  /// 处理加入房间
  void _handleJoinRoom(NetworkMessage message, WebSocketChannel webSocket) {
    if (message.playerId == null ||
        message.roomId == null ||
        message.data == null) {
      _sendError(webSocket, '缺少必要参数');
      return;
    }

    final playerName = message.data!['playerName'] as String?;
    if (playerName == null || playerName.trim().isEmpty) {
      _sendError(webSocket, '玩家姓名不能为空');
      return;
    }

    final result = roomManager.joinRoom(
      message.roomId!,
      message.playerId!,
      playerName,
    );

    switch (result) {
      case RoomJoinSuccess(:final room):
        final response = NetworkMessage(
          type: MessageType.roomJoined,
          roomId: message.roomId,
          playerId: message.playerId,
          data: room.toRoomInfo().toJson(),
          timestamp: DateTime.now().millisecondsSinceEpoch,
        );
        _sendMessage(webSocket, response);

        // 通知房间内其他玩家
        final newPlayer = room.players.last;
        _broadcastToRoom(
          message.roomId!,
          NetworkMessage(
            type: MessageType.playerJoined,
            roomId: message.roomId,
            playerId: message.playerId,
            data: newPlayer.toJson(),
            timestamp: DateTime.now().millisecondsSinceEpoch,
          ),
          excludePlayer: message.playerId,
        );

      case RoomJoinError(:final message):
        _sendError(webSocket, message);
    }
  }

  /// 处理离开房间
  void _handleLeaveRoom(NetworkMessage message, WebSocketChannel webSocket) {
    if (message.playerId == null) {
      _sendError(webSocket, '缺少玩家ID');
      return;
    }

    final result = roomManager.leaveRoom(message.playerId!);

    switch (result) {
      case RoomLeaveSuccess(:final room, :final playerId):
        final response = NetworkMessage(
          type: MessageType.roomLeft,
          roomId: room.roomId,
          playerId: message.playerId,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        );
        _sendMessage(webSocket, response);

        // 通知房间内其他玩家
        _broadcastToRoom(
          room.roomId,
          NetworkMessage(
            type: MessageType.playerLeft,
            roomId: room.roomId,
            playerId: playerId,
            timestamp: DateTime.now().millisecondsSinceEpoch,
          ),
        );

      case RoomLeaveDeleted(:final roomId):
        final response = NetworkMessage(
          type: MessageType.roomLeft,
          roomId: roomId,
          playerId: message.playerId,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        );
        _sendMessage(webSocket, response);

      case RoomLeaveError(:final message):
        _sendError(webSocket, message);
    }
  }

  /// 处理游戏移动
  void _handleGameMove(NetworkMessage message, WebSocketChannel webSocket) {
    if (message.playerId == null || message.data == null) {
      _sendError(webSocket, '缺少必要参数');
      return;
    }

    final moveData = GameMoveData.fromJson(message.data!);
    final result = roomManager.makeMove(message.playerId!, moveData.position);

    switch (result) {
      case GameMoveSuccess(:final room, :final moveData):
        // 广播移动给房间内所有玩家
        _broadcastToRoom(
          room.roomId,
          NetworkMessage(
            type: MessageType.gameMove,
            roomId: room.roomId,
            playerId: message.playerId,
            data: moveData.toJson(),
            timestamp: DateTime.now().millisecondsSinceEpoch,
          ),
        );

        // 如果游戏结束，发送游戏结束消息
        if (room.gameState.status != GameStatus.playing) {
          _broadcastToRoom(
            room.roomId,
            NetworkMessage(
              type: MessageType.gameOver,
              roomId: room.roomId,
              data: room.gameState.toJson(),
              timestamp: DateTime.now().millisecondsSinceEpoch,
            ),
          );
        }

      case GameMoveError(:final message):
        _sendError(webSocket, message);
    }
  }

  /// 处理游戏重置
  void _handleGameReset(NetworkMessage message, WebSocketChannel webSocket) {
    if (message.playerId == null) {
      _sendError(webSocket, '缺少玩家ID');
      return;
    }

    final result = roomManager.resetGame(message.playerId!);

    switch (result) {
      case GameResetSuccess(:final room):
        _broadcastToRoom(
          room.roomId,
          NetworkMessage(
            type: MessageType.gameReset,
            roomId: room.roomId,
            playerId: message.playerId,
            timestamp: DateTime.now().millisecondsSinceEpoch,
          ),
        );

      case GameResetError(:final message):
        _sendError(webSocket, message);
    }
  }

  /// 处理玩家断开连接
  void _handlePlayerDisconnect(String playerId) {
    _playerSockets.remove(playerId);

    // 让玩家离开房间
    final result = roomManager.leaveRoom(playerId);

    switch (result) {
      case RoomLeaveSuccess(:final room):
        _broadcastToRoom(
          room.roomId,
          NetworkMessage(
            type: MessageType.playerLeft,
            roomId: room.roomId,
            playerId: playerId,
            timestamp: DateTime.now().millisecondsSinceEpoch,
          ),
        );

      case RoomLeaveDeleted():
        // 房间已删除，无需处理
        break;

      case RoomLeaveError():
        // 玩家不在房间中，无需处理
        break;
    }

    _logger.info('玩家 $playerId 断开连接');
  }

  /// 发送消息到指定客户端
  void _sendMessage(WebSocketChannel webSocket, NetworkMessage message) {
    try {
      final jsonData = jsonEncode(message.toJson());
      webSocket.sink.add(jsonData);
    } catch (e) {
      _logger.severe('发送消息失败: $e');
    }
  }

  /// 发送错误消息
  void _sendError(WebSocketChannel webSocket, String errorMessage) {
    final message = NetworkMessage(
      type: MessageType.error,
      error: errorMessage,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    _sendMessage(webSocket, message);
  }

  /// 广播消息到房间内所有玩家
  void _broadcastToRoom(
    String roomId,
    NetworkMessage message, {
    String? excludePlayer,
  }) {
    final room = roomManager.getRoom(roomId);
    if (room == null) return;

    for (final player in room.players) {
      if (excludePlayer != null && player.playerId == excludePlayer) {
        continue;
      }

      final webSocket = _playerSockets[player.playerId];
      if (webSocket != null) {
        _sendMessage(webSocket, message);
      }
    }
  }
}
