import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_state.freezed.dart';
part 'game_state.g.dart';

enum Player { x, o }

enum GameStatus { playing, xWins, oWins, draw }

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
