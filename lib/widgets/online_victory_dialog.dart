import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../models/network_message.dart';

class OnlineVictoryDialog extends StatefulWidget {
  final GameStatus gameStatus;
  final Player? mySymbol;
  final PlayerInfo? winner;
  final VoidCallback onPlayAgain;
  final VoidCallback onLeaveRoom;

  const OnlineVictoryDialog({
    super.key,
    required this.gameStatus,
    this.mySymbol,
    this.winner,
    required this.onPlayAgain,
    required this.onLeaveRoom,
  });

  @override
  State<OnlineVictoryDialog> createState() => _OnlineVictoryDialogState();
}

class _OnlineVictoryDialogState extends State<OnlineVictoryDialog>
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
        child: Container(
          padding: const EdgeInsets.all(30),
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
                  width: 80,
                  height: 80,
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

              const SizedBox(height: 10),

              // 副标题
              Text(
                _getSubtitle(),
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              // 按钮
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        widget.onLeaveRoom();
                      },
                      icon: const Icon(Icons.exit_to_app),
                      label: const Text('离开房间'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: ElevatedButton.icon(
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTitle() {
    final isIWinner = _isIWinner();

    switch (widget.gameStatus) {
      case GameStatus.xWins:
        if (isIWinner != null) {
          return isIWinner ? '🎉 您获胜了！' : '😢 您失败了';
        }
        return '🎉 玩家 × 获胜！';
      case GameStatus.oWins:
        if (isIWinner != null) {
          return isIWinner ? '🎉 您获胜了！' : '😢 您失败了';
        }
        return '🎉 玩家 ○ 获胜！';
      case GameStatus.draw:
        return '🤝 平局！';
      default:
        return '';
    }
  }

  String _getSubtitle() {
    final isIWinner = _isIWinner();

    if (widget.gameStatus == GameStatus.draw) {
      return '势均力敌，不分胜负！';
    }

    if (isIWinner != null) {
      if (isIWinner) {
        return '恭喜您在在线对战中获胜！';
      } else {
        return '别灰心，再来一局吧！';
      }
    }

    final winnerName = widget.winner?.playerName ?? '获胜者';
    return '恭喜 $winnerName 获得胜利！';
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
    final isIWinner = _isIWinner();

    // 如果能确定是否是我赢了，使用通用的胜负颜色
    if (isIWinner != null) {
      if (isIWinner) {
        return Colors.green.shade600; // 我赢了 - 绿色（成功色）
      } else {
        return Colors.red.shade600; // 我输了 - 红色（失败色）
      }
    }

    // 如果无法确定胜负关系，使用游戏状态对应的颜色
    switch (widget.gameStatus) {
      case GameStatus.xWins:
        return Colors.blue.shade600; // X获胜 - 蓝色
      case GameStatus.oWins:
        return Colors.orange.shade600; // O获胜 - 橙色
      case GameStatus.draw:
        return Colors.amber.shade600; // 平局 - 琥珀色（中性色）
      default:
        return Colors.grey;
    }
  }

  bool? _isIWinner() {
    if (widget.mySymbol == null) return null;

    switch (widget.gameStatus) {
      case GameStatus.xWins:
        return widget.mySymbol == Player.x;
      case GameStatus.oWins:
        return widget.mySymbol == Player.o;
      case GameStatus.draw:
        return null; // 平局不分胜负
      default:
        return null;
    }
  }
}
