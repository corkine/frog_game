// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'online_game.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$OnlineGameState {
  GameState get gameState => throw _privateConstructorUsedError;
  ConnectionStatus get connectionStatus => throw _privateConstructorUsedError;
  RoomInfo? get roomInfo => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  PlayerInfo? get myPlayerInfo => throw _privateConstructorUsedError;
  Player? get mySymbol => throw _privateConstructorUsedError;
  bool get isJoiningRoom => throw _privateConstructorUsedError;

  /// Create a copy of OnlineGameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OnlineGameStateCopyWith<OnlineGameState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OnlineGameStateCopyWith<$Res> {
  factory $OnlineGameStateCopyWith(
    OnlineGameState value,
    $Res Function(OnlineGameState) then,
  ) = _$OnlineGameStateCopyWithImpl<$Res, OnlineGameState>;
  @useResult
  $Res call({
    GameState gameState,
    ConnectionStatus connectionStatus,
    RoomInfo? roomInfo,
    String? error,
    PlayerInfo? myPlayerInfo,
    Player? mySymbol,
    bool isJoiningRoom,
  });

  $GameStateCopyWith<$Res> get gameState;
  $RoomInfoCopyWith<$Res>? get roomInfo;
  $PlayerInfoCopyWith<$Res>? get myPlayerInfo;
}

/// @nodoc
class _$OnlineGameStateCopyWithImpl<$Res, $Val extends OnlineGameState>
    implements $OnlineGameStateCopyWith<$Res> {
  _$OnlineGameStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OnlineGameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gameState = null,
    Object? connectionStatus = null,
    Object? roomInfo = freezed,
    Object? error = freezed,
    Object? myPlayerInfo = freezed,
    Object? mySymbol = freezed,
    Object? isJoiningRoom = null,
  }) {
    return _then(
      _value.copyWith(
            gameState: null == gameState
                ? _value.gameState
                : gameState // ignore: cast_nullable_to_non_nullable
                      as GameState,
            connectionStatus: null == connectionStatus
                ? _value.connectionStatus
                : connectionStatus // ignore: cast_nullable_to_non_nullable
                      as ConnectionStatus,
            roomInfo: freezed == roomInfo
                ? _value.roomInfo
                : roomInfo // ignore: cast_nullable_to_non_nullable
                      as RoomInfo?,
            error: freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as String?,
            myPlayerInfo: freezed == myPlayerInfo
                ? _value.myPlayerInfo
                : myPlayerInfo // ignore: cast_nullable_to_non_nullable
                      as PlayerInfo?,
            mySymbol: freezed == mySymbol
                ? _value.mySymbol
                : mySymbol // ignore: cast_nullable_to_non_nullable
                      as Player?,
            isJoiningRoom: null == isJoiningRoom
                ? _value.isJoiningRoom
                : isJoiningRoom // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of OnlineGameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GameStateCopyWith<$Res> get gameState {
    return $GameStateCopyWith<$Res>(_value.gameState, (value) {
      return _then(_value.copyWith(gameState: value) as $Val);
    });
  }

  /// Create a copy of OnlineGameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RoomInfoCopyWith<$Res>? get roomInfo {
    if (_value.roomInfo == null) {
      return null;
    }

    return $RoomInfoCopyWith<$Res>(_value.roomInfo!, (value) {
      return _then(_value.copyWith(roomInfo: value) as $Val);
    });
  }

  /// Create a copy of OnlineGameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PlayerInfoCopyWith<$Res>? get myPlayerInfo {
    if (_value.myPlayerInfo == null) {
      return null;
    }

    return $PlayerInfoCopyWith<$Res>(_value.myPlayerInfo!, (value) {
      return _then(_value.copyWith(myPlayerInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OnlineGameStateImplCopyWith<$Res>
    implements $OnlineGameStateCopyWith<$Res> {
  factory _$$OnlineGameStateImplCopyWith(
    _$OnlineGameStateImpl value,
    $Res Function(_$OnlineGameStateImpl) then,
  ) = __$$OnlineGameStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    GameState gameState,
    ConnectionStatus connectionStatus,
    RoomInfo? roomInfo,
    String? error,
    PlayerInfo? myPlayerInfo,
    Player? mySymbol,
    bool isJoiningRoom,
  });

  @override
  $GameStateCopyWith<$Res> get gameState;
  @override
  $RoomInfoCopyWith<$Res>? get roomInfo;
  @override
  $PlayerInfoCopyWith<$Res>? get myPlayerInfo;
}

/// @nodoc
class __$$OnlineGameStateImplCopyWithImpl<$Res>
    extends _$OnlineGameStateCopyWithImpl<$Res, _$OnlineGameStateImpl>
    implements _$$OnlineGameStateImplCopyWith<$Res> {
  __$$OnlineGameStateImplCopyWithImpl(
    _$OnlineGameStateImpl _value,
    $Res Function(_$OnlineGameStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OnlineGameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gameState = null,
    Object? connectionStatus = null,
    Object? roomInfo = freezed,
    Object? error = freezed,
    Object? myPlayerInfo = freezed,
    Object? mySymbol = freezed,
    Object? isJoiningRoom = null,
  }) {
    return _then(
      _$OnlineGameStateImpl(
        gameState: null == gameState
            ? _value.gameState
            : gameState // ignore: cast_nullable_to_non_nullable
                  as GameState,
        connectionStatus: null == connectionStatus
            ? _value.connectionStatus
            : connectionStatus // ignore: cast_nullable_to_non_nullable
                  as ConnectionStatus,
        roomInfo: freezed == roomInfo
            ? _value.roomInfo
            : roomInfo // ignore: cast_nullable_to_non_nullable
                  as RoomInfo?,
        error: freezed == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
        myPlayerInfo: freezed == myPlayerInfo
            ? _value.myPlayerInfo
            : myPlayerInfo // ignore: cast_nullable_to_non_nullable
                  as PlayerInfo?,
        mySymbol: freezed == mySymbol
            ? _value.mySymbol
            : mySymbol // ignore: cast_nullable_to_non_nullable
                  as Player?,
        isJoiningRoom: null == isJoiningRoom
            ? _value.isJoiningRoom
            : isJoiningRoom // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$OnlineGameStateImpl extends _OnlineGameState
    with DiagnosticableTreeMixin {
  const _$OnlineGameStateImpl({
    this.gameState = const GameState(),
    this.connectionStatus = ConnectionStatus.initial,
    this.roomInfo,
    this.error,
    this.myPlayerInfo,
    this.mySymbol,
    this.isJoiningRoom = false,
  }) : super._();

  @override
  @JsonKey()
  final GameState gameState;
  @override
  @JsonKey()
  final ConnectionStatus connectionStatus;
  @override
  final RoomInfo? roomInfo;
  @override
  final String? error;
  @override
  final PlayerInfo? myPlayerInfo;
  @override
  final Player? mySymbol;
  @override
  @JsonKey()
  final bool isJoiningRoom;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'OnlineGameState(gameState: $gameState, connectionStatus: $connectionStatus, roomInfo: $roomInfo, error: $error, myPlayerInfo: $myPlayerInfo, mySymbol: $mySymbol, isJoiningRoom: $isJoiningRoom)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'OnlineGameState'))
      ..add(DiagnosticsProperty('gameState', gameState))
      ..add(DiagnosticsProperty('connectionStatus', connectionStatus))
      ..add(DiagnosticsProperty('roomInfo', roomInfo))
      ..add(DiagnosticsProperty('error', error))
      ..add(DiagnosticsProperty('myPlayerInfo', myPlayerInfo))
      ..add(DiagnosticsProperty('mySymbol', mySymbol))
      ..add(DiagnosticsProperty('isJoiningRoom', isJoiningRoom));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnlineGameStateImpl &&
            (identical(other.gameState, gameState) ||
                other.gameState == gameState) &&
            (identical(other.connectionStatus, connectionStatus) ||
                other.connectionStatus == connectionStatus) &&
            (identical(other.roomInfo, roomInfo) ||
                other.roomInfo == roomInfo) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.myPlayerInfo, myPlayerInfo) ||
                other.myPlayerInfo == myPlayerInfo) &&
            (identical(other.mySymbol, mySymbol) ||
                other.mySymbol == mySymbol) &&
            (identical(other.isJoiningRoom, isJoiningRoom) ||
                other.isJoiningRoom == isJoiningRoom));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    gameState,
    connectionStatus,
    roomInfo,
    error,
    myPlayerInfo,
    mySymbol,
    isJoiningRoom,
  );

  /// Create a copy of OnlineGameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OnlineGameStateImplCopyWith<_$OnlineGameStateImpl> get copyWith =>
      __$$OnlineGameStateImplCopyWithImpl<_$OnlineGameStateImpl>(
        this,
        _$identity,
      );
}

abstract class _OnlineGameState extends OnlineGameState {
  const factory _OnlineGameState({
    final GameState gameState,
    final ConnectionStatus connectionStatus,
    final RoomInfo? roomInfo,
    final String? error,
    final PlayerInfo? myPlayerInfo,
    final Player? mySymbol,
    final bool isJoiningRoom,
  }) = _$OnlineGameStateImpl;
  const _OnlineGameState._() : super._();

  @override
  GameState get gameState;
  @override
  ConnectionStatus get connectionStatus;
  @override
  RoomInfo? get roomInfo;
  @override
  String? get error;
  @override
  PlayerInfo? get myPlayerInfo;
  @override
  Player? get mySymbol;
  @override
  bool get isJoiningRoom;

  /// Create a copy of OnlineGameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OnlineGameStateImplCopyWith<_$OnlineGameStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
