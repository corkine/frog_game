import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/game_state.dart';
import '../providers/game.dart';

class GameBoard extends ConsumerWidget {
  final GameState? gameState;
  final Function(int)? onCellTap;
  final bool isOnlineMode;
  final bool isMyTurn;

  const GameBoard({
    super.key,
    this.gameState,
    this.onCellTap,
    this.isOnlineMode = false,
    this.isMyTurn = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentGameState = gameState ?? ref.watch(gameProvider);
    final gameNotifier = ref.read(gameProvider.notifier);

    // Ensure we have a valid game state
    if (currentGameState == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(20),
          child: AspectRatio(
            aspectRatio: 1,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                final canTap = isOnlineMode
                    ? (isMyTurn && currentGameState.canMakeMove(index))
                    : currentGameState.canMakeMove(index);

                final tapHandler = isOnlineMode
                    ? () => onCellTap?.call(index)
                    : () => gameNotifier.makeMove(index);

                return GameCell(
                  player: currentGameState.board[index],
                  onTap: tapHandler,
                  canTap: canTap,
                  isMyTurn: isMyTurn,
                  isOnlineMode: isOnlineMode,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class GameCell extends StatelessWidget {
  final Player? player;
  final VoidCallback onTap;
  final bool canTap;
  final bool isMyTurn;
  final bool isOnlineMode;

  const GameCell({
    super.key,
    required this.player,
    required this.onTap,
    required this.canTap,
    this.isMyTurn = true,
    this.isOnlineMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: canTap ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: _getCellColor(),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300, width: 2),
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _buildPlayerIcon(),
            ),
          ),
        ),
      ),
    );
  }

  Color _getCellColor() {
    if (player == null) {
      if (isOnlineMode && !isMyTurn) {
        return Colors.grey.shade200;
      }
      return canTap ? Colors.grey.shade50 : Colors.grey.shade100;
    }
    return player == Player.x ? Colors.blue.shade50 : Colors.red.shade50;
  }

  Widget _buildPlayerIcon() {
    if (player == null) {
      return const SizedBox.shrink();
    }

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Icon(
            player == Player.x ? Icons.close : Icons.radio_button_unchecked,
            size: 40,
            color: player == Player.x
                ? Colors.blue.shade600
                : Colors.red.shade600,
          ),
        );
      },
    );
  }
}
