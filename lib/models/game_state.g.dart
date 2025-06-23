// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state.dart';

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
