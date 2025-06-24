import 'dart:math';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/game_state.dart';

part 'game.g.dart';

@riverpod
class Game extends _$Game {
  @override
  GameState build() {
    return const GameState();
  }

  /// 重新开始游戏
  void resetGame({bool aiMode = false}) {
    state = GameState(isAiMode: aiMode);
  }

  /// 玩家落子
  void makeMove(int index) {
    if (!state.canMakeMove(index)) return;

    final newBoard = List<Player?>.from(state.board);
    newBoard[index] = state.currentPlayer;

    final newStatus = state.copyWith(board: newBoard).checkWinStatus();
    final nextPlayer = state.currentPlayer == Player.x ? Player.o : Player.x;

    state = state.copyWith(
      board: newBoard,
      currentPlayer: nextPlayer,
      status: newStatus,
    );

    // 如果是AI模式且游戏继续，让AI下棋
    if (state.isAiMode &&
        state.status == GameStatus.playing &&
        state.currentPlayer == Player.o) {
      _makeAiMove();
    }
  }

  /// AI下棋
  void _makeAiMove() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (state.status != GameStatus.playing) return;

      final aiMove = _getBestMove();
      if (aiMove != -1) {
        makeMove(aiMove);
      }
    });
  }

  /// 获取AI的最佳落子位置（使用Minimax算法）
  int _getBestMove() {
    int bestScore = -1000;
    int bestMove = -1;

    for (int i = 0; i < 9; i++) {
      if (state.board[i] == null) {
        final newBoard = List<Player?>.from(state.board);
        newBoard[i] = Player.o;

        final score = _minimax(newBoard, 0, false);

        if (score > bestScore) {
          bestScore = score;
          bestMove = i;
        }
      }
    }

    return bestMove;
  }

  /// Minimax算法实现
  int _minimax(List<Player?> board, int depth, bool isMaximizing) {
    final tempState = state.copyWith(board: board);
    final status = tempState.checkWinStatus();

    // 终端状态评估
    if (status == GameStatus.oWins) return 10 - depth;
    if (status == GameStatus.xWins) return depth - 10;
    if (status == GameStatus.draw) return 0;

    if (isMaximizing) {
      int bestScore = -1000;
      for (int i = 0; i < 9; i++) {
        if (board[i] == null) {
          board[i] = Player.o;
          final score = _minimax(board, depth + 1, false);
          board[i] = null;
          bestScore = max(bestScore, score);
        }
      }
      return bestScore;
    } else {
      int bestScore = 1000;
      for (int i = 0; i < 9; i++) {
        if (board[i] == null) {
          board[i] = Player.x;
          final score = _minimax(board, depth + 1, true);
          board[i] = null;
          bestScore = min(bestScore, score);
        }
      }
      return bestScore;
    }
  }
}