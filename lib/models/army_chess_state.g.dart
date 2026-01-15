// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'army_chess_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ArmyPieceImpl _$$ArmyPieceImplFromJson(Map<String, dynamic> json) =>
    _$ArmyPieceImpl(
      type: $enumDecode(_$ArmyPieceTypeEnumMap, json['type']),
      side: $enumDecode(_$ArmySideEnumMap, json['side']),
      isFaceUp: json['isFaceUp'] as bool? ?? false,
    );

Map<String, dynamic> _$$ArmyPieceImplToJson(_$ArmyPieceImpl instance) =>
    <String, dynamic>{
      'type': _$ArmyPieceTypeEnumMap[instance.type]!,
      'side': _$ArmySideEnumMap[instance.side]!,
      'isFaceUp': instance.isFaceUp,
    };

const _$ArmyPieceTypeEnumMap = {
  ArmyPieceType.commander: 'commander',
  ArmyPieceType.general: 'general',
  ArmyPieceType.division: 'division',
  ArmyPieceType.brigade: 'brigade',
  ArmyPieceType.regiment: 'regiment',
  ArmyPieceType.battalion: 'battalion',
  ArmyPieceType.company: 'company',
  ArmyPieceType.platoon: 'platoon',
  ArmyPieceType.engineer: 'engineer',
  ArmyPieceType.landmine: 'landmine',
  ArmyPieceType.bomb: 'bomb',
  ArmyPieceType.flag: 'flag',
};

const _$ArmySideEnumMap = {ArmySide.red: 'red', ArmySide.blue: 'blue'};

_$ArmyChessStateImpl _$$ArmyChessStateImplFromJson(Map<String, dynamic> json) =>
    _$ArmyChessStateImpl(
      board:
          (json['board'] as List<dynamic>?)
              ?.map(
                (e) => e == null
                    ? null
                    : ArmyPiece.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      currentPlayer:
          $enumDecodeNullable(_$ArmySideEnumMap, json['currentPlayer']) ??
          ArmySide.red,
      playerSide: $enumDecodeNullable(_$ArmySideEnumMap, json['playerSide']),
      status:
          $enumDecodeNullable(_$ArmyGameStatusEnumMap, json['status']) ??
          ArmyGameStatus.playing,
      selectedIndex: (json['selectedIndex'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ArmyChessStateImplToJson(
  _$ArmyChessStateImpl instance,
) => <String, dynamic>{
  'board': instance.board,
  'currentPlayer': _$ArmySideEnumMap[instance.currentPlayer]!,
  'playerSide': _$ArmySideEnumMap[instance.playerSide],
  'status': _$ArmyGameStatusEnumMap[instance.status]!,
  'selectedIndex': instance.selectedIndex,
};

const _$ArmyGameStatusEnumMap = {
  ArmyGameStatus.playing: 'playing',
  ArmyGameStatus.redWins: 'redWins',
  ArmyGameStatus.blueWins: 'blueWins',
};
