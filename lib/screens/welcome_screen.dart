import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/game.dart';
import '../config/app_config.dart';
import 'game_screen.dart';
import 'online_lobby_screen.dart';
import 'army_chess_welcome_screen.dart';

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

          // 右上角军棋入口
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 16,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ArmyChessWelcomeScreen(),
                  ),
                ),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.brown.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('🎖️', style: TextStyle(fontSize: 16)),
                      SizedBox(width: 4),
                      Text(
                        '军棋',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 内容
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppConfig.pageMaxWidth,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(flex: 2),

                      // 游戏标题区域
                      _buildTitle(context),

                      const Spacer(flex: 2),

                      // 游戏模式选择
                      _buildGameModes(context, ref),

                      const Spacer(flex: 1),

                      // 版本信息
                      _buildVersionInfo(),

                      const SizedBox(height: 10),
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

  Widget _buildTitle(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        if (screenHeight >= 600) ...[
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
          const SizedBox(height: 20),
        ],

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
          title: '人机对战',
          subtitle: '挑战智能AI，测试你的策略',
          color: Colors.blue.shade600,
          onTap: () => _startGame(context, ref, aiMode: true),
        ),
        const SizedBox(height: 10),
        _buildModeButton(
          context: context,
          ref: ref,
          icon: Icons.people,
          title: '双人对战',
          subtitle: '与朋友面对面对决',
          color: Colors.orange.shade600,
          onTap: () => _startGame(context, ref, aiMode: false),
        ),
        const SizedBox(height: 10),
        _buildModeButton(
          context: context,
          ref: ref,
          icon: Icons.wifi,
          title: '在线对战',
          subtitle: '与全球玩家实时对战',
          color: Colors.purple.shade600,
          onTap: () => _goToOnlineLobby(context),
          enabled: true,
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
      child: Text(
        AppConfig.appVersion,
        style: const TextStyle(
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
          padding: const EdgeInsets.all(16),
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
                width: 50,
                height: 50,
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

              const SizedBox(width: 15),

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

  void _goToOnlineLobby(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const OnlineLobbyScreen()));
  }
}
