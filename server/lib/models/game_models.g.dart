// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GameStateImpl _$$GameStateImplFromJson(Map<String, dynamic> json) =>
    _$GameStateImpl(
      board:
          (json['board'] as List<dynamic>?)
              ?.map((e) => $enumDecodeNullable(_$PlayerEnumMap, e))
              .toList() ??
          const [null, null, null, null, null, null, null, null, null],
      currentPlayer:
          $enumDecodeNullable(_$PlayerEnumMap, json['currentPlayer']) ??
          Player.x,
      status:
          $enumDecodeNullable(_$GameStatusEnumMap, json['status']) ??
          GameStatus.playing,
      isAiMode: json['isAiMode'] as bool? ?? false,
      isPlayerXHuman: json['isPlayerXHuman'] as bool? ?? true,
    );

Map<String, dynamic> _$$GameStateImplToJson(_$GameStateImpl instance) =>
    <String, dynamic>{
      'board': instance.board.map((e) => _$PlayerEnumMap[e]).toList(),
      'currentPlayer': _$PlayerEnumMap[instance.currentPlayer]!,
      'status': _$GameStatusEnumMap[instance.status]!,
      'isAiMode': instance.isAiMode,
      'isPlayerXHuman': instance.isPlayerXHuman,
    };

const _$PlayerEnumMap = {Player.x: 'x', Player.o: 'o'};

const _$GameStatusEnumMap = {
  GameStatus.playing: 'playing',
  GameStatus.xWins: 'xWins',
  GameStatus.oWins: 'oWins',
  GameStatus.draw: 'draw',
};

_$NetworkMessageImpl _$$NetworkMessageImplFromJson(Map<String, dynamic> json) =>
    _$NetworkMessageImpl(
      type: $enumDecode(_$MessageTypeEnumMap, json['type']),
      roomId: json['roomId'] as String?,
      playerId: json['playerId'] as String?,
      data: json['data'] as Map<String, dynamic>?,
      error: json['error'] as String?,
      timestamp: (json['timestamp'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$NetworkMessageImplToJson(
  _$NetworkMessageImpl instance,
) => <String, dynamic>{
  'type': _$MessageTypeEnumMap[instance.type]!,
  'roomId': instance.roomId,
  'playerId': instance.playerId,
  'data': instance.data,
  'error': instance.error,
  'timestamp': instance.timestamp,
};

const _$MessageTypeEnumMap = {
  MessageType.createRoom: 'createRoom',
  MessageType.joinRoom: 'joinRoom',
  MessageType.leaveRoom: 'leaveRoom',
  MessageType.roomCreated: 'roomCreated',
  MessageType.roomJoined: 'roomJoined',
  MessageType.roomLeft: 'roomLeft',
  MessageType.playerJoined: 'playerJoined',
  MessageType.playerLeft: 'playerLeft',
  MessageType.gameMove: 'gameMove',
  MessageType.gameUpdate: 'gameUpdate',
  MessageType.gameReset: 'gameReset',
  MessageType.gameOver: 'gameOver',
  MessageType.error: 'error',
  MessageType.ping: 'ping',
  MessageType.pong: 'pong',
};

_$RoomInfoImpl _$$RoomInfoImplFromJson(Map<String, dynamic> json) =>
    _$RoomInfoImpl(
      roomId: json['roomId'] as String,
      players: (json['players'] as List<dynamic>)
          .map((e) => PlayerInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      gameState: json['gameState'] == null
          ? null
          : GameState.fromJson(json['gameState'] as Map<String, dynamic>),
      isGameStarted: json['isGameStarted'] as bool? ?? false,
      createdAt: (json['createdAt'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$RoomInfoImplToJson(_$RoomInfoImpl instance) =>
    <String, dynamic>{
      'roomId': instance.roomId,
      'players': instance.players,
      'gameState': instance.gameState,
      'isGameStarted': instance.isGameStarted,
      'createdAt': instance.createdAt,
    };

_$PlayerInfoImpl _$$PlayerInfoImplFromJson(Map<String, dynamic> json) =>
    _$PlayerInfoImpl(
      playerId: json['playerId'] as String,
      playerName: json['playerName'] as String,
      playerSymbol: $enumDecodeNullable(_$PlayerEnumMap, json['playerSymbol']),
      isReady: json['isReady'] as bool? ?? false,
      joinedAt: (json['joinedAt'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$PlayerInfoImplToJson(_$PlayerInfoImpl instance) =>
    <String, dynamic>{
      'playerId': instance.playerId,
      'playerName': instance.playerName,
      'playerSymbol': _$PlayerEnumMap[instance.playerSymbol],
      'isReady': instance.isReady,
      'joinedAt': instance.joinedAt,
    };

_$GameMoveDataImpl _$$GameMoveDataImplFromJson(Map<String, dynamic> json) =>
    _$GameMoveDataImpl(
      position: (json['position'] as num).toInt(),
      player: $enumDecode(_$PlayerEnumMap, json['player']),
      playerId: json['playerId'] as String,
      timestamp: (json['timestamp'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$GameMoveDataImplToJson(_$GameMoveDataImpl instance) =>
    <String, dynamic>{
      'position': instance.position,
      'player': _$PlayerEnumMap[instance.player]!,
      'playerId': instance.playerId,
      'timestamp': instance.timestamp,
    };
