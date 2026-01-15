import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/army_chess_state.dart';
import '../providers/army_chess.dart';
import '../widgets/army_chess_board.dart';

class ArmyChessScreen extends ConsumerWidget {
  const ArmyChessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(armyChessProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('军棋翻翻棋'),
        centerTitle: true,
        backgroundColor: const Color(0xFF8B4513),
        foregroundColor: Colors.white,
        actions: [
          // 状态显示
          _buildStatusChip(gameState),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(armyChessProvider.notifier).resetGame(),
            tooltip: '重新开始',
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/army_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: const ArmyChessBoardWidget(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(ArmyChessState gameState) {
    String statusText;
    Color statusColor;

    if (gameState.status == ArmyGameStatus.playing) {
      final isRedTurn = gameState.currentPlayer == ArmySide.red;
      statusText = isRedTurn ? '红方' : '蓝方';
      statusColor = isRedTurn ? Colors.red.shade300 : Colors.blue.shade300;
    } else {
      final redWins = gameState.status == ArmyGameStatus.redWins;
      statusText = redWins ? '红胜' : '蓝胜';
      statusColor = redWins ? Colors.red.shade300 : Colors.blue.shade300;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor, width: 1),
      ),
      child: Text(
        statusText,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
