// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'army_chess_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ArmyPiece _$ArmyPieceFromJson(Map<String, dynamic> json) {
  return _ArmyPiece.fromJson(json);
}

/// @nodoc
mixin _$ArmyPiece {
  ArmyPieceType get type => throw _privateConstructorUsedError;
  ArmySide get side => throw _privateConstructorUsedError;
  bool get isFaceUp => throw _privateConstructorUsedError;

  /// Serializes this ArmyPiece to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ArmyPiece
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ArmyPieceCopyWith<ArmyPiece> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArmyPieceCopyWith<$Res> {
  factory $ArmyPieceCopyWith(ArmyPiece value, $Res Function(ArmyPiece) then) =
      _$ArmyPieceCopyWithImpl<$Res, ArmyPiece>;
  @useResult
  $Res call({ArmyPieceType type, ArmySide side, bool isFaceUp});
}

/// @nodoc
class _$ArmyPieceCopyWithImpl<$Res, $Val extends ArmyPiece>
    implements $ArmyPieceCopyWith<$Res> {
  _$ArmyPieceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ArmyPiece
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? side = null,
    Object? isFaceUp = null,
  }) {
    return _then(
      _value.copyWith(
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as ArmyPieceType,
            side: null == side
                ? _value.side
                : side // ignore: cast_nullable_to_non_nullable
                      as ArmySide,
            isFaceUp: null == isFaceUp
                ? _value.isFaceUp
                : isFaceUp // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ArmyPieceImplCopyWith<$Res>
    implements $ArmyPieceCopyWith<$Res> {
  factory _$$ArmyPieceImplCopyWith(
    _$ArmyPieceImpl value,
    $Res Function(_$ArmyPieceImpl) then,
  ) = __$$ArmyPieceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ArmyPieceType type, ArmySide side, bool isFaceUp});
}

/// @nodoc
class __$$ArmyPieceImplCopyWithImpl<$Res>
    extends _$ArmyPieceCopyWithImpl<$Res, _$ArmyPieceImpl>
    implements _$$ArmyPieceImplCopyWith<$Res> {
  __$$ArmyPieceImplCopyWithImpl(
    _$ArmyPieceImpl _value,
    $Res Function(_$ArmyPieceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ArmyPiece
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? side = null,
    Object? isFaceUp = null,
  }) {
    return _then(
      _$ArmyPieceImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as ArmyPieceType,
        side: null == side
            ? _value.side
            : side // ignore: cast_nullable_to_non_nullable
                  as ArmySide,
        isFaceUp: null == isFaceUp
            ? _value.isFaceUp
            : isFaceUp // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ArmyPieceImpl implements _ArmyPiece {
  const _$ArmyPieceImpl({
    required this.type,
    required this.side,
    this.isFaceUp = false,
  });

  factory _$ArmyPieceImpl.fromJson(Map<String, dynamic> json) =>
      _$$ArmyPieceImplFromJson(json);

  @override
  final ArmyPieceType type;
  @override
  final ArmySide side;
  @override
  @JsonKey()
  final bool isFaceUp;

  @override
  String toString() {
    return 'ArmyPiece(type: $type, side: $side, isFaceUp: $isFaceUp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ArmyPieceImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.side, side) || other.side == side) &&
            (identical(other.isFaceUp, isFaceUp) ||
                other.isFaceUp == isFaceUp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, side, isFaceUp);

  /// Create a copy of ArmyPiece
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ArmyPieceImplCopyWith<_$ArmyPieceImpl> get copyWith =>
      __$$ArmyPieceImplCopyWithImpl<_$ArmyPieceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ArmyPieceImplToJson(this);
  }
}

abstract class _ArmyPiece implements ArmyPiece {
  const factory _ArmyPiece({
    required final ArmyPieceType type,
    required final ArmySide side,
    final bool isFaceUp,
  }) = _$ArmyPieceImpl;

  factory _ArmyPiece.fromJson(Map<String, dynamic> json) =
      _$ArmyPieceImpl.fromJson;

  @override
  ArmyPieceType get type;
  @override
  ArmySide get side;
  @override
  bool get isFaceUp;

  /// Create a copy of ArmyPiece
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ArmyPieceImplCopyWith<_$ArmyPieceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ArmyChessState _$ArmyChessStateFromJson(Map<String, dynamic> json) {
  return _ArmyChessState.fromJson(json);
}

/// @nodoc
mixin _$ArmyChessState {
  List<ArmyPiece?> get board => throw _privateConstructorUsedError;
  ArmySide get currentPlayer => throw _privateConstructorUsedError;
  ArmySide? get playerSide => throw _privateConstructorUsedError;
  ArmyGameStatus get status => throw _privateConstructorUsedError;
  int? get selectedIndex => throw _privateConstructorUsedError;

  /// Serializes this ArmyChessState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ArmyChessState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ArmyChessStateCopyWith<ArmyChessState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArmyChessStateCopyWith<$Res> {
  factory $ArmyChessStateCopyWith(
    ArmyChessState value,
    $Res Function(ArmyChessState) then,
  ) = _$ArmyChessStateCopyWithImpl<$Res, ArmyChessState>;
  @useResult
  $Res call({
    List<ArmyPiece?> board,
    ArmySide currentPlayer,
    ArmySide? playerSide,
    ArmyGameStatus status,
    int? selectedIndex,
  });
}

/// @nodoc
class _$ArmyChessStateCopyWithImpl<$Res, $Val extends ArmyChessState>
    implements $ArmyChessStateCopyWith<$Res> {
  _$ArmyChessStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ArmyChessState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? board = null,
    Object? currentPlayer = null,
    Object? playerSide = freezed,
    Object? status = null,
    Object? selectedIndex = freezed,
  }) {
    return _then(
      _value.copyWith(
            board: null == board
                ? _value.board
                : board // ignore: cast_nullable_to_non_nullable
                      as List<ArmyPiece?>,
            currentPlayer: null == currentPlayer
                ? _value.currentPlayer
                : currentPlayer // ignore: cast_nullable_to_non_nullable
                      as ArmySide,
            playerSide: freezed == playerSide
                ? _value.playerSide
                : playerSide // ignore: cast_nullable_to_non_nullable
                      as ArmySide?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as ArmyGameStatus,
            selectedIndex: freezed == selectedIndex
                ? _value.selectedIndex
                : selectedIndex // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ArmyChessStateImplCopyWith<$Res>
    implements $ArmyChessStateCopyWith<$Res> {
  factory _$$ArmyChessStateImplCopyWith(
    _$ArmyChessStateImpl value,
    $Res Function(_$ArmyChessStateImpl) then,
  ) = __$$ArmyChessStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<ArmyPiece?> board,
    ArmySide currentPlayer,
    ArmySide? playerSide,
    ArmyGameStatus status,
    int? selectedIndex,
  });
}

/// @nodoc
class __$$ArmyChessStateImplCopyWithImpl<$Res>
    extends _$ArmyChessStateCopyWithImpl<$Res, _$ArmyChessStateImpl>
    implements _$$ArmyChessStateImplCopyWith<$Res> {
  __$$ArmyChessStateImplCopyWithImpl(
    _$ArmyChessStateImpl _value,
    $Res Function(_$ArmyChessStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ArmyChessState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? board = null,
    Object? currentPlayer = null,
    Object? playerSide = freezed,
    Object? status = null,
    Object? selectedIndex = freezed,
  }) {
    return _then(
      _$ArmyChessStateImpl(
        board: null == board
            ? _value._board
            : board // ignore: cast_nullable_to_non_nullable
                  as List<ArmyPiece?>,
        currentPlayer: null == currentPlayer
            ? _value.currentPlayer
            : currentPlayer // ignore: cast_nullable_to_non_nullable
                  as ArmySide,
        playerSide: freezed == playerSide
            ? _value.playerSide
            : playerSide // ignore: cast_nullable_to_non_nullable
                  as ArmySide?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as ArmyGameStatus,
        selectedIndex: freezed == selectedIndex
            ? _value.selectedIndex
            : selectedIndex // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ArmyChessStateImpl implements _ArmyChessState {
  const _$ArmyChessStateImpl({
    final List<ArmyPiece?> board = const [],
    this.currentPlayer = ArmySide.red,
    this.playerSide,
    this.status = ArmyGameStatus.playing,
    this.selectedIndex,
  }) : _board = board;

  factory _$ArmyChessStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$ArmyChessStateImplFromJson(json);

  final List<ArmyPiece?> _board;
  @override
  @JsonKey()
  List<ArmyPiece?> get board {
    if (_board is EqualUnmodifiableListView) return _board;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_board);
  }

  @override
  @JsonKey()
  final ArmySide currentPlayer;
  @override
  final ArmySide? playerSide;
  @override
  @JsonKey()
  final ArmyGameStatus status;
  @override
  final int? selectedIndex;

  @override
  String toString() {
    return 'ArmyChessState(board: $board, currentPlayer: $currentPlayer, playerSide: $playerSide, status: $status, selectedIndex: $selectedIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ArmyChessStateImpl &&
            const DeepCollectionEquality().equals(other._board, _board) &&
            (identical(other.currentPlayer, currentPlayer) ||
                other.currentPlayer == currentPlayer) &&
            (identical(other.playerSide, playerSide) ||
                other.playerSide == playerSide) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.selectedIndex, selectedIndex) ||
                other.selectedIndex == selectedIndex));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_board),
    currentPlayer,
    playerSide,
    status,
    selectedIndex,
  );

  /// Create a copy of ArmyChessState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ArmyChessStateImplCopyWith<_$ArmyChessStateImpl> get copyWith =>
      __$$ArmyChessStateImplCopyWithImpl<_$ArmyChessStateImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ArmyChessStateImplToJson(this);
  }
}

abstract class _ArmyChessState implements ArmyChessState {
  const factory _ArmyChessState({
    final List<ArmyPiece?> board,
    final ArmySide currentPlayer,
    final ArmySide? playerSide,
    final ArmyGameStatus status,
    final int? selectedIndex,
  }) = _$ArmyChessStateImpl;

  factory _ArmyChessState.fromJson(Map<String, dynamic> json) =
      _$ArmyChessStateImpl.fromJson;

  @override
  List<ArmyPiece?> get board;
  @override
  ArmySide get currentPlayer;
  @override
  ArmySide? get playerSide;
  @override
  ArmyGameStatus get status;
  @override
  int? get selectedIndex;

  /// Create a copy of ArmyChessState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ArmyChessStateImplCopyWith<_$ArmyChessStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
