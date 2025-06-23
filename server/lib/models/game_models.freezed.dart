// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GameState _$GameStateFromJson(Map<String, dynamic> json) {
  return _GameState.fromJson(json);
}

/// @nodoc
mixin _$GameState {
  List<Player?> get board => throw _privateConstructorUsedError;
  Player get currentPlayer => throw _privateConstructorUsedError;
  GameStatus get status => throw _privateConstructorUsedError;
  bool get isAiMode => throw _privateConstructorUsedError;
  bool get isPlayerXHuman => throw _privateConstructorUsedError;

  /// Serializes this GameState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameStateCopyWith<GameState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameStateCopyWith<$Res> {
  factory $GameStateCopyWith(GameState value, $Res Function(GameState) then) =
      _$GameStateCopyWithImpl<$Res, GameState>;
  @useResult
  $Res call({
    List<Player?> board,
    Player currentPlayer,
    GameStatus status,
    bool isAiMode,
    bool isPlayerXHuman,
  });
}

/// @nodoc
class _$GameStateCopyWithImpl<$Res, $Val extends GameState>
    implements $GameStateCopyWith<$Res> {
  _$GameStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? board = null,
    Object? currentPlayer = null,
    Object? status = null,
    Object? isAiMode = null,
    Object? isPlayerXHuman = null,
  }) {
    return _then(
      _value.copyWith(
            board: null == board
                ? _value.board
                : board // ignore: cast_nullable_to_non_nullable
                      as List<Player?>,
            currentPlayer: null == currentPlayer
                ? _value.currentPlayer
                : currentPlayer // ignore: cast_nullable_to_non_nullable
                      as Player,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as GameStatus,
            isAiMode: null == isAiMode
                ? _value.isAiMode
                : isAiMode // ignore: cast_nullable_to_non_nullable
                      as bool,
            isPlayerXHuman: null == isPlayerXHuman
                ? _value.isPlayerXHuman
                : isPlayerXHuman // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GameStateImplCopyWith<$Res>
    implements $GameStateCopyWith<$Res> {
  factory _$$GameStateImplCopyWith(
    _$GameStateImpl value,
    $Res Function(_$GameStateImpl) then,
  ) = __$$GameStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<Player?> board,
    Player currentPlayer,
    GameStatus status,
    bool isAiMode,
    bool isPlayerXHuman,
  });
}

/// @nodoc
class __$$GameStateImplCopyWithImpl<$Res>
    extends _$GameStateCopyWithImpl<$Res, _$GameStateImpl>
    implements _$$GameStateImplCopyWith<$Res> {
  __$$GameStateImplCopyWithImpl(
    _$GameStateImpl _value,
    $Res Function(_$GameStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? board = null,
    Object? currentPlayer = null,
    Object? status = null,
    Object? isAiMode = null,
    Object? isPlayerXHuman = null,
  }) {
    return _then(
      _$GameStateImpl(
        board: null == board
            ? _value._board
            : board // ignore: cast_nullable_to_non_nullable
                  as List<Player?>,
        currentPlayer: null == currentPlayer
            ? _value.currentPlayer
            : currentPlayer // ignore: cast_nullable_to_non_nullable
                  as Player,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as GameStatus,
        isAiMode: null == isAiMode
            ? _value.isAiMode
            : isAiMode // ignore: cast_nullable_to_non_nullable
                  as bool,
        isPlayerXHuman: null == isPlayerXHuman
            ? _value.isPlayerXHuman
            : isPlayerXHuman // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GameStateImpl implements _GameState {
  const _$GameStateImpl({
    final List<Player?> board = const [
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
    ],
    this.currentPlayer = Player.x,
    this.status = GameStatus.playing,
    this.isAiMode = false,
    this.isPlayerXHuman = true,
  }) : _board = board;

  factory _$GameStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameStateImplFromJson(json);

  final List<Player?> _board;
  @override
  @JsonKey()
  List<Player?> get board {
    if (_board is EqualUnmodifiableListView) return _board;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_board);
  }

  @override
  @JsonKey()
  final Player currentPlayer;
  @override
  @JsonKey()
  final GameStatus status;
  @override
  @JsonKey()
  final bool isAiMode;
  @override
  @JsonKey()
  final bool isPlayerXHuman;

  @override
  String toString() {
    return 'GameState(board: $board, currentPlayer: $currentPlayer, status: $status, isAiMode: $isAiMode, isPlayerXHuman: $isPlayerXHuman)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameStateImpl &&
            const DeepCollectionEquality().equals(other._board, _board) &&
            (identical(other.currentPlayer, currentPlayer) ||
                other.currentPlayer == currentPlayer) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isAiMode, isAiMode) ||
                other.isAiMode == isAiMode) &&
            (identical(other.isPlayerXHuman, isPlayerXHuman) ||
                other.isPlayerXHuman == isPlayerXHuman));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_board),
    currentPlayer,
    status,
    isAiMode,
    isPlayerXHuman,
  );

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameStateImplCopyWith<_$GameStateImpl> get copyWith =>
      __$$GameStateImplCopyWithImpl<_$GameStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GameStateImplToJson(this);
  }
}

abstract class _GameState implements GameState {
  const factory _GameState({
    final List<Player?> board,
    final Player currentPlayer,
    final GameStatus status,
    final bool isAiMode,
    final bool isPlayerXHuman,
  }) = _$GameStateImpl;

  factory _GameState.fromJson(Map<String, dynamic> json) =
      _$GameStateImpl.fromJson;

  @override
  List<Player?> get board;
  @override
  Player get currentPlayer;
  @override
  GameStatus get status;
  @override
  bool get isAiMode;
  @override
  bool get isPlayerXHuman;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameStateImplCopyWith<_$GameStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NetworkMessage _$NetworkMessageFromJson(Map<String, dynamic> json) {
  return _NetworkMessage.fromJson(json);
}

/// @nodoc
mixin _$NetworkMessage {
  MessageType get type => throw _privateConstructorUsedError;
  String? get roomId => throw _privateConstructorUsedError;
  String? get playerId => throw _privateConstructorUsedError;
  Map<String, dynamic>? get data => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  int get timestamp => throw _privateConstructorUsedError;

  /// Serializes this NetworkMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NetworkMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NetworkMessageCopyWith<NetworkMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NetworkMessageCopyWith<$Res> {
  factory $NetworkMessageCopyWith(
    NetworkMessage value,
    $Res Function(NetworkMessage) then,
  ) = _$NetworkMessageCopyWithImpl<$Res, NetworkMessage>;
  @useResult
  $Res call({
    MessageType type,
    String? roomId,
    String? playerId,
    Map<String, dynamic>? data,
    String? error,
    int timestamp,
  });
}

/// @nodoc
class _$NetworkMessageCopyWithImpl<$Res, $Val extends NetworkMessage>
    implements $NetworkMessageCopyWith<$Res> {
  _$NetworkMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NetworkMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? roomId = freezed,
    Object? playerId = freezed,
    Object? data = freezed,
    Object? error = freezed,
    Object? timestamp = null,
  }) {
    return _then(
      _value.copyWith(
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as MessageType,
            roomId: freezed == roomId
                ? _value.roomId
                : roomId // ignore: cast_nullable_to_non_nullable
                      as String?,
            playerId: freezed == playerId
                ? _value.playerId
                : playerId // ignore: cast_nullable_to_non_nullable
                      as String?,
            data: freezed == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            error: freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as String?,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NetworkMessageImplCopyWith<$Res>
    implements $NetworkMessageCopyWith<$Res> {
  factory _$$NetworkMessageImplCopyWith(
    _$NetworkMessageImpl value,
    $Res Function(_$NetworkMessageImpl) then,
  ) = __$$NetworkMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    MessageType type,
    String? roomId,
    String? playerId,
    Map<String, dynamic>? data,
    String? error,
    int timestamp,
  });
}

/// @nodoc
class __$$NetworkMessageImplCopyWithImpl<$Res>
    extends _$NetworkMessageCopyWithImpl<$Res, _$NetworkMessageImpl>
    implements _$$NetworkMessageImplCopyWith<$Res> {
  __$$NetworkMessageImplCopyWithImpl(
    _$NetworkMessageImpl _value,
    $Res Function(_$NetworkMessageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NetworkMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? roomId = freezed,
    Object? playerId = freezed,
    Object? data = freezed,
    Object? error = freezed,
    Object? timestamp = null,
  }) {
    return _then(
      _$NetworkMessageImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as MessageType,
        roomId: freezed == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String?,
        playerId: freezed == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String?,
        data: freezed == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        error: freezed == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NetworkMessageImpl implements _NetworkMessage {
  const _$NetworkMessageImpl({
    required this.type,
    this.roomId,
    this.playerId,
    final Map<String, dynamic>? data,
    this.error,
    this.timestamp = 0,
  }) : _data = data;

  factory _$NetworkMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$NetworkMessageImplFromJson(json);

  @override
  final MessageType type;
  @override
  final String? roomId;
  @override
  final String? playerId;
  final Map<String, dynamic>? _data;
  @override
  Map<String, dynamic>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? error;
  @override
  @JsonKey()
  final int timestamp;

  @override
  String toString() {
    return 'NetworkMessage(type: $type, roomId: $roomId, playerId: $playerId, data: $data, error: $error, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetworkMessageImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    type,
    roomId,
    playerId,
    const DeepCollectionEquality().hash(_data),
    error,
    timestamp,
  );

  /// Create a copy of NetworkMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NetworkMessageImplCopyWith<_$NetworkMessageImpl> get copyWith =>
      __$$NetworkMessageImplCopyWithImpl<_$NetworkMessageImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$NetworkMessageImplToJson(this);
  }
}

abstract class _NetworkMessage implements NetworkMessage {
  const factory _NetworkMessage({
    required final MessageType type,
    final String? roomId,
    final String? playerId,
    final Map<String, dynamic>? data,
    final String? error,
    final int timestamp,
  }) = _$NetworkMessageImpl;

  factory _NetworkMessage.fromJson(Map<String, dynamic> json) =
      _$NetworkMessageImpl.fromJson;

  @override
  MessageType get type;
  @override
  String? get roomId;
  @override
  String? get playerId;
  @override
  Map<String, dynamic>? get data;
  @override
  String? get error;
  @override
  int get timestamp;

  /// Create a copy of NetworkMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NetworkMessageImplCopyWith<_$NetworkMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RoomInfo _$RoomInfoFromJson(Map<String, dynamic> json) {
  return _RoomInfo.fromJson(json);
}

/// @nodoc
mixin _$RoomInfo {
  String get roomId => throw _privateConstructorUsedError;
  List<PlayerInfo> get players => throw _privateConstructorUsedError;
  GameState? get gameState => throw _privateConstructorUsedError;
  bool get isGameStarted => throw _privateConstructorUsedError;
  int get createdAt => throw _privateConstructorUsedError;

  /// Serializes this RoomInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RoomInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RoomInfoCopyWith<RoomInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoomInfoCopyWith<$Res> {
  factory $RoomInfoCopyWith(RoomInfo value, $Res Function(RoomInfo) then) =
      _$RoomInfoCopyWithImpl<$Res, RoomInfo>;
  @useResult
  $Res call({
    String roomId,
    List<PlayerInfo> players,
    GameState? gameState,
    bool isGameStarted,
    int createdAt,
  });

  $GameStateCopyWith<$Res>? get gameState;
}

/// @nodoc
class _$RoomInfoCopyWithImpl<$Res, $Val extends RoomInfo>
    implements $RoomInfoCopyWith<$Res> {
  _$RoomInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RoomInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? players = null,
    Object? gameState = freezed,
    Object? isGameStarted = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            roomId: null == roomId
                ? _value.roomId
                : roomId // ignore: cast_nullable_to_non_nullable
                      as String,
            players: null == players
                ? _value.players
                : players // ignore: cast_nullable_to_non_nullable
                      as List<PlayerInfo>,
            gameState: freezed == gameState
                ? _value.gameState
                : gameState // ignore: cast_nullable_to_non_nullable
                      as GameState?,
            isGameStarted: null == isGameStarted
                ? _value.isGameStarted
                : isGameStarted // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }

  /// Create a copy of RoomInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GameStateCopyWith<$Res>? get gameState {
    if (_value.gameState == null) {
      return null;
    }

    return $GameStateCopyWith<$Res>(_value.gameState!, (value) {
      return _then(_value.copyWith(gameState: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RoomInfoImplCopyWith<$Res>
    implements $RoomInfoCopyWith<$Res> {
  factory _$$RoomInfoImplCopyWith(
    _$RoomInfoImpl value,
    $Res Function(_$RoomInfoImpl) then,
  ) = __$$RoomInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String roomId,
    List<PlayerInfo> players,
    GameState? gameState,
    bool isGameStarted,
    int createdAt,
  });

  @override
  $GameStateCopyWith<$Res>? get gameState;
}

/// @nodoc
class __$$RoomInfoImplCopyWithImpl<$Res>
    extends _$RoomInfoCopyWithImpl<$Res, _$RoomInfoImpl>
    implements _$$RoomInfoImplCopyWith<$Res> {
  __$$RoomInfoImplCopyWithImpl(
    _$RoomInfoImpl _value,
    $Res Function(_$RoomInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RoomInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? players = null,
    Object? gameState = freezed,
    Object? isGameStarted = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$RoomInfoImpl(
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
        players: null == players
            ? _value._players
            : players // ignore: cast_nullable_to_non_nullable
                  as List<PlayerInfo>,
        gameState: freezed == gameState
            ? _value.gameState
            : gameState // ignore: cast_nullable_to_non_nullable
                  as GameState?,
        isGameStarted: null == isGameStarted
            ? _value.isGameStarted
            : isGameStarted // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RoomInfoImpl implements _RoomInfo {
  const _$RoomInfoImpl({
    required this.roomId,
    required final List<PlayerInfo> players,
    this.gameState,
    this.isGameStarted = false,
    this.createdAt = 0,
  }) : _players = players;

  factory _$RoomInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoomInfoImplFromJson(json);

  @override
  final String roomId;
  final List<PlayerInfo> _players;
  @override
  List<PlayerInfo> get players {
    if (_players is EqualUnmodifiableListView) return _players;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_players);
  }

  @override
  final GameState? gameState;
  @override
  @JsonKey()
  final bool isGameStarted;
  @override
  @JsonKey()
  final int createdAt;

  @override
  String toString() {
    return 'RoomInfo(roomId: $roomId, players: $players, gameState: $gameState, isGameStarted: $isGameStarted, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoomInfoImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            const DeepCollectionEquality().equals(other._players, _players) &&
            (identical(other.gameState, gameState) ||
                other.gameState == gameState) &&
            (identical(other.isGameStarted, isGameStarted) ||
                other.isGameStarted == isGameStarted) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    roomId,
    const DeepCollectionEquality().hash(_players),
    gameState,
    isGameStarted,
    createdAt,
  );

  /// Create a copy of RoomInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoomInfoImplCopyWith<_$RoomInfoImpl> get copyWith =>
      __$$RoomInfoImplCopyWithImpl<_$RoomInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoomInfoImplToJson(this);
  }
}

abstract class _RoomInfo implements RoomInfo {
  const factory _RoomInfo({
    required final String roomId,
    required final List<PlayerInfo> players,
    final GameState? gameState,
    final bool isGameStarted,
    final int createdAt,
  }) = _$RoomInfoImpl;

  factory _RoomInfo.fromJson(Map<String, dynamic> json) =
      _$RoomInfoImpl.fromJson;

  @override
  String get roomId;
  @override
  List<PlayerInfo> get players;
  @override
  GameState? get gameState;
  @override
  bool get isGameStarted;
  @override
  int get createdAt;

  /// Create a copy of RoomInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoomInfoImplCopyWith<_$RoomInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PlayerInfo _$PlayerInfoFromJson(Map<String, dynamic> json) {
  return _PlayerInfo.fromJson(json);
}

/// @nodoc
mixin _$PlayerInfo {
  String get playerId => throw _privateConstructorUsedError;
  String get playerName => throw _privateConstructorUsedError;
  Player? get playerSymbol => throw _privateConstructorUsedError;
  bool get isReady => throw _privateConstructorUsedError;
  int get joinedAt => throw _privateConstructorUsedError;

  /// Serializes this PlayerInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlayerInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerInfoCopyWith<PlayerInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerInfoCopyWith<$Res> {
  factory $PlayerInfoCopyWith(
    PlayerInfo value,
    $Res Function(PlayerInfo) then,
  ) = _$PlayerInfoCopyWithImpl<$Res, PlayerInfo>;
  @useResult
  $Res call({
    String playerId,
    String playerName,
    Player? playerSymbol,
    bool isReady,
    int joinedAt,
  });
}

/// @nodoc
class _$PlayerInfoCopyWithImpl<$Res, $Val extends PlayerInfo>
    implements $PlayerInfoCopyWith<$Res> {
  _$PlayerInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? playerName = null,
    Object? playerSymbol = freezed,
    Object? isReady = null,
    Object? joinedAt = null,
  }) {
    return _then(
      _value.copyWith(
            playerId: null == playerId
                ? _value.playerId
                : playerId // ignore: cast_nullable_to_non_nullable
                      as String,
            playerName: null == playerName
                ? _value.playerName
                : playerName // ignore: cast_nullable_to_non_nullable
                      as String,
            playerSymbol: freezed == playerSymbol
                ? _value.playerSymbol
                : playerSymbol // ignore: cast_nullable_to_non_nullable
                      as Player?,
            isReady: null == isReady
                ? _value.isReady
                : isReady // ignore: cast_nullable_to_non_nullable
                      as bool,
            joinedAt: null == joinedAt
                ? _value.joinedAt
                : joinedAt // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlayerInfoImplCopyWith<$Res>
    implements $PlayerInfoCopyWith<$Res> {
  factory _$$PlayerInfoImplCopyWith(
    _$PlayerInfoImpl value,
    $Res Function(_$PlayerInfoImpl) then,
  ) = __$$PlayerInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String playerId,
    String playerName,
    Player? playerSymbol,
    bool isReady,
    int joinedAt,
  });
}

/// @nodoc
class __$$PlayerInfoImplCopyWithImpl<$Res>
    extends _$PlayerInfoCopyWithImpl<$Res, _$PlayerInfoImpl>
    implements _$$PlayerInfoImplCopyWith<$Res> {
  __$$PlayerInfoImplCopyWithImpl(
    _$PlayerInfoImpl _value,
    $Res Function(_$PlayerInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlayerInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? playerName = null,
    Object? playerSymbol = freezed,
    Object? isReady = null,
    Object? joinedAt = null,
  }) {
    return _then(
      _$PlayerInfoImpl(
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
        playerName: null == playerName
            ? _value.playerName
            : playerName // ignore: cast_nullable_to_non_nullable
                  as String,
        playerSymbol: freezed == playerSymbol
            ? _value.playerSymbol
            : playerSymbol // ignore: cast_nullable_to_non_nullable
                  as Player?,
        isReady: null == isReady
            ? _value.isReady
            : isReady // ignore: cast_nullable_to_non_nullable
                  as bool,
        joinedAt: null == joinedAt
            ? _value.joinedAt
            : joinedAt // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlayerInfoImpl implements _PlayerInfo {
  const _$PlayerInfoImpl({
    required this.playerId,
    required this.playerName,
    this.playerSymbol,
    this.isReady = false,
    this.joinedAt = 0,
  });

  factory _$PlayerInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayerInfoImplFromJson(json);

  @override
  final String playerId;
  @override
  final String playerName;
  @override
  final Player? playerSymbol;
  @override
  @JsonKey()
  final bool isReady;
  @override
  @JsonKey()
  final int joinedAt;

  @override
  String toString() {
    return 'PlayerInfo(playerId: $playerId, playerName: $playerName, playerSymbol: $playerSymbol, isReady: $isReady, joinedAt: $joinedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerInfoImpl &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.playerName, playerName) ||
                other.playerName == playerName) &&
            (identical(other.playerSymbol, playerSymbol) ||
                other.playerSymbol == playerSymbol) &&
            (identical(other.isReady, isReady) || other.isReady == isReady) &&
            (identical(other.joinedAt, joinedAt) ||
                other.joinedAt == joinedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    playerId,
    playerName,
    playerSymbol,
    isReady,
    joinedAt,
  );

  /// Create a copy of PlayerInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerInfoImplCopyWith<_$PlayerInfoImpl> get copyWith =>
      __$$PlayerInfoImplCopyWithImpl<_$PlayerInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayerInfoImplToJson(this);
  }
}

abstract class _PlayerInfo implements PlayerInfo {
  const factory _PlayerInfo({
    required final String playerId,
    required final String playerName,
    final Player? playerSymbol,
    final bool isReady,
    final int joinedAt,
  }) = _$PlayerInfoImpl;

  factory _PlayerInfo.fromJson(Map<String, dynamic> json) =
      _$PlayerInfoImpl.fromJson;

  @override
  String get playerId;
  @override
  String get playerName;
  @override
  Player? get playerSymbol;
  @override
  bool get isReady;
  @override
  int get joinedAt;

  /// Create a copy of PlayerInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerInfoImplCopyWith<_$PlayerInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GameMoveData _$GameMoveDataFromJson(Map<String, dynamic> json) {
  return _GameMoveData.fromJson(json);
}

/// @nodoc
mixin _$GameMoveData {
  int get position => throw _privateConstructorUsedError;
  Player get player => throw _privateConstructorUsedError;
  String get playerId => throw _privateConstructorUsedError;
  int get timestamp => throw _privateConstructorUsedError;

  /// Serializes this GameMoveData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GameMoveData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameMoveDataCopyWith<GameMoveData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameMoveDataCopyWith<$Res> {
  factory $GameMoveDataCopyWith(
    GameMoveData value,
    $Res Function(GameMoveData) then,
  ) = _$GameMoveDataCopyWithImpl<$Res, GameMoveData>;
  @useResult
  $Res call({int position, Player player, String playerId, int timestamp});
}

/// @nodoc
class _$GameMoveDataCopyWithImpl<$Res, $Val extends GameMoveData>
    implements $GameMoveDataCopyWith<$Res> {
  _$GameMoveDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameMoveData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? position = null,
    Object? player = null,
    Object? playerId = null,
    Object? timestamp = null,
  }) {
    return _then(
      _value.copyWith(
            position: null == position
                ? _value.position
                : position // ignore: cast_nullable_to_non_nullable
                      as int,
            player: null == player
                ? _value.player
                : player // ignore: cast_nullable_to_non_nullable
                      as Player,
            playerId: null == playerId
                ? _value.playerId
                : playerId // ignore: cast_nullable_to_non_nullable
                      as String,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GameMoveDataImplCopyWith<$Res>
    implements $GameMoveDataCopyWith<$Res> {
  factory _$$GameMoveDataImplCopyWith(
    _$GameMoveDataImpl value,
    $Res Function(_$GameMoveDataImpl) then,
  ) = __$$GameMoveDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int position, Player player, String playerId, int timestamp});
}

/// @nodoc
class __$$GameMoveDataImplCopyWithImpl<$Res>
    extends _$GameMoveDataCopyWithImpl<$Res, _$GameMoveDataImpl>
    implements _$$GameMoveDataImplCopyWith<$Res> {
  __$$GameMoveDataImplCopyWithImpl(
    _$GameMoveDataImpl _value,
    $Res Function(_$GameMoveDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameMoveData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? position = null,
    Object? player = null,
    Object? playerId = null,
    Object? timestamp = null,
  }) {
    return _then(
      _$GameMoveDataImpl(
        position: null == position
            ? _value.position
            : position // ignore: cast_nullable_to_non_nullable
                  as int,
        player: null == player
            ? _value.player
            : player // ignore: cast_nullable_to_non_nullable
                  as Player,
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GameMoveDataImpl implements _GameMoveData {
  const _$GameMoveDataImpl({
    required this.position,
    required this.player,
    required this.playerId,
    this.timestamp = 0,
  });

  factory _$GameMoveDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameMoveDataImplFromJson(json);

  @override
  final int position;
  @override
  final Player player;
  @override
  final String playerId;
  @override
  @JsonKey()
  final int timestamp;

  @override
  String toString() {
    return 'GameMoveData(position: $position, player: $player, playerId: $playerId, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameMoveDataImpl &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.player, player) || other.player == player) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, position, player, playerId, timestamp);

  /// Create a copy of GameMoveData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameMoveDataImplCopyWith<_$GameMoveDataImpl> get copyWith =>
      __$$GameMoveDataImplCopyWithImpl<_$GameMoveDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GameMoveDataImplToJson(this);
  }
}

abstract class _GameMoveData implements GameMoveData {
  const factory _GameMoveData({
    required final int position,
    required final Player player,
    required final String playerId,
    final int timestamp,
  }) = _$GameMoveDataImpl;

  factory _GameMoveData.fromJson(Map<String, dynamic> json) =
      _$GameMoveDataImpl.fromJson;

  @override
  int get position;
  @override
  Player get player;
  @override
  String get playerId;
  @override
  int get timestamp;

  /// Create a copy of GameMoveData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameMoveDataImplCopyWith<_$GameMoveDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
