import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_models.freezed.dart';
part 'game_models.g.dart';

/// 玩家枚举
enum Player { x, o }

/// 游戏状态枚举
enum GameStatus { playing, xWins, oWins, draw }

/// 消息类型枚举
enum MessageType {
  // 房间相关
  createRoom,
  joinRoom,
  leaveRoom,
  roomCreated,
  roomJoined,
  roomLeft,
  playerJoined,
  playerLeft,

  // 游戏相关
  gameMove,
  gameUpdate,
  gameReset,
  gameOver,

  // 错误处理
  error,

  // 心跳
  ping,
  pong,
}

/// 游戏状态
@freezed
class GameState with _$GameState {
  const factory GameState({
    @Default([null, null, null, null, null, null, null, null, null])
    List<Player?> board,
    @Default(Player.x) Player currentPlayer,
    @Default(GameStatus.playing) GameStatus status,
    @Default(false) bool isAiMode,
    @Default(true) bool isPlayerXHuman,
  }) = _GameState;

  factory GameState.fromJson(Map<String, dynamic> json) =>
      _$GameStateFromJson(json);
}

/// 网络消息
@freezed
class NetworkMessage with _$NetworkMessage {
  const factory NetworkMessage({
    required MessageType type,
    String? roomId,
    String? playerId,
    Map<String, dynamic>? data,
    String? error,
    @Default(0) int timestamp,
  }) = _NetworkMessage;

  factory NetworkMessage.fromJson(Map<String, dynamic> json) =>
      _$NetworkMessageFromJson(json);
}

/// 房间信息
@freezed
class RoomInfo with _$RoomInfo {
  const factory RoomInfo({
    required String roomId,
    required List<PlayerInfo> players,
    GameState? gameState,
    @Default(false) bool isGameStarted,
    @Default(0) int createdAt,
  }) = _RoomInfo;

  factory RoomInfo.fromJson(Map<String, dynamic> json) =>
      _$RoomInfoFromJson(json);
}

/// 玩家信息
@freezed
class PlayerInfo with _$PlayerInfo {
  const factory PlayerInfo({
    required String playerId,
    required String playerName,
    Player? playerSymbol,
    @Default(false) bool isReady,
    @Default(0) int joinedAt,
  }) = _PlayerInfo;

  factory PlayerInfo.fromJson(Map<String, dynamic> json) =>
      _$PlayerInfoFromJson(json);
}

/// 游戏移动信息
@freezed
class GameMoveData with _$GameMoveData {
  const factory GameMoveData({
    required int position,
    required Player player,
    required String playerId,
    @Default(0) int timestamp,
  }) = _GameMoveData;

  factory GameMoveData.fromJson(Map<String, dynamic> json) =>
      _$GameMoveDataFromJson(json);
}

/// 游戏状态扩展方法
extension GameStateX on GameState {
  /// 检查是否有玩家获胜
  GameStatus checkWinStatus() {
    // 获胜组合
    const winPatterns = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // 行
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // 列
      [0, 4, 8], [2, 4, 6], // 对角线
    ];

    for (final pattern in winPatterns) {
      final a = board[pattern[0]];
      final b = board[pattern[1]];
      final c = board[pattern[2]];

      if (a != null && a == b && b == c) {
        return a == Player.x ? GameStatus.xWins : GameStatus.oWins;
      }
    }

    // 检查平局
    if (board.every((cell) => cell != null)) {
      return GameStatus.draw;
    }

    return GameStatus.playing;
  }

  /// 检查位置是否可以下棋
  bool canMakeMove(int index) {
    return index >= 0 &&
        index < 9 &&
        board[index] == null &&
        status == GameStatus.playing;
  }

  /// 获取空位置列表
  List<int> get emptyCells {
    final empty = <int>[];
    for (int i = 0; i < board.length; i++) {
      if (board[i] == null) {
        empty.add(i);
      }
    }
    return empty;
  }
}
