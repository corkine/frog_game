import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_config.dart';
import '../models/game_state.dart';
import '../providers/game.dart';
import '../widgets/game_board.dart';
import '../widgets/victory_dialog.dart';
import '../widgets/game_menu.dart';
import 'welcome_screen.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  GameStatus? _lastGameStatus;

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);
    final gameNotifier = ref.read(gameProvider.notifier);

    // 监听游戏状态变化，显示获胜弹窗
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_lastGameStatus != gameState.status &&
          gameState.status != GameStatus.playing) {
        _showVictoryDialog(gameState, gameNotifier);
      }
      _lastGameStatus = gameState.status;
    });

    return Scaffold(
      body: Stack(
        children: [
          // 背景图片
          Positioned.fill(
            child: Image.asset("images/background.jpg", fit: BoxFit.cover),
          ),

          // 内容
          SafeArea(
            child: Column(
              children: [
                // AppBar区域
                _buildAppBar(context, gameState, gameNotifier),

                // 游戏内容
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: AppConfig.pageMaxWidth,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            // 游戏状态信息
                            _buildGameStatus(gameState),
                            const SizedBox(height: 20),

                            // 游戏棋盘 - 更加突出和居中
                            const Expanded(child: Center(child: GameBoard())),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(
    BuildContext context,
    GameState gameState,
    Game gameNotifier,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 48), // 占位，保持标题居中
          const Text(
            '🐸 青蛙跳井',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () => _showGameMenu(context, gameState, gameNotifier),
            icon: const Icon(Icons.menu, color: Colors.white, size: 28),
            tooltip: '游戏菜单',
          ),
        ],
      ),
    );
  }

  void _showGameMenu(
    BuildContext context,
    GameState gameState,
    Game gameNotifier,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => GameMenu(
        gameState: gameState,
        onRestart: () => gameNotifier.resetGame(aiMode: gameState.isAiMode),
        onChangeToAI: () => gameNotifier.resetGame(aiMode: true),
        onChangeToHuman: () => gameNotifier.resetGame(aiMode: false),
      ),
    );
  }

  void _showVictoryDialog(GameState gameState, Game gameNotifier) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => VictoryDialog(
        gameStatus: gameState.status,
        isAiMode: gameState.isAiMode,
        onPlayAgain: () => gameNotifier.resetGame(aiMode: gameState.isAiMode),
        onGoToMenu: _goBackToMenu,
      ),
    );
  }

  /// 导航回主菜单并清空所有其他页面
  void _goBackToMenu() {
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        (route) => false,
      );
    }
  }

  Widget _buildGameStatus(GameState gameState) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (gameState.status == GameStatus.playing) ...[
            if (gameState.isAiMode && gameState.currentPlayer == Player.o) ...[
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.orange.shade400,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'AI正在思考...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.orange.shade400,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ] else ...[
              Icon(
                gameState.currentPlayer == Player.x
                    ? Icons.close
                    : Icons.radio_button_unchecked,
                color: _getCurrentPlayerColor(gameState),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '轮到 ${gameState.currentPlayer == Player.x ? "×" : "○"} 下棋',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            const SizedBox(width: 15),
            Container(
              width: 1,
              height: 16,
              color: Colors.white.withValues(alpha: 0.3),
            ),
            const SizedBox(width: 15),
          ],
          Text(
            _getStatusText(gameState),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText(GameState gameState) {
    switch (gameState.status) {
      case GameStatus.xWins:
        return '🎉 × 获胜';
      case GameStatus.oWins:
        return gameState.isAiMode ? '🤖 AI 获胜' : '🎉 ○ 获胜';
      case GameStatus.draw:
        return '🤝 平局';
      case GameStatus.playing:
        return gameState.isAiMode ? '🎮 VS AI' : '👥 双人对战';
    }
  }

  Color _getCurrentPlayerColor(GameState gameState) {
    return gameState.currentPlayer == Player.x
        ? Colors.blue.shade400
        : Colors.red.shade400;
  }
}
