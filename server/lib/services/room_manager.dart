import 'dart:math';
import 'package:logging/logging.dart';
import '../models/game_models.dart';

/// 房间管理器
class RoomManager {
  static final _logger = Logger('RoomManager');

  // 房间存储 - 内存中存储，生产环境可以考虑使用 Redis
  final Map<String, GameRoom> _rooms = {};

  // 玩家到房间的映射
  final Map<String, String> _playerToRoom = {};

  /// 创建房间
  String createRoom(String playerId, String playerName) {
    final roomId = _generateRoomId();

    final player = PlayerInfo(
      playerId: playerId,
      playerName: playerName,
      playerSymbol: Player.x, // 创建者总是 X
      joinedAt: DateTime.now().millisecondsSinceEpoch,
    );

    final room = GameRoom(
      roomId: roomId,
      players: [player],
      gameState: const GameState(),
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    _rooms[roomId] = room;
    _playerToRoom[playerId] = roomId;

    _logger.info('房间创建成功: $roomId, 创建者: $playerName');
    return roomId;
  }

  /// 加入房间
  RoomJoinResult joinRoom(String roomId, String playerId, String playerName) {
    final room = _rooms[roomId];
    if (room == null) {
      return RoomJoinResult.error('房间不存在');
    }

    // 检查房间是否已满
    if (room.players.length >= 2) {
      return RoomJoinResult.error('房间已满');
    }

    // 检查玩家是否已经在房间中
    final existingPlayer = room.players
        .where((p) => p.playerId == playerId)
        .firstOrNull;
    if (existingPlayer != null) {
      return RoomJoinResult.error('您已经在房间中');
    }

    // 修复：动态决定玩家符号，而不是硬编码为 O
    final existingSymbols = room.players.map((p) => p.playerSymbol).toSet();
    final newPlayerSymbol = existingSymbols.contains(Player.x)
        ? Player.o
        : Player.x;

    final player = PlayerInfo(
      playerId: playerId,
      playerName: playerName,
      playerSymbol: newPlayerSymbol,
      joinedAt: DateTime.now().millisecondsSinceEpoch,
    );

    final updatedPlayers = [...room.players, player];
    final updatedRoom = room.copyWith(players: updatedPlayers);

    _rooms[roomId] = updatedRoom;
    _playerToRoom[playerId] = roomId;

    _logger.info('玩家 $playerName 加入房间 $roomId');
    return RoomJoinResult.success(updatedRoom);
  }

  /// 离开房间
  RoomLeaveResult leaveRoom(String playerId) {
    final roomId = _playerToRoom[playerId];
    if (roomId == null) {
      return RoomLeaveResult.error('您不在任何房间中');
    }

    final room = _rooms[roomId];
    if (room == null) {
      _playerToRoom.remove(playerId);
      return RoomLeaveResult.error('房间不存在');
    }

    final updatedPlayers = room.players
        .where((p) => p.playerId != playerId)
        .toList();
    _playerToRoom.remove(playerId);

    // 如果房间为空，删除房间
    if (updatedPlayers.isEmpty) {
      _rooms.remove(roomId);
      _logger.info('房间 $roomId 已删除（无玩家）');
      return RoomLeaveResult.roomDeleted(roomId);
    }

    // 更新房间信息
    final updatedRoom = room.copyWith(players: updatedPlayers);
    _rooms[roomId] = updatedRoom;

    _logger.info('玩家 $playerId 离开房间 $roomId');
    return RoomLeaveResult.success(updatedRoom, playerId);
  }

  /// 处理游戏移动
  GameMoveResult makeMove(String playerId, int position) {
    final roomId = _playerToRoom[playerId];
    if (roomId == null) {
      return GameMoveResult.error('您不在任何房间中');
    }

    final room = _rooms[roomId];
    if (room == null) {
      return GameMoveResult.error('房间不存在');
    }

    // 检查是否是该玩家的回合
    final player = room.players
        .where((p) => p.playerId == playerId)
        .firstOrNull;
    if (player == null) {
      return GameMoveResult.error('您不在此房间中');
    }

    if (room.gameState.currentPlayer != player.playerSymbol) {
      return GameMoveResult.error('不是您的回合');
    }

    // 检查移动是否有效
    if (!room.gameState.canMakeMove(position)) {
      return GameMoveResult.error('无效的移动');
    }

    // 执行移动
    final newBoard = List<Player?>.from(room.gameState.board);
    newBoard[position] = player.playerSymbol!;

    var newGameState = room.gameState.copyWith(board: newBoard);
    final newStatus = newGameState.checkWinStatus();

    newGameState = newGameState.copyWith(
      currentPlayer: newGameState.currentPlayer == Player.x
          ? Player.o
          : Player.x,
      status: newStatus,
    );

    final updatedRoom = room.copyWith(gameState: newGameState);
    _rooms[roomId] = updatedRoom;

    final moveData = GameMoveData(
      position: position,
      player: player.playerSymbol!,
      playerId: playerId,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );

    _logger.info('玩家 $playerId 在房间 $roomId 位置 $position 落子');
    return GameMoveResult.success(updatedRoom, moveData);
  }

  /// 重置游戏
  GameResetResult resetGame(String playerId) {
    final roomId = _playerToRoom[playerId];
    if (roomId == null) {
      return GameResetResult.error('您不在任何房间中');
    }

    final room = _rooms[roomId];
    if (room == null) {
      return GameResetResult.error('房间不存在');
    }

    final newGameState = const GameState();
    final updatedRoom = room.copyWith(gameState: newGameState);
    _rooms[roomId] = updatedRoom;

    _logger.info('玩家 $playerId 重置房间 $roomId 的游戏');
    return GameResetResult.success(updatedRoom);
  }

  /// 获取房间信息
  GameRoom? getRoom(String roomId) {
    return _rooms[roomId];
  }

  /// 获取玩家所在的房间
  GameRoom? getPlayerRoom(String playerId) {
    final roomId = _playerToRoom[playerId];
    if (roomId == null) return null;
    return _rooms[roomId];
  }

  /// 生成6位数房间号
  String _generateRoomId() {
    String roomId;
    do {
      roomId = Random().nextInt(900000).toString().padLeft(6, '0');
      roomId = (100000 + Random().nextInt(900000)).toString();
    } while (_rooms.containsKey(roomId));
    return roomId;
  }

  /// 获取房间统计信息
  Map<String, dynamic> getStats() {
    return {
      'totalRooms': _rooms.length,
      'totalPlayers': _playerToRoom.length,
      'activeGames': _rooms.values
          .where((r) => r.gameState.status == GameStatus.playing)
          .length,
    };
  }
}

/// 游戏房间扩展
extension GameRoomX on GameRoom {
  RoomInfo toRoomInfo() {
    return RoomInfo(
      roomId: roomId,
      players: players,
      gameState: gameState,
      isGameStarted: players.length == 2,
      createdAt: createdAt,
    );
  }
}

/// 房间加入结果
sealed class RoomJoinResult {
  const RoomJoinResult();

  factory RoomJoinResult.success(GameRoom room) = RoomJoinSuccess;
  factory RoomJoinResult.error(String message) = RoomJoinError;
}

class RoomJoinSuccess extends RoomJoinResult {
  final GameRoom room;
  const RoomJoinSuccess(this.room);
}

class RoomJoinError extends RoomJoinResult {
  final String message;
  const RoomJoinError(this.message);
}

/// 房间离开结果
sealed class RoomLeaveResult {
  const RoomLeaveResult();

  factory RoomLeaveResult.success(GameRoom room, String playerId) =
      RoomLeaveSuccess;
  factory RoomLeaveResult.roomDeleted(String roomId) = RoomLeaveDeleted;
  factory RoomLeaveResult.error(String message) = RoomLeaveError;
}

class RoomLeaveSuccess extends RoomLeaveResult {
  final GameRoom room;
  final String playerId;
  const RoomLeaveSuccess(this.room, this.playerId);
}

class RoomLeaveDeleted extends RoomLeaveResult {
  final String roomId;
  const RoomLeaveDeleted(this.roomId);
}

class RoomLeaveError extends RoomLeaveResult {
  final String message;
  const RoomLeaveError(this.message);
}

/// 游戏移动结果
sealed class GameMoveResult {
  const GameMoveResult();

  factory GameMoveResult.success(GameRoom room, GameMoveData moveData) =
      GameMoveSuccess;
  factory GameMoveResult.error(String message) = GameMoveError;
}

class GameMoveSuccess extends GameMoveResult {
  final GameRoom room;
  final GameMoveData moveData;
  const GameMoveSuccess(this.room, this.moveData);
}

class GameMoveError extends GameMoveResult {
  final String message;
  const GameMoveError(this.message);
}

/// 游戏重置结果
sealed class GameResetResult {
  const GameResetResult();

  factory GameResetResult.success(GameRoom room) = GameResetSuccess;
  factory GameResetResult.error(String message) = GameResetError;
}

class GameResetSuccess extends GameResetResult {
  final GameRoom room;
  const GameResetSuccess(this.room);
}

class GameResetError extends GameResetResult {
  final String message;
  const GameResetError(this.message);
}

/// 游戏房间类
class GameRoom {
  final String roomId;
  final List<PlayerInfo> players;
  final GameState gameState;
  final int createdAt;

  const GameRoom({
    required this.roomId,
    required this.players,
    required this.gameState,
    required this.createdAt,
  });

  GameRoom copyWith({
    String? roomId,
    List<PlayerInfo>? players,
    GameState? gameState,
    int? createdAt,
  }) {
    return GameRoom(
      roomId: roomId ?? this.roomId,
      players: players ?? this.players,
      gameState: gameState ?? this.gameState,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
