import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/game_state.dart';
import '../models/network_message.dart';
import '../services/websocket_service.dart';

/// 在线游戏状态
class OnlineGameState {
  final GameState gameState;
  final RoomInfo? roomInfo;
  final bool isConnected;
  final bool isConnecting;
  final String? error;
  final PlayerInfo? currentPlayer;
  final Player? mySymbol;
  final bool isMyTurn;

  const OnlineGameState({
    required this.gameState,
    this.roomInfo,
    required this.isConnected,
    required this.isConnecting,
    this.error,
    this.currentPlayer,
    this.mySymbol,
    required this.isMyTurn,
  });

  OnlineGameState copyWith({
    GameState? gameState,
    RoomInfo? roomInfo,
    bool? isConnected,
    bool? isConnecting,
    String? error,
    PlayerInfo? currentPlayer,
    Player? mySymbol,
    bool? isMyTurn,
  }) {
    return OnlineGameState(
      gameState: gameState ?? this.gameState,
      roomInfo: roomInfo ?? this.roomInfo,
      isConnected: isConnected ?? this.isConnected,
      isConnecting: isConnecting ?? this.isConnecting,
      error: error ?? this.error,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      mySymbol: mySymbol ?? this.mySymbol,
      isMyTurn: isMyTurn ?? this.isMyTurn,
    );
  }
}

class OnlineGameNotifier extends StateNotifier<OnlineGameState> {
  final WebSocketService _webSocketService = WebSocketService();
  StreamSubscription? _messageSubscription;
  StreamSubscription? _connectionSubscription;
  StreamSubscription? _errorSubscription;

  OnlineGameNotifier()
    : super(
        OnlineGameState(
          gameState: const GameState(),
          isConnected: false,
          isConnecting: false,
          isMyTurn: false,
        ),
      ) {
    _setupSubscriptions();
  }

  /// 设置事件监听
  void _setupSubscriptions() {
    _messageSubscription = _webSocketService.messageStream.listen(
      _handleMessage,
    );
    _connectionSubscription = _webSocketService.connectionStream.listen(
      _handleConnection,
    );
    _errorSubscription = _webSocketService.errorStream.listen(_handleError);
  }

  /// 连接服务器
  Future<bool> connect({String? serverUrl}) async {
    // 避免在 widget 构建期间立即修改状态
    await Future.microtask(() {
      state = state.copyWith(isConnecting: true, error: null);
    });

    final success = await _webSocketService.connect(serverUrl: serverUrl);
    if (!success) {
      state = state.copyWith(isConnecting: false, error: '连接失败');
    }
    return success;
  }

  /// 断开连接
  Future<void> disconnect() async {
    await _webSocketService.disconnect();
    state = OnlineGameState(
      gameState: const GameState(),
      isConnected: false,
      isConnecting: false,
      isMyTurn: false,
    );
  }

  /// 创建房间
  Future<void> createRoom(String playerName) async {
    if (!state.isConnected) return;
    await _webSocketService.createRoom(playerName);
  }

  /// 加入房间
  Future<void> joinRoom(String roomId, String playerName) async {
    if (!state.isConnected) return;
    await _webSocketService.joinRoom(roomId, playerName);
  }

  /// 离开房间
  Future<void> leaveRoom() async {
    await _webSocketService.leaveRoom();

    // 添加超时机制，如果3秒内没有收到服务器确认，强制清除状态
    Timer(const Duration(seconds: 3), () {
      if (state.roomInfo != null) {
        // 如果3秒后仍然在房间中，强制清除状态
        state = state.copyWith(
          roomInfo: null,
          currentPlayer: null,
          mySymbol: null,
          gameState: const GameState(),
          isMyTurn: false,
          error: null,
        );
      }
    });
  }

  /// 发送游戏移动
  Future<void> makeMove(int position) async {
    if (!state.isMyTurn ||
        state.mySymbol == null ||
        !state.gameState.canMakeMove(position)) {
      return;
    }

    await _webSocketService.sendGameMove(position, state.mySymbol!);
  }

  /// 重置游戏
  Future<void> resetGame() async {
    await _webSocketService.resetGame();
  }

  /// 处理网络消息
  void _handleMessage(NetworkMessage message) {
    switch (message.type) {
      case MessageType.roomCreated:
        _handleRoomCreated(message);
        break;
      case MessageType.roomJoined:
        _handleRoomJoined(message);
        break;
      case MessageType.roomLeft:
        _handleRoomLeft(message);
        break;
      case MessageType.playerJoined:
        _handlePlayerJoined(message);
        break;
      case MessageType.playerLeft:
        _handlePlayerLeft(message);
        break;
      case MessageType.gameUpdate:
        _handleGameUpdate(message);
        break;
      case MessageType.gameMove:
        _handleGameMove(message);
        break;
      case MessageType.gameReset:
        _handleGameReset(message);
        break;
      case MessageType.gameOver:
        _handleGameOver(message);
        break;
      case MessageType.error:
        _handleServerError(message);
        break;
      default:
        break;
    }
  }

  /// 处理房间创建成功
  void _handleRoomCreated(NetworkMessage message) {
    final data = message.data;
    if (data != null) {
      final roomInfo = RoomInfo.fromJson(data);
      final myPlayer = roomInfo.players.firstWhere(
        (p) => p.playerId == _webSocketService.playerId,
      );

      state = state.copyWith(
        roomInfo: roomInfo,
        currentPlayer: myPlayer,
        mySymbol: myPlayer.playerSymbol,
        isMyTurn: roomInfo.gameState?.currentPlayer == myPlayer.playerSymbol,
      );
    }
  }

  /// 处理加入房间成功
  void _handleRoomJoined(NetworkMessage message) {
    final data = message.data;
    if (data != null) {
      final roomInfo = RoomInfo.fromJson(data);
      final myPlayer = roomInfo.players.firstWhere(
        (p) => p.playerId == _webSocketService.playerId,
      );

      state = state.copyWith(
        roomInfo: roomInfo,
        currentPlayer: myPlayer,
        mySymbol: myPlayer.playerSymbol,
        gameState: roomInfo.gameState ?? const GameState(),
        isMyTurn:
            (roomInfo.gameState?.currentPlayer ?? Player.x) ==
            myPlayer.playerSymbol,
      );
    }
  }

  /// 处理离开房间成功
  void _handleRoomLeft(NetworkMessage message) {
    // 清除房间相关状态
    state = state.copyWith(
      roomInfo: null,
      currentPlayer: null,
      mySymbol: null,
      gameState: const GameState(),
      isMyTurn: false,
      error: null, // 清除任何错误信息
    );
  }

  /// 处理玩家加入
  void _handlePlayerJoined(NetworkMessage message) {
    final data = message.data;
    if (data != null && state.roomInfo != null) {
      final newPlayer = PlayerInfo.fromJson(data);
      final updatedPlayers = [...state.roomInfo!.players, newPlayer];
      final updatedRoom = state.roomInfo!.copyWith(players: updatedPlayers);

      state = state.copyWith(roomInfo: updatedRoom);
    }
  }

  /// 处理玩家离开
  void _handlePlayerLeft(NetworkMessage message) {
    final playerId = message.playerId;
    if (playerId != null && state.roomInfo != null) {
      final updatedPlayers = state.roomInfo!.players
          .where((p) => p.playerId != playerId)
          .toList();
      final updatedRoom = state.roomInfo!.copyWith(players: updatedPlayers);

      state = state.copyWith(roomInfo: updatedRoom);
    }
  }

  /// 处理游戏更新
  void _handleGameUpdate(NetworkMessage message) {
    final data = message.data;
    if (data != null) {
      final gameState = GameState.fromJson(data);
      final isMyTurn = gameState.currentPlayer == state.mySymbol;

      state = state.copyWith(gameState: gameState, isMyTurn: isMyTurn);
    }
  }

  /// 处理游戏移动
  void _handleGameMove(NetworkMessage message) {
    final data = message.data;
    if (data != null) {
      final moveData = GameMoveData.fromJson(data);

      // 更新游戏棋盘
      final newBoard = List<Player?>.from(state.gameState.board);
      newBoard[moveData.position] = moveData.player;

      final newGameState = state.gameState.copyWith(board: newBoard);
      final updatedGameState = newGameState.copyWith(
        currentPlayer: newGameState.currentPlayer == Player.x
            ? Player.o
            : Player.x,
        status: newGameState.checkWinStatus(),
      );

      final isMyTurn = updatedGameState.currentPlayer == state.mySymbol;

      state = state.copyWith(gameState: updatedGameState, isMyTurn: isMyTurn);
    }
  }

  /// 处理游戏重置
  void _handleGameReset(NetworkMessage message) {
    state = state.copyWith(
      gameState: const GameState(),
      isMyTurn: state.mySymbol == Player.x,
    );
  }

  /// 处理游戏结束
  void _handleGameOver(NetworkMessage message) {
    final data = message.data;
    if (data != null) {
      final gameState = GameState.fromJson(data);
      state = state.copyWith(gameState: gameState, isMyTurn: false);
    }
  }

  /// 处理服务器错误
  void _handleServerError(NetworkMessage message) {
    state = state.copyWith(error: message.error);
  }

  /// 处理连接状态变化
  void _handleConnection(bool connected) {
    state = state.copyWith(isConnected: connected, isConnecting: false);

    if (!connected) {
      state = state.copyWith(
        roomInfo: null,
        gameState: const GameState(),
        mySymbol: null,
        isMyTurn: false,
      );
    }
  }

  /// 处理错误
  void _handleError(String error) {
    state = state.copyWith(error: error, isConnecting: false);
  }

  /// 清除错误
  void clearError() {
    state = state.copyWith(error: null);
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    _connectionSubscription?.cancel();
    _errorSubscription?.cancel();
    _webSocketService.dispose();
    super.dispose();
  }
}

/// 在线游戏状态提供者
final onlineGameProvider =
    StateNotifierProvider<OnlineGameNotifier, OnlineGameState>((ref) {
      return OnlineGameNotifier();
    });
