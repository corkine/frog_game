import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/army_chess.dart';
import 'army_chess_screen.dart';

class ArmyChessWelcomeScreen extends ConsumerWidget {
  const ArmyChessWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/army_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 返回按钮
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // 标题
                  _buildTitle(),
                  const SizedBox(height: 40),
                  // 菜单按钮
                  _buildMenuButtons(context, ref),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        const Text('🎖️', style: TextStyle(fontSize: 60)),
        const SizedBox(height: 16),
        const Text(
          '军棋翻翻棋',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black45,
                offset: Offset(2, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '经典军棋对战',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuButtons(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // 双人对战
        _buildMenuButton(
          icon: Icons.people,
          title: '双人对战',
          subtitle: '本地面对面对决',
          color: Colors.orange,
          onTap: () {
            ref.read(armyChessProvider.notifier).resetGame();
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const ArmyChessScreen()),
            );
          },
        ),
        const SizedBox(height: 16),
        // 在线对战（暂未实现）
        _buildMenuButton(
          icon: Icons.wifi,
          title: '在线对战',
          subtitle: '即将开放',
          color: Colors.grey,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('在线对战功能即将开放，敬请期待！'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          enabled: false,
        ),
      ],
    );
  }

  Widget _buildMenuButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    return SizedBox(
      width: 280,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              color: enabled
                  ? color.withValues(alpha: 0.2)
                  : Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: enabled
                    ? color.withValues(alpha: 0.5)
                    : Colors.grey.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Icon(icon, size: 36, color: enabled ? color : Colors.grey),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: enabled ? Colors.white : Colors.grey,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: enabled
                            ? Colors.white.withValues(alpha: 0.7)
                            : Colors.grey.withValues(alpha: 0.5),
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
}
