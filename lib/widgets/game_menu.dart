import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../screens/welcome_screen.dart';

class GameMenu extends StatelessWidget {
  final GameState gameState;
  final VoidCallback onRestart;
  final VoidCallback onChangeToAI;
  final VoidCallback onChangeToHuman;

  const GameMenu({
    super.key,
    required this.gameState,
    required this.onRestart,
    required this.onChangeToAI,
    required this.onChangeToHuman,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 拖拽指示器
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 20),

          // 标题
          Text(
            '游戏菜单',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),

          const SizedBox(height: 30),

          // 菜单项
          _buildMenuItem(
            icon: Icons.refresh,
            title: '重新开始',
            subtitle: '开始新的一局游戏',
            color: Colors.green.shade600,
            onTap: () {
              Navigator.of(context).pop();
              onRestart();
            },
          ),

          _buildDivider(),

          if (!gameState.isAiMode)
            _buildMenuItem(
              icon: Icons.smart_toy,
              title: '切换到人机对战',
              subtitle: '挑战智能AI',
              color: Colors.blue.shade600,
              onTap: () {
                Navigator.of(context).pop();
                onChangeToAI();
              },
            )
          else
            _buildMenuItem(
              icon: Icons.people,
              title: '切换到双人对战',
              subtitle: '与朋友对战',
              color: Colors.orange.shade600,
              onTap: () {
                Navigator.of(context).pop();
                onChangeToHuman();
              },
            ),

          _buildDivider(),

          _buildMenuItem(
            icon: Icons.wifi,
            title: '在线对战',
            subtitle: '即将推出',
            color: Colors.purple.shade600,
            onTap: () => _showComingSoon(context),
            enabled: false,
          ),

          _buildDivider(),

          _buildMenuItem(
            icon: Icons.home,
            title: '返回主菜单',
            subtitle: '回到游戏选择界面',
            color: Colors.red.shade600,
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
              );
            },
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: enabled
                      ? color.withValues(alpha: 0.1)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: enabled ? color : Colors.grey.shade400,
                  size: 24,
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: enabled
                            ? Colors.grey.shade800
                            : Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: enabled
                            ? Colors.grey.shade600
                            : Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),

              if (enabled)
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey.shade400,
                  size: 16,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(height: 1, color: Colors.grey.shade200),
    );
  }

  void _showComingSoon(BuildContext context) {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('🚀 即将推出'),
        content: const Text('在线对战功能正在开发中，敬请期待！'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}
