import 'dart:io';
import 'package:logging/logging.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

import 'package:frog_game_server/services/room_manager.dart';
import 'package:frog_game_server/handlers/websocket_handler.dart';

void main(List<String> args) async {
  // 设置日志
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  final logger = Logger('Server');

  // 初始化服务
  final roomManager = RoomManager();
  final webSocketManager = WebSocketManager(roomManager);

  // 创建路由
  final router = Router();

  // 健康检查端点
  router.get('/health', (Request request) {
    return Response.ok('OK');
  });

  // 服务器状态端点
  router.get('/stats', (Request request) {
    final stats = roomManager.getStats();
    return Response.ok(
      '{'
      '"status": "running",'
      '"uptime": "${DateTime.now().toIso8601String()}",'
      '"rooms": ${stats['totalRooms']},'
      '"players": ${stats['totalPlayers']},'
      '"activeGames": ${stats['activeGames']}'
      '}',
      headers: {'Content-Type': 'application/json'},
    );
  });

  // WebSocket 端点
  router.get(
    '/frog',
    webSocketHandler((webSocket) {
      logger.info('新的WebSocket连接');
      webSocketManager.handleConnection(webSocket);
    }),
  );

  // 根路径
  router.get('/', (Request request) {
    return Response.ok(
      '''
      <!DOCTYPE html>
      <html>
      <head>
          <title>青蛙跳井游戏服务器</title>
          <meta charset="utf-8">
          <style>
              body { font-family: Arial, sans-serif; margin: 40px; }
              .container { max-width: 600px; margin: 0 auto; }
              .status { background: #e8f5e8; padding: 20px; border-radius: 8px; margin: 20px 0; }
              .endpoint { background: #f5f5f5; padding: 15px; border-radius: 5px; margin: 10px 0; }
              .code { font-family: monospace; background: #f0f0f0; padding: 2px 4px; }
          </style>
      </head>
      <body>
          <div class="container">
              <h1>🐸 青蛙跳井游戏服务器</h1>
              <div class="status">
                  <h3>✅ 服务器运行中</h3>
                  <p>服务器时间: ${DateTime.now().toString()}</p>
              </div>
              
              <h2>API 端点</h2>
              <div class="endpoint">
                  <strong>WebSocket:</strong> <span class="code">ws://localhost:8080/frog</span><br>
                  用于游戏实时通信
              </div>
              <div class="endpoint">
                  <strong>健康检查:</strong> <span class="code">GET /health</span><br>
                  检查服务器状态
              </div>
              <div class="endpoint">
                  <strong>服务器统计:</strong> <span class="code">GET /stats</span><br>
                  获取服务器统计信息
              </div>
              
              <h2>使用说明</h2>
              <ol>
                  <li>客户端连接到 WebSocket 端点</li>
                  <li>发送创建房间或加入房间消息</li>
                  <li>开始游戏并通过 WebSocket 进行实时通信</li>
              </ol>
          </div>
      </body>
      </html>
      ''',
      headers: {'Content-Type': 'text/html; charset=utf-8'},
    );
  });

  // 中间件
  final handler = Pipeline()
      .addMiddleware(corsHeaders())
      .addMiddleware(logRequests())
      .addHandler(router.call);

  // 启动服务器
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, InternetAddress.anyIPv4, port);

  logger.info('🚀 服务器启动成功!');
  logger.info('📡 监听地址: http://${server.address.host}:${server.port}');
  logger.info('🔗 WebSocket: ws://${server.address.host}:${server.port}/frog');
  logger.info('📊 状态页面: http://${server.address.host}:${server.port}/stats');

  // 优雅关闭处理
  ProcessSignal.sigint.watch().listen((signal) async {
    logger.info('收到关闭信号，正在优雅关闭服务器...');
    await server.close(force: true);
    exit(0);
  });
}
