import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_config.dart';
import '../providers/online_game_provider.dart';
import 'online_game_screen.dart';
import 'package:random_name_generator/random_name_generator.dart';

class OnlineLobbyScreen extends ConsumerStatefulWidget {
  const OnlineLobbyScreen({super.key});

  @override
  ConsumerState<OnlineLobbyScreen> createState() => _OnlineLobbyScreenState();
}

class _OnlineLobbyScreenState extends ConsumerState<OnlineLobbyScreen> {
  final _playerNameController = TextEditingController();
  final _roomIdController = TextEditingController();
  bool _isConnecting = false;

  @override
  void initState() {
    super.initState();
    // 自动为玩家生成一个随机名字
    _playerNameController.text = RandomNames(Zone.us).name();
    // 监听文本变化以更新按钮状态
    _playerNameController.addListener(() => setState(() {}));
    _roomIdController.addListener(() => setState(() {}));
    // 延迟连接以避免在 widget 构建期间修改 provider
    Future(() => _connectToServer());
  }

  @override
  void dispose() {
    _playerNameController.dispose();
    _roomIdController.dispose();
    super.dispose();
  }

  /// 清理当前状态（例如用户点击返回主菜单时）
  void _cleanupState() {
    // 如果当前在房间中，先离开房间
    final onlineState = ref.read(onlineGameProvider);
    if (onlineState.roomInfo != null) {
      ref.read(onlineGameProvider.notifier).leaveRoom();
    }
  }

  /// 连接到服务器
  Future<void> _connectToServer() async {
    setState(() => _isConnecting = true);

    final notifier = ref.read(onlineGameProvider.notifier);
    final success = await notifier.connect(serverUrl: AppConfig.serverUrl);

    setState(() => _isConnecting = false);

    if (!success && mounted) {
      _showErrorDialog('连接失败', '无法连接到游戏服务器，请检查网络连接');
    }
  }

  @override
  Widget build(BuildContext context) {
    final onlineState = ref.watch(onlineGameProvider);

    // 检查是否已经在房间中，如果是则直接跳转到游戏屏幕
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (onlineState.roomInfo != null && onlineState.currentPlayer != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const OnlineGameScreen()),
        );
      }
    });

    // 监听状态变化
    ref.listen<OnlineGameState>(onlineGameProvider, (previous, next) {
      // 房间创建或加入成功，进入游戏
      if (previous?.roomInfo == null &&
          next.roomInfo != null &&
          next.currentPlayer != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const OnlineGameScreen()),
        );
      }

      // 显示错误信息
      if (next.error != null) {
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    // 标题
                    _buildTitle(),

                    const SizedBox(height: 10),

                    // 连接状态
                    _buildConnectionStatus(onlineState),

                    // 开发模式：显示服务器地址
                    if (AppConfig.isDebug) _buildServerInfo(),

                    const SizedBox(height: 20),

                    // 玩家姓名输入
                    _buildPlayerNameInput(),

                    const SizedBox(height: 30),

                    // 房间操作
                    if (onlineState.isConnected) ...[
                      _buildCreateRoomSection(),
                      const SizedBox(height: 20),
                      _buildJoinRoomSection(),
                    ],

                    const SizedBox(height: 40),

                    // 返回按钮
                    _buildBackButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
      child: const Text(
        '🌐 在线对战',
        style: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildConnectionStatus(OnlineGameState state) {
    final Widget statusWidget;
    final Color statusColor;
    final String statusText;

    if (_isConnecting || state.isConnecting) {
      statusColor = Colors.orange;
      statusText = '正在连接...';
      statusWidget = const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    } else if (state.isConnected) {
      statusColor = Colors.green;
      statusText = '已连接服务器';
      statusWidget = const Icon(Icons.check_circle, size: 20);
    } else {
      statusColor = Colors.red;
      statusText = '连接断开';
      statusWidget = const Icon(Icons.error, size: 20);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          statusWidget,
          const SizedBox(width: 8),
          Text(
            statusText,
            style: TextStyle(color: statusColor, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildServerInfo() {
    final onlineState = ref.watch(onlineGameProvider);
    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.info_outline, size: 16, color: Colors.blue),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  '开发模式 - 服务器: ${AppConfig.serverUrl}',
                  style: const TextStyle(
                    color: Colors.blue,
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
            '调试: 连接=${onlineState.isConnected}, 连接中=${onlineState.isConnecting}, 错误=${onlineState.error ?? "无"}',
            style: const TextStyle(color: Colors.blue, fontSize: 10),
          ),
          Text(
            '按钮: 可创建=${_canCreateRoom()}, 玩家名=${_playerNameController.text.trim()}',
            style: const TextStyle(color: Colors.blue, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerNameInput() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
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
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.add_circle, size: 48, color: Colors.green),
          const SizedBox(height: 16),
          const Text(
            '创建房间',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E3A4B),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '创建一个新房间，邀请朋友加入',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 20),
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
                _canCreateRoom() ? '创建房间' : _getCreateRoomButtonText(),
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
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.meeting_room, size: 48, color: Colors.blue),
          const SizedBox(height: 16),
          const Text(
            '加入房间',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E3A4B),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '输入6位房间号加入游戏',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 20),
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
          const SizedBox(height: 16),
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
                _canJoinRoom() ? '加入房间' : _getJoinRoomButtonText(),
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
        onlineState.isConnected &&
        !onlineState.isConnecting;
  }

  bool _canJoinRoom() {
    final onlineState = ref.watch(onlineGameProvider);
    return _playerNameController.text.trim().isNotEmpty &&
        _roomIdController.text.trim().length == 6 &&
        onlineState.isConnected &&
        !onlineState.isConnecting;
  }

  String _getCreateRoomButtonText() {
    final onlineState = ref.watch(onlineGameProvider);
    if (!onlineState.isConnected && !onlineState.isConnecting) {
      return '未连接服务器';
    } else if (onlineState.isConnecting) {
      return '连接中...';
    } else if (_playerNameController.text.trim().isEmpty) {
      return '请输入玩家姓名';
    } else {
      return '创建房间';
    }
  }

  String _getJoinRoomButtonText() {
    final onlineState = ref.watch(onlineGameProvider);
    if (!onlineState.isConnected && !onlineState.isConnecting) {
      return '未连接服务器';
    } else if (onlineState.isConnecting) {
      return '连接中...';
    } else if (_playerNameController.text.trim().isEmpty) {
      return '请输入玩家姓名';
    } else if (_roomIdController.text.trim().length != 6) {
      return '请输入6位房间号';
    } else {
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
