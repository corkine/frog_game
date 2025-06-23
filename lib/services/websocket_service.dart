import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/network_message.dart';
import '../models/game_state.dart';
import '../config/app_config.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  String? _playerId;
  String? _currentRoomId;
  bool _isConnected = false;

  // 事件流控制器
  final _messageController = StreamController<NetworkMessage>.broadcast();
  final _connectionController = StreamController<bool>.broadcast();
  final _errorController = StreamController<String>.broadcast();

  // 公开的流
  Stream<NetworkMessage> get messageStream => _messageController.stream;
  Stream<bool> get connectionStream => _connectionController.stream;
  Stream<String> get errorStream => _errorController.stream;

  // Getters
  bool get isConnected => _isConnected;
  String? get playerId => _playerId;
  String? get currentRoomId => _currentRoomId;

  /// 连接到WebSocket服务器
  Future<bool> connect({String? serverUrl}) async {
    try {
      final url = serverUrl ?? AppConfig.serverUrl;
      _channel = WebSocketChannel.connect(Uri.parse(url));
      _isConnected = true;
      _playerId = _generatePlayerId();

      _connectionController.add(true);

      // 监听消息
      _channel!.stream.listen(
        _onMessage,
        onError: _onError,
        onDone: _onDisconnected,
      );

      // 发送连接确认
      _sendMessage(
        NetworkMessage(
          type: MessageType.ping,
          playerId: _playerId,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      );

      return true;
    } catch (e) {
      _onError('连接失败: $e');
      return false;
    }
  }

  /// 断开连接
  Future<void> disconnect() async {
    if (_channel != null) {
      await _channel!.sink.close();
    }
    _reset();
  }

  /// 创建房间
  Future<void> createRoom(String playerName) async {
    if (!_isConnected) return;

    _sendMessage(
      NetworkMessage(
        type: MessageType.createRoom,
        playerId: _playerId,
        data: {'playerName': playerName},
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  /// 加入房间
  Future<void> joinRoom(String roomId, String playerName) async {
    if (!_isConnected) return;

    _sendMessage(
      NetworkMessage(
        type: MessageType.joinRoom,
        roomId: roomId,
        playerId: _playerId,
        data: {'playerName': playerName},
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  /// 离开房间
  Future<void> leaveRoom() async {
    if (!_isConnected || _currentRoomId == null) return;

    _sendMessage(
      NetworkMessage(
        type: MessageType.leaveRoom,
        roomId: _currentRoomId,
        playerId: _playerId,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  /// 发送游戏移动
  Future<void> sendGameMove(int position, Player player) async {
    if (!_isConnected || _currentRoomId == null) return;

    final moveData = GameMoveData(
      position: position,
      player: player,
      playerId: _playerId!,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );

    _sendMessage(
      NetworkMessage(
        type: MessageType.gameMove,
        roomId: _currentRoomId,
        playerId: _playerId,
        data: moveData.toJson(),
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  /// 重置游戏
  Future<void> resetGame() async {
    if (!_isConnected || _currentRoomId == null) return;

    _sendMessage(
      NetworkMessage(
        type: MessageType.gameReset,
        roomId: _currentRoomId,
        playerId: _playerId,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  /// 发送消息
  void _sendMessage(NetworkMessage message) {
    if (_channel != null && _isConnected) {
      final jsonData = jsonEncode(message.toJson());
      _channel!.sink.add(jsonData);
      if (kDebugMode) {
        print('发送消息: $jsonData');
      }
    }
  }

  /// 处理接收的消息
  void _onMessage(dynamic data) {
    try {
      final jsonData = jsonDecode(data as String);
      final message = NetworkMessage.fromJson(jsonData);

      if (kDebugMode) {
        print('接收消息: ${message.type}');
      }

      // 处理房间状态更新
      if (message.type == MessageType.roomJoined ||
          message.type == MessageType.roomCreated) {
        _currentRoomId = message.roomId;
      } else if (message.type == MessageType.roomLeft) {
        _currentRoomId = null;
      }

      // 发送到消息流
      _messageController.add(message);

      // 响应ping
      if (message.type == MessageType.ping) {
        _sendMessage(
          NetworkMessage(
            type: MessageType.pong,
            playerId: _playerId,
            timestamp: DateTime.now().millisecondsSinceEpoch,
          ),
        );
      }
    } catch (e) {
      _onError('解析消息失败: $e');
    }
  }

  /// 处理错误
  void _onError(dynamic error) {
    final errorMessage = error.toString();
    if (kDebugMode) {
      print('WebSocket错误: $errorMessage');
    }
    _errorController.add(errorMessage);
  }

  /// 处理断开连接
  void _onDisconnected() {
    if (kDebugMode) {
      print('WebSocket断开连接');
    }
    _reset();
  }

  /// 重置状态
  void _reset() {
    _isConnected = false;
    _currentRoomId = null;
    _channel = null;
    _connectionController.add(false);
  }

  /// 生成玩家ID
  String _generatePlayerId() {
    final random = Random();
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return List.generate(
      12,
      (index) => chars[random.nextInt(chars.length)],
    ).join();
  }

  /// 清理资源
  void dispose() {
    disconnect();
    _messageController.close();
    _connectionController.close();
    _errorController.close();
  }
}
