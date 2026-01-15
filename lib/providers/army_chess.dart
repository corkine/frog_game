import 'dart:math';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/army_chess_state.dart';

part 'army_chess.g.dart';

@Riverpod(keepAlive: true)
class ArmyChess extends _$ArmyChess {
  @override
  ArmyChessState build() {
    return _createInitialState();
  }

  /// 创建初始游戏状态，随机放置所有棋子
  ArmyChessState _createInitialState() {
    final pieces = <ArmyPiece>[];

    // 为每方生成棋子
    for (final side in ArmySide.values) {
      for (final type in ArmyPieceType.values) {
        for (int i = 0; i < type.countPerSide; i++) {
          pieces.add(ArmyPiece(type: type, side: side));
        }
      }
    }

    // 随机打乱棋子顺序
    pieces.shuffle(Random());

    // 创建60格棋盘，填充棋子
    final board = List<ArmyPiece?>.filled(ArmyChessBoard.totalCells, null);

    // 将棋子放到非行营位置
    final availablePositions = <int>[];
    for (int i = 0; i < ArmyChessBoard.totalCells; i++) {
      // 行营不能放棋子初始化
      if (!ArmyChessBoard.campPositions.contains(i)) {
        availablePositions.add(i);
      }
    }
    availablePositions.shuffle(Random());

    for (int i = 0; i < pieces.length && i < availablePositions.length; i++) {
      board[availablePositions[i]] = pieces[i];
    }

    return ArmyChessState(
      board: board,
      currentPlayer: ArmySide.red,
      playerSide: null,
      status: ArmyGameStatus.playing,
      selectedIndex: null,
    );
  }

  /// 重新开始游戏
  void resetGame() {
    state = _createInitialState();
  }

  /// 处理格子点击
  void onCellTap(int index) {
    if (state.status != ArmyGameStatus.playing) return;
    if (index < 0 || index >= ArmyChessBoard.totalCells) return;

    final piece = state.board[index];

    // 如果点击的是未翻开的棋子，翻开它
    if (piece != null && !piece.isFaceUp) {
      _flipPiece(index);
      return;
    }

    // 如果已有选中的棋子
    if (state.selectedIndex != null) {
      final selectedPiece = state.board[state.selectedIndex!];
      if (selectedPiece == null) {
        state = state.copyWith(selectedIndex: null);
        return;
      }

      // 如果点击空格，尝试移动
      if (piece == null) {
        _tryMove(state.selectedIndex!, index);
        return;
      }

      // 如果点击对方棋子，尝试吃子
      if (piece.isFaceUp && piece.side != selectedPiece.side) {
        _tryCapture(state.selectedIndex!, index);
        return;
      }

      // 如果点击己方已翻开的棋子，切换选中
      if (piece.isFaceUp && piece.side == selectedPiece.side) {
        if (piece.type.canMove) {
          state = state.copyWith(selectedIndex: index);
        }
        return;
      }
    }

    // 没有选中的棋子，选中点击的己方已翻开的棋子
    if (piece != null && piece.isFaceUp && piece.side == state.currentPlayer) {
      if (piece.type.canMove) {
        state = state.copyWith(selectedIndex: index);
      }
    }
  }

  /// 翻开棋子
  void _flipPiece(int index) {
    final piece = state.board[index];
    if (piece == null || piece.isFaceUp) return;

    final newBoard = List<ArmyPiece?>.from(state.board);
    newBoard[index] = piece.copyWith(isFaceUp: true);

    // 首次翻棋确定阵营
    ArmySide? newPlayerSide = state.playerSide;
    if (newPlayerSide == null) {
      newPlayerSide = piece.side;
    }

    // 切换回合
    final nextPlayer = state.currentPlayer == ArmySide.red
        ? ArmySide.blue
        : ArmySide.red;

    state = state.copyWith(
      board: newBoard,
      currentPlayer: nextPlayer,
      playerSide: newPlayerSide,
      selectedIndex: null,
    );
  }

  /// 检查是否可以移动到目标位置
  bool _canMoveTo(int from, int to, ArmyPiece piece) {
    // 1. 相邻格子始终可以移动，但在前线需避开山界
    if (ArmyChessBoard.isOrthogonallyAdjacent(from, to)) {
      // 检查是否跨越前线 (Row 5 <-> Row 6)
      // 如果是，只有 Col 0, 2, 4 可以通行，Col 1, 3 (山界) 不通
      final (r1, c1) = ArmyChessBoard.indexToPosition(from);
      final (r2, c2) = ArmyChessBoard.indexToPosition(to);

      if ((r1 == 5 && r2 == 6) || (r1 == 6 && r2 == 5)) {
        // 跨越前线：检查列
        if (c1 == 1 || c1 == 3) {
          return false; // 山界阻挡
        }
      }
      return true;
    }

    // 2. 对角线移动（行营附近）
    if (ArmyChessBoard.isDiagonallyAdjacent(from, to)) {
      return true;
    }

    // 3. 铁路移动
    if (ArmyChessBoard.isOnRailroad(from) && ArmyChessBoard.isOnRailroad(to)) {
      final isEngineer = piece.type == ArmyPieceType.engineer;
      // 工兵可以使用 BFS 寻路（支持转弯）
      if (isEngineer) {
        return _checkEngineerRailroadPath(from, to, state.board);
      }
      // 非工兵只能走直线
      return ArmyChessBoard.canMoveAlongRailroad(from, to, state.board, false);
    }

    return false;
  }

  /// 检查工兵是否可以通过铁路到达目标位置 (BFS)
  bool _checkEngineerRailroadPath(int start, int end, List<ArmyPiece?> board) {
    if (start == end) return false;

    // 队列存储待访问的节点
    final queue = <int>[start];
    // Set 存储已访问的节点，避免循环
    final visited = <int>{start};

    while (queue.isNotEmpty) {
      final current = queue.removeAt(0);
      if (current == end) return true;

      // 获取所有相邻的铁路节点
      final neighbors = _getRailroadNeighbors(current);

      for (final neighbor in neighbors) {
        if (!visited.contains(neighbor)) {
          // 检查路径是否被阻挡
          // 如果是目标位置，即使有棋子（对方可吃）也可以到达
          // 如果是中间节点，必须为空
          if (neighbor == end || board[neighbor] == null) {
            visited.add(neighbor);
            queue.add(neighbor);
          }
        }
      }
    }

    return false;
  }

  /// 获取某个位置在铁路上的所有相邻位置
  List<int> _getRailroadNeighbors(int index) {
    final neighbors = <int>[];
    final (row, col) = ArmyChessBoard.indexToPosition(index);

    // 检查上下左右四个方向
    final directions = [
      (-1, 0), // 上
      (1, 0), // 下
      (0, -1), // 左
      (0, 1), // 右
    ];

    for (final dir in directions) {
      final newRow = row + dir.$1;
      final newCol = col + dir.$2;

      // 检查边界
      if (newRow >= 0 &&
          newRow < ArmyChessBoard.rows &&
          newCol >= 0 &&
          newCol < ArmyChessBoard.columns) {
        final newIndex = ArmyChessBoard.positionToIndex(newRow, newCol);
        // 必须在铁路上
        if (ArmyChessBoard.isOnRailroad(newIndex)) {
          // 检查是否相邻（有些铁路虽然坐标相邻，但在地图上不连通？
          // 在当前规则下，所有坐标相邻且都在铁路上的点都是连通的
          // 除了前线可能需要特殊处理，但目前实现假设前线也是通过纵向铁路连接的
          // 检查是否跨越了前线但不在连接线上 (col 0 和 4)
          // 前线在 row 5 和 6 之间
          if ((row == 5 && newRow == 6) || (row == 6 && newRow == 5)) {
            // 只有 col 0 和 4 是连通的
            if (col == 0 || col == 4) {
              neighbors.add(newIndex);
            }
          } else {
            neighbors.add(newIndex);
          }
        }
      }
    }

    return neighbors;
  }

  /// 尝试移动棋子到空格
  void _tryMove(int from, int to) {
    final piece = state.board[from];
    if (piece == null || !piece.type.canMove) {
      state = state.copyWith(selectedIndex: null);
      return;
    }

    // 只能移动己方棋子
    if (piece.side != state.currentPlayer) {
      state = state.copyWith(selectedIndex: null);
      return;
    }

    // 检查是否可以移动到目标位置
    if (!_canMoveTo(from, to, piece)) {
      state = state.copyWith(selectedIndex: null);
      return;
    }

    final newBoard = List<ArmyPiece?>.from(state.board);
    newBoard[to] = piece;
    newBoard[from] = null;

    final nextPlayer = state.currentPlayer == ArmySide.red
        ? ArmySide.blue
        : ArmySide.red;

    state = state.copyWith(
      board: newBoard,
      currentPlayer: nextPlayer,
      selectedIndex: null,
    );
  }

  /// 尝试吃子
  void _tryCapture(int from, int to) {
    final attacker = state.board[from];
    final defender = state.board[to];

    if (attacker == null || defender == null) {
      state = state.copyWith(selectedIndex: null);
      return;
    }

    if (!attacker.isFaceUp || !defender.isFaceUp) {
      state = state.copyWith(selectedIndex: null);
      return;
    }

    // 只能用己方棋子攻击
    if (attacker.side != state.currentPlayer) {
      state = state.copyWith(selectedIndex: null);
      return;
    }

    // 只能攻击对方棋子
    if (attacker.side == defender.side) {
      state = state.copyWith(selectedIndex: null);
      return;
    }

    // 行营中的棋子不可被攻击
    if (ArmyChessBoard.campPositions.contains(to)) {
      state = state.copyWith(selectedIndex: null);
      return;
    }

    // 检查是否可以移动到目标位置
    if (!_canMoveTo(from, to, attacker)) {
      state = state.copyWith(selectedIndex: null);
      return;
    }

    // 检查是否可以攻击（防止自杀式攻击，除非是炸弹）
    if (!_canAttack(attacker, defender)) {
      state = state.copyWith(selectedIndex: null);
      return;
    }

    final result = _getCaptureResult(attacker, defender);
    final newBoard = List<ArmyPiece?>.from(state.board);

    switch (result) {
      case CaptureResult.win:
        newBoard[to] = attacker;
        newBoard[from] = null;
        break;
      case CaptureResult.lose:
        newBoard[from] = null;
        break;
      case CaptureResult.draw:
        newBoard[from] = null;
        newBoard[to] = null;
        break;
      case CaptureResult.invalid:
        state = state.copyWith(selectedIndex: null);
        return;
    }

    final nextPlayer = state.currentPlayer == ArmySide.red
        ? ArmySide.blue
        : ArmySide.red;

    // 检查游戏是否结束
    final gameStatus = _checkGameOver(newBoard, defender);

    state = state.copyWith(
      board: newBoard,
      currentPlayer: nextPlayer,
      selectedIndex: null,
      status: gameStatus,
    );
  }

  /// 判断吃子结果
  CaptureResult _getCaptureResult(ArmyPiece attacker, ArmyPiece defender) {
    // 炸弹：与任何可移动棋子同归于尽
    if (attacker.type == ArmyPieceType.bomb) {
      return CaptureResult.draw;
    }

    // 攻击炸弹：同归于尽
    if (defender.type == ArmyPieceType.bomb) {
      return CaptureResult.draw;
    }

    // 地雷：只有工兵能挖，其他棋子触雷被炸死
    if (defender.type == ArmyPieceType.landmine) {
      if (attacker.type == ArmyPieceType.engineer) {
        return CaptureResult.win;
      } else {
        return CaptureResult.lose; // 非工兵触雷，攻击方死亡
      }
    }

    // 军旗：任何棋子都能吃
    if (defender.type == ArmyPieceType.flag) {
      return CaptureResult.win;
    }

    // 普通棋子：比较等级
    final attackerRank = attacker.type.rank;
    final defenderRank = defender.type.rank;

    if (attackerRank > defenderRank) {
      return CaptureResult.win;
    } else if (attackerRank < defenderRank) {
      return CaptureResult.lose;
    } else {
      return CaptureResult.draw;
    }
  }

  /// 检查游戏是否结束
  ArmyGameStatus _checkGameOver(List<ArmyPiece?> board, ArmyPiece defender) {
    // 军旗被吃，游戏结束
    if (defender.type == ArmyPieceType.flag) {
      return defender.side == ArmySide.red
          ? ArmyGameStatus.blueWins
          : ArmyGameStatus.redWins;
    }

    // 检查是否一方没有可移动的棋子了
    bool redHasMovablePieces = false;
    bool blueHasMovablePieces = false;

    for (final piece in board) {
      if (piece != null && piece.isFaceUp && piece.type.canMove) {
        if (piece.side == ArmySide.red) {
          redHasMovablePieces = true;
        } else {
          blueHasMovablePieces = true;
        }
      }
    }

    // 检查是否还有未翻开的棋子
    bool hasHiddenPieces = board.any((p) => p != null && !p.isFaceUp);

    if (!hasHiddenPieces) {
      if (!redHasMovablePieces && blueHasMovablePieces) {
        return ArmyGameStatus.blueWins;
      }
      if (!blueHasMovablePieces && redHasMovablePieces) {
        return ArmyGameStatus.redWins;
      }
    }

    return ArmyGameStatus.playing;
  }

  /// 获取可移动的位置列表
  List<int> getValidMoves(int index) {
    final piece = state.board[index];
    if (piece == null || !piece.isFaceUp || !piece.type.canMove) {
      return [];
    }

    final moves = <int>[];

    for (int i = 0; i < ArmyChessBoard.totalCells; i++) {
      if (i == index) continue;

      final targetPiece = state.board[i];

      // 空格：检查是否可以移动
      if (targetPiece == null && _canMoveTo(index, i, piece)) {
        moves.add(i);
      }
      // 对方已翻开棋子：检查是否可以吃
      else if (targetPiece != null &&
          targetPiece.isFaceUp &&
          targetPiece.side != piece.side &&
          !ArmyChessBoard.campPositions.contains(i) &&
          _canMoveTo(index, i, piece) &&
          _canAttack(piece, targetPiece)) {
        moves.add(i);
      }
    }

    return moves;
  }

  /// 检查是否可以攻击目标（排除不合理的攻击）
  bool _canAttack(ArmyPiece attacker, ArmyPiece defender) {
    // 地雷：只有工兵可以攻击
    if (defender.type == ArmyPieceType.landmine) {
      return attacker.type == ArmyPieceType.engineer;
    }

    // 炸弹可以攻击任何棋子（同归于尽）
    if (attacker.type == ArmyPieceType.bomb) {
      return true;
    }

    // 军旗：任何棋子都可以吃
    if (defender.type == ArmyPieceType.flag) {
      return true;
    }

    // 对方是炸弹：允许攻击（会同归于尽）
    if (defender.type == ArmyPieceType.bomb) {
      return true;
    }

    // 普通棋子：只能攻击等级相同或更低的
    return attacker.type.rank >= defender.type.rank;
  }
}

/// 吃子结果
enum CaptureResult { win, lose, draw, invalid }
