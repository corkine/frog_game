import 'package:freezed_annotation/freezed_annotation.dart';

part 'army_chess_state.freezed.dart';
part 'army_chess_state.g.dart';

/// 军棋棋子类型
enum ArmyPieceType {
  commander, // 司令 (9) x1
  general, // 军长 (8) x1
  division, // 师长 (7) x2
  brigade, // 旅长 (6) x2
  regiment, // 团长 (5) x2
  battalion, // 营长 (4) x2
  company, // 连长 (3) x3
  platoon, // 排长 (2) x3
  engineer, // 工兵 (1) x3 - 可在铁路转弯
  landmine, // 地雷 x4 - 不可移动
  bomb, // 炸弹 x2 - 同归于尽
  flag, // 军旗 x1 - 被吃即输
}

/// 阵营
enum ArmySide { red, blue }

/// 游戏状态
enum ArmyGameStatus { playing, redWins, blueWins }

/// 格子类型
enum CellType {
  station, // 兵站（普通格子）
  camp, // 行营（棋子在此不可被攻击）
  headquarters, // 大本营
}

/// 棋子等级映射
extension ArmyPieceTypeX on ArmyPieceType {
  int get rank {
    switch (this) {
      case ArmyPieceType.commander:
        return 9;
      case ArmyPieceType.general:
        return 8;
      case ArmyPieceType.division:
        return 7;
      case ArmyPieceType.brigade:
        return 6;
      case ArmyPieceType.regiment:
        return 5;
      case ArmyPieceType.battalion:
        return 4;
      case ArmyPieceType.company:
        return 3;
      case ArmyPieceType.platoon:
        return 2;
      case ArmyPieceType.engineer:
        return 1;
      case ArmyPieceType.landmine:
      case ArmyPieceType.bomb:
      case ArmyPieceType.flag:
        return -1;
    }
  }

  bool get canMove {
    return this != ArmyPieceType.landmine && this != ArmyPieceType.flag;
  }

  String get displayName {
    switch (this) {
      case ArmyPieceType.commander:
        return '司令';
      case ArmyPieceType.general:
        return '军长';
      case ArmyPieceType.division:
        return '师长';
      case ArmyPieceType.brigade:
        return '旅长';
      case ArmyPieceType.regiment:
        return '团长';
      case ArmyPieceType.battalion:
        return '营长';
      case ArmyPieceType.company:
        return '连长';
      case ArmyPieceType.platoon:
        return '排长';
      case ArmyPieceType.engineer:
        return '工兵';
      case ArmyPieceType.landmine:
        return '地雷';
      case ArmyPieceType.bomb:
        return '炸弹';
      case ArmyPieceType.flag:
        return '军旗';
    }
  }

  int get countPerSide {
    switch (this) {
      case ArmyPieceType.commander:
      case ArmyPieceType.general:
      case ArmyPieceType.flag:
        return 1;
      case ArmyPieceType.division:
      case ArmyPieceType.brigade:
      case ArmyPieceType.regiment:
      case ArmyPieceType.battalion:
      case ArmyPieceType.bomb:
        return 2;
      case ArmyPieceType.company:
      case ArmyPieceType.platoon:
      case ArmyPieceType.engineer:
        return 3;
      case ArmyPieceType.landmine:
        return 4;
    }
  }
}

/// 军棋棋子
@freezed
class ArmyPiece with _$ArmyPiece {
  const factory ArmyPiece({
    required ArmyPieceType type,
    required ArmySide side,
    @Default(false) bool isFaceUp,
  }) = _ArmyPiece;

  factory ArmyPiece.fromJson(Map<String, dynamic> json) =>
      _$ArmyPieceFromJson(json);
}

/// 军棋游戏状态
@freezed
class ArmyChessState with _$ArmyChessState {
  const factory ArmyChessState({
    @Default([]) List<ArmyPiece?> board,
    @Default(ArmySide.red) ArmySide currentPlayer,
    ArmySide? playerSide,
    @Default(ArmyGameStatus.playing) ArmyGameStatus status,
    int? selectedIndex,
  }) = _ArmyChessState;

  factory ArmyChessState.fromJson(Map<String, dynamic> json) =>
      _$ArmyChessStateFromJson(json);
}

/// 棋盘常量和布局
class ArmyChessBoard {
  static const int columns = 5;
  static const int rows = 12;
  static const int totalCells = columns * rows; // 60

  /// 行营位置（在这些位置的棋子不可被攻击）
  static const Set<int> campPositions = {
    // 上半区行营 (rows 2, 3, 4)
    11, 13, // row 2: (2,1), (2,3)
    17, // row 3: (3,2)
    21, 23, // row 4: (4,1), (4,3)
    // 下半区行营 (rows 7, 8, 9)
    36, 38, // row 7: (7,1), (7,3)
    42, // row 8: (8,2)
    46, 48, // row 9: (9,1), (9,3)
  };

  /// 大本营位置
  static const Set<int> headquartersPositions = {
    1, 3, // row 0: (0,1), (0,3)
    56, 58, // row 11: (11,1), (11,3)
  };

  /// 铁路边缘 - 最左列和最右列的中间行 (rows 1-5 和 6-10)
  static const Set<int> leftRailroad = {
    5, 10, 15, 20, 25, // 上半区左边 rows 1-5
    30, 35, 40, 45, 50, // 下半区左边 rows 6-10
  };

  static const Set<int> rightRailroad = {
    9, 14, 19, 24, 29, // 上半区右边 rows 1-5
    34, 39, 44, 49, 54, // 下半区右边 rows 6-10
  };

  /// 铁路横线位置 (row 1, row 5, row 6, row 10)
  static const Set<int> horizontalRailroad = {
    5, 6, 7, 8, 9, // row 1 (上方横线)
    25, 26, 27, 28, 29, // row 5 (上方中线)
    30, 31, 32, 33, 34, // row 6 (下方中线)
    50, 51, 52, 53, 54, // row 10 (下方横线)
  };

  /// 判断是否在铁路上
  static bool isOnRailroad(int index) {
    return leftRailroad.contains(index) ||
        rightRailroad.contains(index) ||
        horizontalRailroad.contains(index);
  }

  /// 对角线连接（行营相邻的斜线）
  /// 仅存储 index < targetIndex 的单向连接，用于绘图和逻辑判断
  static const Map<int, List<int>> diagonalConnections = {
    // 上半区
    5: [11],
    7: [11, 13],
    9: [13],
    11: [15, 17],
    13: [17, 19],
    15: [21],
    17: [21, 23],
    19: [23],
    21: [25, 27],
    23: [27, 29],

    // 下半区
    30: [36],
    32: [36, 38],
    34: [38],
    36: [40, 42],
    38: [42, 44],
    40: [46],
    42: [46, 48],
    44: [48],
    46: [50, 52],
    48: [52, 54],
  };

  /// 获取格子类型
  static CellType getCellType(int index) {
    if (campPositions.contains(index)) return CellType.camp;
    if (headquartersPositions.contains(index)) return CellType.headquarters;
    return CellType.station;
  }

  /// 根据索引获取行列
  static (int row, int col) indexToPosition(int index) {
    return (index ~/ columns, index % columns);
  }

  /// 根据行列获取索引
  static int positionToIndex(int row, int col) {
    return row * columns + col;
  }

  /// 检查两个位置是否直接相邻（上下左右）
  static bool isOrthogonallyAdjacent(int from, int to) {
    final (fromRow, fromCol) = indexToPosition(from);
    final (toRow, toCol) = indexToPosition(to);
    final rowDiff = (fromRow - toRow).abs();
    final colDiff = (fromCol - toCol).abs();
    return (rowDiff == 1 && colDiff == 0) || (rowDiff == 0 && colDiff == 1);
  }

  /// 检查两个位置是否对角相邻
  static bool isDiagonallyAdjacent(int from, int to) {
    // 检查正向连接
    final connections = diagonalConnections[from];
    if (connections != null && connections.contains(to)) return true;
    // 检查反向连接
    final reverseConnections = diagonalConnections[to];
    return reverseConnections != null && reverseConnections.contains(from);
  }

  /// 检查是否可以通过铁路直线到达（无阻挡）
  static bool canMoveAlongRailroad(
    int from,
    int to,
    List<ArmyPiece?> board,
    bool isEngineer,
  ) {
    if (!isOnRailroad(from) || !isOnRailroad(to)) return false;

    final (fromRow, fromCol) = indexToPosition(from);
    final (toRow, toCol) = indexToPosition(to);

    // 同一行移动
    if (fromRow == toRow) {
      final minCol = fromCol < toCol ? fromCol : toCol;
      final maxCol = fromCol > toCol ? fromCol : toCol;
      // 检查路径上是否有障碍
      for (int col = minCol + 1; col < maxCol; col++) {
        final idx = positionToIndex(fromRow, col);
        if (board[idx] != null) return false;
      }
      return true;
    }

    // 同一列移动
    if (fromCol == toCol) {
      final minRow = fromRow < toRow ? fromRow : toRow;
      final maxRow = fromRow > toRow ? fromRow : toRow;
      // 检查路径上是否有障碍
      for (int row = minRow + 1; row < maxRow; row++) {
        final idx = positionToIndex(row, fromCol);
        if (board[idx] != null) return false;
      }
      return true;
    }

    // 只有工兵可以转弯 - 简化处理：暂不支持转弯
    // TODO: 工兵转弯逻辑
    return false;
  }
}
