import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/network_message.dart';
import '../providers/online_game.dart';
import '../models/game_state.dart';
import '../widgets/game_board.dart';
import '../widgets/online_victory_dialog.dart';

class OnlineGameScreen extends ConsumerStatefulWidget {
  const OnlineGameScreen({super.key});

  @override
  ConsumerState<OnlineGameScreen> createState() => _OnlineGameScreenState();
}

class _OnlineGameScreenState extends ConsumerState<OnlineGameScreen> {
  GameStatus? _lastGameStatus;

  @override
  Widget build(BuildContext context) {
    final onlineState = ref.watch(onlineGameProvider);

    // 监听游戏状态变化，显示获胜弹窗
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_lastGameStatus != onlineState.gameState.status &&
          onlineState.gameState.status != GameStatus.playing) {
        _showVictoryDialog(onlineState);
      }
      _lastGameStatus = onlineState.gameState.status;
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
            child: Column(
              children: [
                // 顶部房间信息
                _buildRoomHeader(context, onlineState),

                // 游戏区域
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // 当前回合信息
                        _buildTurnIndicator(onlineState),

                        const SizedBox(height: 20),

                        // 游戏棋盘
                        Expanded(
                          child: Center(
                            child: GameBoard(
                              gameState: onlineState.gameState,
                              onCellTap: (index) =>
                                  _onCellTap(ref, onlineState, index),
                              isOnlineMode: true,
                              isMyTurn: onlineState.isMyTurn,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // 底部按钮
                        _buildBottomButtons(context, ref, onlineState),
                      ],
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

  Widget _buildRoomHeader(BuildContext context, OnlineGameState state) {
    final roomInfo = state.roomInfo;
    if (roomInfo == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '房间号: ${roomInfo.roomId}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '玩家: ${roomInfo.players.length}/2',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // 复制房间号按钮
              IconButton(
                onPressed: () => _copyRoomId(context, roomInfo.roomId),
                icon: const Icon(Icons.copy, color: Colors.white),
                tooltip: '复制房间号',
              ),

              // 离开房间按钮
              IconButton(
                onPressed: () => _showLeaveRoomDialog(context),
                icon: const Icon(Icons.exit_to_app, color: Colors.white),
                tooltip: '离开房间',
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 玩家信息
          _buildPlayersInfo(state),
        ],
      ),
    );
  }

  Widget _buildPlayersInfo(OnlineGameState state) {
    final players = state.roomInfo?.players ?? [];

    return Row(
      children: [
        // 玩家1 (X)
        Expanded(
          child: _buildPlayerCard(
            players.isNotEmpty ? players[0] : null,
            Player.x,
            state.currentPlayer?.playerId,
          ),
        ),

        const SizedBox(width: 12),

        // VS 分隔符
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'VS',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),

        const SizedBox(width: 12),

        // 玩家2 (O)
        Expanded(
          child: _buildPlayerCard(
            players.length > 1 ? players[1] : null,
            Player.o,
            state.currentPlayer?.playerId,
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerCard(
    PlayerInfo? player,
    Player symbol,
    String? myPlayerId,
  ) {
    final isMe = player?.playerId == myPlayerId;
    final symbolText = symbol == Player.x ? 'X' : 'O';
    final color = symbol == Player.x ? Colors.blue : Colors.red;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isMe
            ? color.withValues(alpha: 0.3)
            : Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: isMe ? Border.all(color: color, width: 2) : null,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    symbolText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              if (isMe) ...[
                const SizedBox(width: 4),
                const Icon(Icons.person, color: Colors.white, size: 16),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            player?.playerName ?? '等待加入...',
            style: TextStyle(
              color: player != null
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.5),
              fontSize: 12,
              fontWeight: isMe ? FontWeight.bold : FontWeight.normal,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildTurnIndicator(OnlineGameState state) {
    if (state.gameState.status != GameStatus.playing) {
      return _buildGameResult(state.gameState.status);
    }

    final isMyTurn = state.isMyTurn;
    final currentPlayerSymbol = state.gameState.currentPlayer == Player.x
        ? 'X'
        : 'O';
    final color = state.gameState.currentPlayer == Player.x
        ? Colors.blue
        : Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isMyTurn
            ? color.withValues(alpha: 0.3)
            : Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: isMyTurn ? color : Colors.white.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Center(
              child: Text(
                currentPlayerSymbol,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            isMyTurn ? '您的回合' : '对手回合',
            style: TextStyle(
              color: isMyTurn ? color : Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameResult(GameStatus status) {
    String text;
    Color color;
    IconData icon;

    switch (status) {
      case GameStatus.xWins:
        text = 'X 获胜!';
        color = Colors.blue;
        icon = Icons.celebration;
        break;
      case GameStatus.oWins:
        text = 'O 获胜!';
        color = Colors.red;
        icon = Icons.celebration;
        break;
      case GameStatus.draw:
        text = '平局!';
        color = Colors.orange;
        icon = Icons.handshake;
        break;
      default:
        return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(
    BuildContext context,
    WidgetRef ref,
    OnlineGameState state,
  ) {
    return Row(
      children: [
        // 重新开始游戏
        Expanded(
          child: ElevatedButton(
            onPressed: state.gameState.status != GameStatus.playing
                ? () => ref.read(onlineGameProvider.notifier).resetGame()
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              '重新开始',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),

        const SizedBox(width: 16),

        // 离开房间
        Expanded(
          child: OutlinedButton(
            onPressed: () => _showLeaveRoomDialog(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: const BorderSide(color: Colors.white, width: 2),
            ),
            child: const Text(
              '离开房间',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onCellTap(WidgetRef ref, OnlineGameState state, int index) {
    if (state.isMyTurn && state.gameState.canMakeMove(index)) {
      ref.read(onlineGameProvider.notifier).makeMove(index);
    }
  }

  void _copyRoomId(BuildContext context, String roomId) {
    Clipboard.setData(ClipboardData(text: roomId));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('房间号 $roomId 已复制到剪贴板'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showVictoryDialog(OnlineGameState state) {
    // 找到获胜者信息
    PlayerInfo? winner;
    if (state.roomInfo != null) {
      final winningSymbol = state.gameState.status == GameStatus.xWins
          ? Player.x
          : state.gameState.status == GameStatus.oWins
          ? Player.o
          : null;

      if (winningSymbol != null) {
        winner = state.roomInfo!.players
            .where((p) => p.playerSymbol == winningSymbol)
            .firstOrNull;
      }
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => OnlineVictoryDialog(
        gameStatus: state.gameState.status,
        mySymbol: state.mySymbol,
        winner: winner,
        onPlayAgain: () => ref.read(onlineGameProvider.notifier).resetGame(),
        onLeaveRoom: () => _leaveRoom(),
      ),
    );
  }

  void _leaveRoom() {
    ref.read(onlineGameProvider.notifier).leaveRoom();
    Navigator.of(context).pop(); // 返回到在线大厅
  }

  void _showLeaveRoomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('离开房间'),
        content: const Text('确定要离开当前房间吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _leaveRoom();
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}
