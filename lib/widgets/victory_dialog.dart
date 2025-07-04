import 'package:flutter/material.dart';
import '../models/game_state.dart';

class VictoryDialog extends StatefulWidget {
  final GameStatus gameStatus;
  final bool isAiMode;
  final VoidCallback onPlayAgain;
  final VoidCallback onGoToMenu;

  const VictoryDialog({
    super.key,
    required this.gameStatus,
    required this.isAiMode,
    required this.onPlayAgain,
    required this.onGoToMenu,
  });

  @override
  State<VictoryDialog> createState() => _VictoryDialogState();
}

class _VictoryDialogState extends State<VictoryDialog>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
    );

    // 启动动画
    _scaleController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _rotationController.forward();
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Container(
            padding: const EdgeInsets.all(25),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 动画图标
                RotationTransition(
                  turns: _rotationAnimation,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: _getStatusColor().withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getStatusIcon(),
                      size: 40,
                      color: _getStatusColor(),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // 标题
                Text(
                  _getTitle(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(),
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 5),

                // 副标题
                Text(
                  _getSubtitle(),
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 25),

                // 按钮
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        widget.onGoToMenu();
                      },
                      icon: const Icon(Icons.menu),
                      label: const Text('返回菜单'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        widget.onPlayAgain();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('再来一局'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _getStatusColor(),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getTitle() {
    switch (widget.gameStatus) {
      case GameStatus.xWins:
        return '🎉 玩家 × 获胜！';
      case GameStatus.oWins:
        return widget.isAiMode ? '🤖 AI 获胜！' : '🎉 玩家 ○ 获胜！';
      case GameStatus.draw:
        return '🤝 平局！';
      default:
        return '';
    }
  }

  String _getSubtitle() {
    switch (widget.gameStatus) {
      case GameStatus.xWins:
        return '恭喜你赢得了这局游戏！';
      case GameStatus.oWins:
        return widget.isAiMode ? '别灰心，再试一次吧！' : '恭喜获胜者！';
      case GameStatus.draw:
        return '势均力敌，不分胜负！';
      default:
        return '';
    }
  }

  IconData _getStatusIcon() {
    switch (widget.gameStatus) {
      case GameStatus.xWins:
      case GameStatus.oWins:
        return Icons.emoji_events;
      case GameStatus.draw:
        return Icons.handshake;
      default:
        return Icons.help;
    }
  }

  Color _getStatusColor() {
    switch (widget.gameStatus) {
      case GameStatus.xWins:
        return Colors.blue.shade600; // X获胜 - 蓝色
      case GameStatus.oWins:
        return widget.isAiMode
            ? Colors.orange.shade600
            : Colors.red.shade600; // O获胜 - AI橙色/玩家红色
      case GameStatus.draw:
        return Colors.amber.shade600; // 平局 - 琥珀色（中性色）
      default:
        return Colors.grey;
    }
  }
}
