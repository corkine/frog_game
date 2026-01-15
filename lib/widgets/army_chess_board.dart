import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/army_chess_state.dart' as models;
import '../providers/army_chess.dart';

class ArmyChessBoardWidget extends ConsumerWidget {
  const ArmyChessBoardWidget({super.key});

  // 前线空隙的高度倍数
  static const double frontlineGapMultiplier = 1.2;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(armyChessProvider);
    final gameNotifier = ref.read(armyChessProvider.notifier);
    final validMoves = gameState.selectedIndex != null
        ? gameNotifier.getValidMoves(gameState.selectedIndex!)
        : <int>[];

    return LayoutBuilder(
      builder: (context, constraints) {
        const cols = models.ArmyChessBoard.columns;
        const rows = models.ArmyChessBoard.rows;

        final availableWidth = constraints.maxWidth - 16;
        final availableHeight = constraints.maxHeight - 16;

        const cellAspectRatio = 1.8;

        // 考虑前线空隙的额外高度
        final effectiveRows = rows + frontlineGapMultiplier;

        final cellWidth = availableWidth / cols;
        var cellHeight = cellWidth / cellAspectRatio;
        var totalHeight = cellHeight * effectiveRows;

        double finalCellWidth, finalCellHeight;
        if (totalHeight > availableHeight) {
          finalCellHeight = availableHeight / effectiveRows;
          finalCellWidth = finalCellHeight * cellAspectRatio;
        } else {
          finalCellWidth = cellWidth;
          finalCellHeight = cellHeight;
        }

        final frontlineGap = finalCellHeight * frontlineGapMultiplier;
        final boardWidth = finalCellWidth * cols;
        final boardHeight = finalCellHeight * rows + frontlineGap;

        return Center(
          child: CustomPaint(
            painter: BoardLinesPainter(
              cellWidth: finalCellWidth,
              cellHeight: finalCellHeight,
              cols: cols,
              rows: rows,
              frontlineGap: frontlineGap,
            ),
            child: SizedBox(
              width: boardWidth,
              height: boardHeight,
              child: Stack(
                children: [
                  // 前线区域装饰
                  Positioned(
                    left: 0,
                    right: 0,
                    top: finalCellHeight * 6,
                    height: frontlineGap,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.brown.shade800.withValues(alpha: 0.3),
                            Colors.brown.shade900.withValues(alpha: 0.5),
                            Colors.brown.shade800.withValues(alpha: 0.3),
                          ],
                        ),
                      ),
                      child: Stack(
                        children: [
                          // 前线文字
                          Center(
                            child: Text(
                              '—— 前  线 ——',
                              style: TextStyle(
                                color: Colors.brown.shade300,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 4,
                              ),
                            ),
                          ),
                          // 山界 (左)
                          Positioned(
                            left: finalCellWidth * 1,
                            width: finalCellWidth,
                            height: frontlineGap,
                            child: _buildMountainDecoration(),
                          ),
                          // 山界 (右)
                          Positioned(
                            left: finalCellWidth * 3,
                            width: finalCellWidth,
                            height: frontlineGap,
                            child: _buildMountainDecoration(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // 棋子格子
                  for (
                    int index = 0;
                    index < models.ArmyChessBoard.totalCells;
                    index++
                  )
                    _buildCell(
                      index: index,
                      gameState: gameState,
                      validMoves: validMoves,
                      gameNotifier: gameNotifier,
                      cellWidth: finalCellWidth,
                      cellHeight: finalCellHeight,
                      frontlineGap: frontlineGap,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCell({
    required int index,
    required models.ArmyChessState gameState,
    required List<int> validMoves,
    required ArmyChess gameNotifier,
    required double cellWidth,
    required double cellHeight,
    required double frontlineGap,
  }) {
    final (row, col) = models.ArmyChessBoard.indexToPosition(index);
    final piece = gameState.board.isNotEmpty && index < gameState.board.length
        ? gameState.board[index]
        : null;
    final isSelected = gameState.selectedIndex == index;
    final isValidMove = validMoves.contains(index);
    final cellType = models.ArmyChessBoard.getCellType(index);

    final left = col * cellWidth;
    // 下半部分（row >= 6）需要加上前线间隙
    final top = row * cellHeight + (row >= 6 ? frontlineGap : 0);

    const padding = 8.0;

    return Positioned(
      left: left + padding,
      top: top + padding,
      width: cellWidth - padding * 2,
      height: cellHeight - padding * 2,
      child: ArmyChessCell(
        piece: piece,
        isSelected: isSelected,
        isValidMove: isValidMove,
        cellType: cellType,
        onTap: () => gameNotifier.onCellTap(index),
      ),
    );
  }
}

Widget _buildMountainDecoration() {
  return Center(
    child: Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.brown.shade400, width: 2.0),
      ),
      child: Center(
        child: Transform.rotate(
          angle: -0.2,
          child: Text(
            '山界',
            style: TextStyle(
              color: Colors.brown.shade400,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ),
  );
}

class BoardLinesPainter extends CustomPainter {
  final double cellWidth;
  final double cellHeight;
  final int cols;
  final int rows;
  final double frontlineGap;

  BoardLinesPainter({
    required this.cellWidth,
    required this.cellHeight,
    required this.cols,
    required this.rows,
    required this.frontlineGap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.brown.shade700
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final railroadPaint = Paint()
      ..color = Colors.brown.shade900
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final yOffset = row >= 6 ? frontlineGap : 0.0;
        final centerX = col * cellWidth + cellWidth / 2;
        final centerY = row * cellHeight + cellHeight / 2 + yOffset;
        final index = row * cols + col;

        // 向右连线（不跨越前线）
        if (col < cols - 1) {
          final nextCenterX = (col + 1) * cellWidth + cellWidth / 2;
          final isRailroad = _isHorizontalRailroad(row);
          canvas.drawLine(
            Offset(centerX, centerY),
            Offset(nextCenterX, centerY),
            isRailroad ? railroadPaint : paint,
          );
        }

        // 向下连线
        if (row < rows - 1) {
          // 特殊处理前线跨越 (row 5 -> 6)
          if (row == 5) {
            final nextYOffset = frontlineGap;
            final nextCenterY =
                (row + 1) * cellHeight + cellHeight / 2 + nextYOffset;

            // 铁路（col 0, 4）跨越前线，且必须画粗线
            if (col == 0 || col == 4) {
              canvas.drawLine(
                Offset(centerX, centerY),
                Offset(centerX, nextCenterY),
                railroadPaint,
              );
            }
            // 中间列 (col 2) 也可以通行，画细线
            else if (col == 2) {
              canvas.drawLine(
                Offset(centerX, centerY),
                Offset(centerX, nextCenterY),
                paint,
              );
            }
            // 山界 (col 1, 3) 不画线
          } else {
            // 普通向下连线
            final nextYOffset = (row + 1) >= 6 ? frontlineGap : 0.0;
            final nextCenterY =
                (row + 1) * cellHeight + cellHeight / 2 + nextYOffset;
            final isRailroad = _isVerticalRailroad(col, row);
            canvas.drawLine(
              Offset(centerX, centerY),
              Offset(centerX, nextCenterY),
              isRailroad ? railroadPaint : paint,
            );
          }
        }

        // 对角线连线
        final diagonals = models.ArmyChessBoard.diagonalConnections[index];
        if (diagonals != null) {
          for (final targetIndex in diagonals) {
            if (targetIndex > index) {
              final (targetRow, targetCol) =
                  models.ArmyChessBoard.indexToPosition(targetIndex);
              // 不跨越前线绘制对角线
              if ((row < 6 && targetRow < 6) || (row >= 6 && targetRow >= 6)) {
                final targetYOffset = targetRow >= 6 ? frontlineGap : 0.0;
                final targetCenterX = targetCol * cellWidth + cellWidth / 2;
                final targetCenterY =
                    targetRow * cellHeight + cellHeight / 2 + targetYOffset;
                canvas.drawLine(
                  Offset(centerX, centerY),
                  Offset(targetCenterX, targetCenterY),
                  paint,
                );
              }
            }
          }
        }
      }
    }
  }

  bool _isHorizontalRailroad(int row) {
    return row == 1 || row == 5 || row == 6 || row == 10;
  }

  bool _isVerticalRailroad(int col, int row) {
    // 铁路垂直段：row 1->10 (不含10->11)
    return (col == 0 || col == 4) && row >= 1 && row < 10;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ArmyChessCell extends StatelessWidget {
  final models.ArmyPiece? piece;
  final bool isSelected;
  final bool isValidMove;
  final models.CellType cellType;
  final VoidCallback onTap;

  const ArmyChessCell({
    super.key,
    required this.piece,
    required this.isSelected,
    required this.isValidMove,
    required this.cellType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isCamp = cellType == models.CellType.camp;
    final isPieceInCamp = piece != null && isCamp;

    if (isPieceInCamp) {
      return GestureDetector(
        onTap: onTap,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 行营轮廓
            _buildMainContainer(forceSquare: true),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.amber.shade400, width: 2),
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: _buildMainContainer(forceSquare: false),
    );
  }

  Widget _buildMainContainer({required bool forceSquare}) {
    final isCamp = cellType == models.CellType.camp;
    // 如果强制方形（用于行营中的棋子），或者本来就不是行营，则为方形
    final isSquare = forceSquare || !isCamp;

    return Container(
      decoration: BoxDecoration(
        color: _getCellColor(),
        shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
        border: Border.all(
          color: isSelected
              ? Colors.yellow.shade600
              : isValidMove
              ? Colors.green.shade500
              : Colors.brown.shade600,
          width: isSelected ? 3 : (isValidMove ? 2 : 1),
        ),
        borderRadius: isSquare
            ? (cellType == models.CellType.headquarters
                  ? const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ) // 拱形大本营
                  : BorderRadius.circular(4))
            : null,
        boxShadow: piece != null
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 2,
                  offset: const Offset(1, 1),
                ),
              ]
            : null,
      ),
      child: Center(child: _buildContent()),
    );
  }

  Color _getCellColor() {
    if (cellType == models.CellType.camp && piece == null) {
      return Colors.amber.shade100.withValues(alpha: 0.5);
    }

    if (cellType == models.CellType.headquarters && piece == null) {
      return Colors.grey.shade300.withValues(alpha: 0.5);
    }

    if (piece == null) {
      return isValidMove ? Colors.green.shade100 : const Color(0xFFF5DEB3);
    }

    if (!piece!.isFaceUp) {
      return const Color(0xFF5D4037);
    }

    return piece!.side == models.ArmySide.red
        ? Colors.red.shade50
        : Colors.blue.shade50;
  }

  Widget _buildContent() {
    if (piece == null) {
      if (isValidMove) {
        return Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: Colors.green.shade500,
            shape: BoxShape.circle,
          ),
        );
      }
      return Center(
        child: Text(
          _getCellLabel(),
          style: TextStyle(
            color: Colors.brown.withValues(alpha: 0.3),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    if (!piece!.isFaceUp) {
      return const Text(
        '',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white70,
        ),
      );
    }

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Text(
          piece!.type.displayName,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: piece!.side == models.ArmySide.red
                ? Colors.red.shade800
                : Colors.blue.shade800,
          ),
        ),
      ),
    );
  }

  String _getCellLabel() {
    switch (cellType) {
      case models.CellType.station:
        return '兵站';
      case models.CellType.camp:
        return '行营';
      case models.CellType.headquarters:
        return '大本营';
    }
  }
}
