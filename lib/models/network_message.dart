import 'package:freezed_annotation/freezed_annotation.dart';
import 'game_state.dart';

part 'network_message.freezed.dart';
part 'network_message.g.dart';

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

/// 网络消息基类
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
