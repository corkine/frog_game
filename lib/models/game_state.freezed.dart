// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_state.dart';

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
