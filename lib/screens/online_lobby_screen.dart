import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_name_generator/random_name_generator.dart';

import '../config/app_config.dart';
import '../providers/online_game.dart';
import 'online_game_screen.dart';

class OnlineLobbyScreen extends ConsumerStatefulWidget {
  const OnlineLobbyScreen({super.key});

  @override
  ConsumerState<OnlineLobbyScreen> createState() => _OnlineLobbyScreenState();
}

class _OnlineLobbyScreenState extends ConsumerState<OnlineLobbyScreen>
    with WidgetsBindingObserver {
  final _playerNameController = TextEditingController();
  final _roomIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _playerNameController.text = RandomNames(Zone.us).name();
    _playerNameController.addListener(() => setState(() {}));
    _roomIdController.addListener(() => setState(() {}));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _connectIfNeeded();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _playerNameController.dispose();
    _roomIdController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && mounted) {
      // 当应用恢复时，尝试连接（如果需要）
      _connectIfNeeded();
    }
  }

  /// 如果尚未连接，则连接到服务器
  Future<void> _connectIfNeeded() async {
    // Notifier中的connect方法现在是幂等的，可以安全地多次调用
    await ref.read(onlineGameProvider.notifier).connect();
  }

  /// 清理当前状态（例如用户点击返回主菜单时）
  void _cleanupState() {
    // Notifier现在有一个专用的清理方法
    ref.read(onlineGameProvider.notifier).cleanup();
  }

  @override
  Widget build(BuildContext context) {
    final onlineState = ref.watch(onlineGameProvider);

    // 检查是否已经在房间中，如果是则直接跳转到游戏屏幕
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (onlineState.roomInfo != null && onlineState.myPlayerInfo != null) {
        // 避免在build过程中导航
        if (ModalRoute.of(context)?.isCurrent ?? false) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const OnlineGameScreen()),
          );
        }
      }
    });

    // 监听状态变化
    ref.listen<OnlineGameState>(onlineGameProvider, (previous, next) {
      // 房间创建或加入成功，进入游戏
      if (previous?.roomInfo == null &&
          next.roomInfo != null &&
          next.myPlayerInfo != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const OnlineGameScreen()),
        );
      }

      // 显示错误信息
      if (next.error != null &&
          previous?.error != next.error &&
          next.connectionStatus == ConnectionStatus.connected) {
        _showErrorDialog('错误', next.error!);
        // 延迟清除错误状态
        Future.microtask(() {
          ref.read(onlineGameProvider.notifier).clearError();
        });
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          // 背景
          Positioned.fill(
            child: Image.asset("images/background.jpg", fit: BoxFit.cover),
          ),

          // 内容
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                        maxWidth: AppConfig.pageMaxWidth,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // 标题
                            _buildTitleAndStatusInfo(onlineState),

                            const SizedBox(height: 20),

                            // 玩家姓名输入
                            _buildPlayerNameInput(),
                            const SizedBox(height: 20),

                            // 房间操作
                            _buildCreateRoomSection(),
                            const SizedBox(height: 10),
                            _buildJoinRoomSection(),

                            const SizedBox(height: 30),
                            // 返回按钮
                            _buildBackButton(),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleAndStatusInfo(OnlineGameState onlineState) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            '🌐 在线对战',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          // 连接状态
          _buildConnectionStatus(onlineState),

          // 开发模式：显示服务器地址
          if (AppConfig.isDebug) _buildServerInfo(),
        ],
      ),
    );
  }

  Widget _buildConnectionStatus(OnlineGameState state) {
    final Widget statusWidget;
    final String statusText;

    switch (state.connectionStatus) {
      case ConnectionStatus.initial:
      case ConnectionStatus.connecting:
        statusText = '正在连接...';
        statusWidget = const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.orange,
          ),
        );
        break;
      case ConnectionStatus.connected:
        statusText = '已连接服务器';
        statusWidget = const Icon(
          Icons.check_circle,
          size: 20,
          color: Colors.green,
        );
        break;
      case ConnectionStatus.disconnected:
        statusText = state.error ?? '连接断开';
        statusWidget = const Icon(Icons.error, size: 20, color: Colors.red);
        break;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (statusWidget is! Row) statusWidget,
        if (statusWidget is Row) statusWidget else const SizedBox(width: 8),
        Text(
          statusText,
          style: TextStyle(
            color: statusWidget is Icon
                ? (statusWidget.color)
                : state.connectionStatus == ConnectionStatus.disconnected
                ? Colors.red
                : Colors.orange,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Widget _buildServerInfo() {
    final onlineState = ref.watch(onlineGameProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                '开发模式 - 服务器: ${AppConfig.serverUrl}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '调试: status=${onlineState.connectionStatus.name}, joining=${onlineState.isJoiningRoom}',
          style: const TextStyle(color: Colors.white, fontSize: 10),
        ),
        Text(
          '错误=${onlineState.error ?? "无"}',
          style: const TextStyle(color: Colors.white, fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildPlayerNameInput() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '玩家姓名',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E3A4B),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _playerNameController,
            decoration: InputDecoration(
              hintText: '请输入您的姓名',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.person),
            ),
            maxLength: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildCreateRoomSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.add_circle, size: 48, color: Colors.green),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '创建房间',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E3A4B),
                    ),
                  ),
                  const Text(
                    '创建一个新房间，邀请朋友加入',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _canCreateRoom() ? _createRoom : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                _getCreateRoomButtonText(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJoinRoomSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.meeting_room, size: 48, color: Colors.blue),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '加入房间',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E3A4B),
                    ),
                  ),
                  const Text(
                    '输入6位房间号加入游戏',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),
          TextField(
            controller: _roomIdController,
            decoration: InputDecoration(
              hintText: '输入6位房间号',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.vpn_key),
            ),
            maxLength: 6,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _canJoinRoom() ? _joinRoom : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                _getJoinRoomButtonText(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          _cleanupState();
          Navigator.of(context).pop();
        },
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(color: Colors.white, width: 2),
        ),
        child: const Text(
          '返回主菜单',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  bool _canCreateRoom() {
    final onlineState = ref.watch(onlineGameProvider);
    return _playerNameController.text.trim().isNotEmpty &&
        onlineState.connectionStatus == ConnectionStatus.connected &&
        !onlineState.isJoiningRoom;
  }

  bool _canJoinRoom() {
    final onlineState = ref.watch(onlineGameProvider);
    return _playerNameController.text.trim().isNotEmpty &&
        _roomIdController.text.trim().length == 6 &&
        onlineState.connectionStatus == ConnectionStatus.connected &&
        !onlineState.isJoiningRoom;
  }

  String _getCreateRoomButtonText() {
    final onlineState = ref.watch(onlineGameProvider);
    switch (onlineState.connectionStatus) {
      case ConnectionStatus.connecting:
      case ConnectionStatus.initial:
        return '连接中...';
      case ConnectionStatus.disconnected:
        return '未连接服务器';
      case ConnectionStatus.connected:
        if (onlineState.isJoiningRoom) {
          return '正在加入...';
        }
        if (_playerNameController.text.trim().isEmpty) {
          return '请输入玩家姓名';
        }
        return '创建房间';
    }
  }

  String _getJoinRoomButtonText() {
    final onlineState = ref.watch(onlineGameProvider);
    switch (onlineState.connectionStatus) {
      case ConnectionStatus.connecting:
      case ConnectionStatus.initial:
        return '连接中...';
      case ConnectionStatus.disconnected:
        return '未连接服务器';
      case ConnectionStatus.connected:
        if (onlineState.isJoiningRoom) {
          return '正在加入...';
        }
        if (_playerNameController.text.trim().isEmpty) {
          return '请输入玩家姓名';
        }
        if (_roomIdController.text.trim().length != 6) {
          return '请输入6位房间号';
        }
        return '加入房间';
    }
  }

  void _createRoom() {
    final playerName = _playerNameController.text.trim();
    if (playerName.isNotEmpty) {
      ref.read(onlineGameProvider.notifier).createRoom(playerName);
    }
  }

  void _joinRoom() {
    final playerName = _playerNameController.text.trim();
    final roomId = _roomIdController.text.trim();

    if (playerName.isNotEmpty && roomId.length == 6) {
      ref.read(onlineGameProvider.notifier).joinRoom(roomId, playerName);
    }
  }

  void _showErrorDialog(String title, String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(title),
        content: Text(message),
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
