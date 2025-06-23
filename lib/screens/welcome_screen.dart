import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/game_provider.dart';
import 'game_screen.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        children: [
          // 背景
          Positioned.fill(
            child: Image.asset("images/background.jpg", fit: BoxFit.cover),
          ),

          // 内容
          SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),

                      // 游戏标题区域
                      _buildTitle(),

                      const SizedBox(height: 60),

                      // 游戏模式选择
                      _buildGameModes(context, ref),

                      const SizedBox(height: 40),

                      // 版本信息
                      _buildVersionInfo(),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        // 青蛙图标
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: CircleAvatar(
            child: Text("🐸", style: TextStyle(fontSize: 50)),
          ),
        ),

        const SizedBox(height: 30),

        // 标题
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.2),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              const Text(
                '青蛙跳井',
                style: TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGameModes(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _buildModeButton(
          context: context,
          ref: ref,
          icon: Icons.smart_toy,
          title: '🤖 人机对战',
          subtitle: '挑战智能AI，测试你的策略',
          color: Colors.blue.shade600,
          onTap: () => _startGame(context, ref, aiMode: true),
        ),

        const SizedBox(height: 15),

        _buildModeButton(
          context: context,
          ref: ref,
          icon: Icons.people,
          title: '👥 双人对战',
          subtitle: '与朋友面对面对决',
          color: Colors.orange.shade600,
          onTap: () => _startGame(context, ref, aiMode: false),
        ),

        const SizedBox(height: 15),

        _buildModeButton(
          context: context,
          ref: ref,
          icon: Icons.wifi,
          title: '🌐 在线对战',
          subtitle: '即将推出，敬请期待',
          color: Colors.purple.shade600,
          onTap: () => _showComingSoon(context),
          enabled: false,
        ),
      ],
    );
  }

  Widget _buildVersionInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'Version 1.0.0',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildModeButton({
    required BuildContext context,
    required WidgetRef ref,
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
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: enabled
                ? Colors.white.withValues(alpha: 0.95)
                : Colors.white.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: enabled
                  ? color.withValues(alpha: 0.3)
                  : Colors.grey.shade400,
              width: 2,
            ),
            boxShadow: enabled
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: enabled
                      ? color.withValues(alpha: 0.15)
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  icon,
                  color: enabled ? color : Colors.grey.shade500,
                  size: 30,
                ),
              ),

              const SizedBox(width: 20),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: enabled
                            ? const Color(0xFF2E3A4B)
                            : Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: enabled
                            ? Colors.grey.shade600
                            : Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.arrow_forward_ios,
                color: enabled ? color : Colors.grey.shade500,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startGame(BuildContext context, WidgetRef ref, {required bool aiMode}) {
    ref.read(gameProvider.notifier).resetGame(aiMode: aiMode);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const GameScreen()),
    );
  }

  void _showComingSoon(BuildContext context) {
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
