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

  @override
  OnlineGameState build() {
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

    state = state.copyWith(
        connectionStatus: ConnectionStatus.connecting, error: null);
    _playerId = _generatePlayerId();

    final stream = _webSocketService.connect(
      AppConfig.serverUrl,
      onDone: () {
        if (state.connectionStatus != ConnectionStatus.disconnected) {
          state = state.copyWith(
            connectionStatus: ConnectionStatus.disconnected,
            // 保留错误信息（如果有的话）
          );
          _socketSubscription?.cancel();
          _socketSubscription = null;
        }
      },
      onError: (error, stackTrace) {
        if (state.connectionStatus != ConnectionStatus.disconnected) {
          state = state.copyWith(
            connectionStatus: ConnectionStatus.disconnected,
            error: '连接发生错误: $error',
          );
          _socketSubscription?.cancel();
          _socketSubscription = null;
        }
      },
    );

    if (stream != null) {
      state = state.copyWith(connectionStatus: ConnectionStatus.connected);
      _socketSubscription = stream.listen((data) {
        _handleRawMessage(data);
      });
      // 发送一个ping来"确认"连接并获取玩家ID
      _sendMessage(MessageType.ping);
    } else {
      state = state.copyWith(
        connectionStatus: ConnectionStatus.disconnected,
        error: '无法连接到服务器',
      );
    }
  }

  /// 断开连接
  void disconnect() {
    _webSocketService.disconnect();
    _socketSubscription?.cancel();
    _socketSubscription = null;
    state = const OnlineGameState(
        connectionStatus: ConnectionStatus.disconnected);
  }

  /// 离开界面时清理状态
  void cleanup() {
    disconnect();
    // 重置为完全初始状态
    state = const OnlineGameState();
  }

  // --- 用户操作 ---

  void createRoom(String playerName) {
    final name =
        playerName.trim().isEmpty ? RandomNames(Zone.us).name() : playerName;
    _sendMessage(MessageType.createRoom, data: {'playerName': name});
  }

  void joinRoom(String roomId, String playerName) {
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
          gameState: GameState.fromJson(message.data!['gameState']),
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
          gameState: GameState.fromJson(message.data!['gameState']),
        );

      case MessageType.gameUpdate:
      case MessageType.gameMove:
      case MessageType.gameReset:
      case MessageType.gameOver:
        return state.copyWith(
          gameState: GameState.fromJson(message.data!['gameState']),
          roomInfo: RoomInfo.fromJson(message.data!['roomInfo']),
        );

      case MessageType.error:
        return state.copyWith(
          error: message.data?['message'] ?? '来自服务器的未知错误',
          isJoiningRoom: false,
        );

      default:
        return state;
    }
  }
}
