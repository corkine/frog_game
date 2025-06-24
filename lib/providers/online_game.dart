import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:random_name_generator/random_name_generator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/game_state.dart';
import '../models/network_message.dart';
import '../config/app_config.dart';
import '../services/websocket_service.dart';

part 'online_game.freezed.dart';
part 'online_game.g.dart';

/// 连接状态的枚举
enum ConnectionStatus {
  initial,
  connecting,
  connected,
  disconnected,
}

/// 在线游戏的整体状态，使用Freezed进行状态管理
@freezed
class OnlineGameState with _$OnlineGameState {
  const factory OnlineGameState({
    @Default(GameState()) GameState gameState,
    @Default(ConnectionStatus.initial) ConnectionStatus connectionStatus,
    RoomInfo? roomInfo,
    String? error,
    PlayerInfo? currentPlayer,
    Player? mySymbol,
    @Default(false) bool isJoiningRoom,
  }) = _OnlineGameState;

  // Freezed会自动处理构造函数，这里我们保留私有构造函数以添加自定义getter
  const OnlineGameState._();

  /// 计算当前玩家是否轮到自己
  bool get isMyTurn {
    if (mySymbol == null ||
        roomInfo == null ||
        gameState.status != GameStatus.playing) {
      return false;
    }
    return gameState.currentPlayer == mySymbol;
  }
}

/// 在线游戏的StateNotifier，负责所有业务逻辑
@riverpod
class OnlineGame extends _$OnlineGame {
  StreamSubscription? _socketSubscription;
  String? _playerId;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  bool _isDisposed = false;

  @override
  OnlineGameState build() {
    ref.onDispose(() {
      _isDisposed = true;
      _reconnectTimer?.cancel();
      _webSocketService.disconnect();
      _socketSubscription?.cancel();
    });
    return const OnlineGameState();
  }

  WebSocketService get _webSocketService => ref.read(webSocketServiceProvider);

  String _generatePlayerId() {
    final random = Random();
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return List.generate(12, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  /// 连接到服务器
  Future<void> connect() async {
    if (state.connectionStatus == ConnectionStatus.connecting ||
        state.connectionStatus == ConnectionStatus.connected) {
      return;
    }

    // 在实际应用中，避免在已销毁的notifier上设置状态
    if (_isDisposed) return;

    state = state.copyWith(
        connectionStatus: ConnectionStatus.connecting, error: null);
    _playerId ??= _generatePlayerId();

    final stream = await _webSocketService.connect(
      AppConfig.serverUrl,
      onDone: () => _handleDisconnection(isError: false),
      onError: (error, stackTrace) {
        if (kDebugMode) {
          print('连接错误: $error');
        }
        _handleDisconnection(isError: true, errorMsg: error.toString());
      },
    );

    if (stream != null) {
      if (_isDisposed) return;
      state = state.copyWith(connectionStatus: ConnectionStatus.connected);
      _reconnectTimer?.cancel();
      _reconnectAttempts = 0;
      _socketSubscription = stream.listen(_handleRawMessage);
      // 发送一个ping来"确认"连接并获取玩家ID
      _sendMessage(MessageType.ping);
    }
  }

  void _handleDisconnection({required bool isError, String? errorMsg}) {
    // 如果已销毁，或已有重连任务，则不处理
    if (_isDisposed || _reconnectTimer?.isActive == true) {
      return;
    }

    // 仅当状态不是"已断开"时才更新，避免不必要的UI刷新
    if (state.connectionStatus != ConnectionStatus.disconnected) {
      state = state.copyWith(
        connectionStatus: ConnectionStatus.disconnected,
        error: '连接已断开，正在尝试重连...',
      );
    }

    _socketSubscription?.cancel();
    _socketSubscription = null;

    const maxAttempts = 5;
    if (_reconnectAttempts >= maxAttempts) {
      if (kDebugMode) {
        print('已达到最大重连次数。');
      }
      if (!_isDisposed) {
        state = state.copyWith(
          connectionStatus: ConnectionStatus.disconnected,
          error: '多次重连失败，请检查网络并重新进入大厅。',
        );
      }
      return;
    }

    _reconnectAttempts++;
    // 指数退避策略，但最长不超过30秒
    final delaySeconds = min(pow(2, _reconnectAttempts).toInt(), 30);

    if (kDebugMode) {
      print('连接丢失。将在 $delaySeconds 秒后重试 (第 $_reconnectAttempts 次)...');
    }

    _reconnectTimer = Timer(Duration(seconds: delaySeconds), () {
      // 再次检查状态，确保在计时器触发时仍然需要重连
      if (!_isDisposed &&
          state.connectionStatus == ConnectionStatus.disconnected) {
        connect();
      }
    });
  }

  /// 断开连接
  void disconnect() {
    _reconnectTimer?.cancel();
    _reconnectAttempts = 0;
    _webSocketService.disconnect();
    _socketSubscription?.cancel();
    _socketSubscription = null;
    if (!_isDisposed) {
      state = const OnlineGameState(
          connectionStatus: ConnectionStatus.disconnected);
    }
  }

  /// 离开界面时清理状态
  void cleanup() {
    disconnect();
    // 重置为完全初始状态
    if (!_isDisposed) {
      state = const OnlineGameState();
    }
  }

  // --- 用户操作 ---

  void createRoom(String playerName) {
    if (state.connectionStatus != ConnectionStatus.connected) {
      state = state.copyWith(error: '未连接到服务器，请稍后重试。');
      connect(); // 尝试连接
      return;
    }
    final name =
        playerName.trim().isEmpty ? RandomNames(Zone.us).name() : playerName;
    _sendMessage(MessageType.createRoom, data: {'playerName': name});
  }

  void joinRoom(String roomId, String playerName) {
    if (state.connectionStatus != ConnectionStatus.connected) {
      state = state.copyWith(error: '未连接到服务器，请稍后重试。');
      connect(); // 尝试连接
      return;
    }
    state = state.copyWith(isJoiningRoom: true, error: null);
    final name =
        playerName.trim().isEmpty ? RandomNames(Zone.us).name() : playerName;
    _sendMessage(MessageType.joinRoom,
        roomId: roomId, data: {'playerName': name});

    // 超时处理
    Timer(const Duration(seconds: 10), () {
      if (state.isJoiningRoom) {
        state = state.copyWith(isJoiningRoom: false, error: '加入房间超时');
      }
    });
  }

  void leaveRoom() {
    if (state.roomInfo?.roomId == null) return;
    _sendMessage(MessageType.leaveRoom, roomId: state.roomInfo!.roomId);
  }

  void makeMove(int position) {
    if (!state.isMyTurn ||
        state.mySymbol == null ||
        !state.gameState.canMakeMove(position)) {
      return;
    }

    final moveData = GameMoveData(
      position: position,
      player: state.mySymbol!,
      playerId: _playerId!,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    _sendMessage(MessageType.gameMove,
        roomId: state.roomInfo!.roomId, data: moveData.toJson());
  }

  void resetGame() {
    if (state.roomInfo?.roomId == null) return;
    _sendMessage(MessageType.gameReset, roomId: state.roomInfo!.roomId);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  // --- 消息处理 ---

  void _sendMessage(MessageType type,
      {String? roomId, Map<String, dynamic>? data}) {
    if (_playerId == null ||
        state.connectionStatus != ConnectionStatus.connected) return;
    _webSocketService.sendMessage(NetworkMessage(
      type: type,
      playerId: _playerId!,
      roomId: roomId,
      data: data,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    ));
  }

  void _handleRawMessage(dynamic data) {
    try {
      final message = NetworkMessage.fromJson(jsonDecode(data as String));

      if (kDebugMode) {
        print('接收消息: ${message.type}');
      }

      // 任何成功从服务器收到的消息都意味着连接是活跃的，重置重连尝试
      if (_reconnectAttempts > 0) {
        if (kDebugMode) {
          print('消息接收成功，重置重连尝试次数。');
        }
        _reconnectAttempts = 0;
        _reconnectTimer?.cancel();
      }

      if (message.type == MessageType.ping) {
        _sendMessage(MessageType.pong);
        return;
      }
      
      state = _getNextState(message);
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('解析消息失败: $e\n$stackTrace');
      }
      state = state.copyWith(error: '处理消息时发生意外错误。');
    }
  }

  OnlineGameState _getNextState(NetworkMessage message) {
    switch (message.type) {
      case MessageType.roomCreated:
      case MessageType.roomJoined:
        final roomInfo = RoomInfo.fromJson(message.data!['roomInfo']);
        final me = roomInfo.players.firstWhere((p) => p.playerId == _playerId,
            orElse: () => throw Exception("Could not find myself in player list"));
        return state.copyWith(
          roomInfo: roomInfo,
          currentPlayer: me,
          mySymbol: me.playerSymbol,
          isJoiningRoom: false,
          error: null,
          gameState: roomInfo.gameState ?? const GameState(),
        );

      case MessageType.roomLeft:
        return state.copyWith(
          roomInfo: null,
          currentPlayer: null,
          mySymbol: null,
          gameState: const GameState(),
        );

      case MessageType.playerJoined:
      case MessageType.playerLeft:
        final roomInfo = RoomInfo.fromJson(message.data!['roomInfo']);
        return state.copyWith(
          roomInfo: roomInfo,
          gameState: roomInfo.gameState ?? const GameState(),
        );

      case MessageType.gameUpdate:
      case MessageType.gameMove:
      case MessageType.gameReset:
      case MessageType.gameOver:
        final newGameState = GameState.fromJson(message.data!['gameState']);
        final newRoomInfo = message.data?['roomInfo'] != null
            ? RoomInfo.fromJson(message.data!['roomInfo'])
            : state.roomInfo;
        return state.copyWith(
          gameState: newGameState,
          roomInfo: newRoomInfo,
        );

      case MessageType.error:
        final errorMessage =
            message.error ?? message.data?['message'] ?? '来自服务器的未知错误';
        return state.copyWith(
          error: errorMessage,
          isJoiningRoom: false,
        );

      default:
        return state;
    }
  }
}
