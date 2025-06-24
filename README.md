# 🐸 青蛙跳井 - 在线对战游戏

一个基于 Flutter 开发的在线井字棋游戏，支持实时多人对战。

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)

## ✨ 功能特性

### 游戏模式
- 🤖 **人机对战** - 挑战智能AI，使用Minimax算法
- 👥 **双人对战** - 本地面对面对决
- 🌐 **在线对战** - 与全球玩家实时对战

### 在线对战功能
- 📱 **创建房间** - 快速创建游戏房间
- 🔑 **加入房间** - 输入6位房间号加入游戏
- 🔄 **实时同步** - WebSocket实时游戏状态同步
- 📋 **房间号分享** - 一键复制房间号分享给朋友
- 🎯 **回合制** - 清晰的回合指示和操作限制

### 技术特性
- 🚀 **响应式设计** - 适配各种屏幕尺寸
- 🎨 **现代UI** - Material Design 3设计语言
- ⚡ **高性能** - 优化的游戏逻辑和渲染
- 🔒 **类型安全** - 使用Freezed实现不可变数据模型

## 🏗️ 项目架构

```
frog_game/
├── lib/                          # 客户端代码
│   ├── models/                   # 数据模型
│   │   ├── game_state.dart      # 游戏状态
│   │   └── network_message.dart # 网络消息
│   ├── providers/               # 状态管理
│   │   ├── game_provider.dart   # 单机游戏状态
│   │   └── online_game_provider.dart # 在线游戏状态
│   ├── services/               # 服务层
│   │   └── websocket_service.dart # WebSocket服务
│   ├── screens/                # 页面
│   │   ├── welcome_screen.dart  # 欢迎页面
│   │   ├── game_screen.dart     # 游戏页面
│   │   ├── online_lobby_screen.dart # 在线大厅
│   │   └── online_game_screen.dart  # 在线游戏
│   ├── widgets/                # 组件
│   │   ├── game_board.dart     # 游戏棋盘
│   │   ├── game_menu.dart      # 游戏菜单
│   │   └── victory_dialog.dart # 胜利对话框
│   └── main.dart               # 应用入口
├── server/                     # 服务器代码
│   ├── lib/
│   │   ├── models/            # 服务器模型
│   │   ├── services/          # 业务服务
│   │   └── handlers/          # 请求处理器
│   ├── bin/server.dart        # 服务器入口
│   ├── Dockerfile             # Docker配置
└── images/                   # 资源文件
```

## 🚀 快速开始

### 客户端开发

```bash
# 1. 克隆项目
git clone <repository-url>
cd frog_game

# 2. 安装依赖
flutter pub get

# 3. 生成代码
flutter pub run build_runner build

# 4. 运行应用，不提供则使用默认 devServerUrl
flutter run --dart-define=SERVER_URL=ws://localhost:8080/frog
```

### 服务器开发

```bash
# 进入服务器目录
cd server

# 安装依赖
dart pub get

# 生成代码
dart pub run build_runner build

# 本地运行
dart run bin/server.dart
```

服务器将在 `http://localhost:8080` 启动。

### 服务端部署

```bash
cd server
docker build -t corkine/frog-game:0.0.2 .
docker run -p 8080:8080 corkine/frog-game:0.0.2
```

### 客户端部署

```bash
flutter build macos --release
flutter build web --release --base-href=/frog/
```

## 📡 API 文档

### WebSocket 协议

#### 连接
```
WS ws://server-domain/frog
```

#### 消息格式

所有消息都遵循一个基础的JSON结构。

**客户端 -> 服务器 (C→S)**
```json
{
  "type": "MessageType",
  "roomId": "123456", // 可选，取决于消息类型
  "playerId": "player123",
  "data": { ... }, // 可选，具体结构看消息类型
  "timestamp": 1640995200000
}
```

**服务器 -> 客户端 (S→C)**
```json
{
  "type": "MessageType",
  "roomId": "123456", // 可选
  "playerId": "player123", // 可选
  "data": { // 结构取决于消息类型
    "roomInfo": { ... },
    "gameState": { ... }
    // 或 "message" 用于错误
  },
  "timestamp": 1640995200000
}
```

#### 消息类型

| 类型 | 方向 | `data` 负载说明 |
|--------------|-------|---------------------------------------------------------------------|
| `ping` | C→S | 无 `data` |
| `pong` | S→C | 无 `data` |
| `createRoom` | C→S | `{'playerName': 'string'}` |
| `joinRoom` | C→S | `{'playerName': 'string'}` |
| `leaveRoom` | C→S | 无 `data` |
| `gameMove` | C→S | `{'position': int, 'player': 'X'|'O', ...}` |
| `gameReset` | C→S | 无 `data` |
| `roomCreated` | S→C | `{'roomInfo': RoomInfo, 'gameState': GameState}` |
| `roomJoined` | S→C | `{'roomInfo': RoomInfo, 'gameState': GameState}` |
| `playerJoined` | S→C | `{'roomInfo': RoomInfo, 'gameState': GameState}` |
| `playerLeft` | S→C | `{'roomInfo': RoomInfo, 'gameState': GameState}` |
| `gameUpdate` | S→C | `{'roomInfo': RoomInfo, 'gameState': GameState}` |
| `gameOver` | S→C | `{'roomInfo': RoomInfo, 'gameState': GameState}` |
| `gameReset` | S→C | `{'roomInfo': RoomInfo, 'gameState': GameState}` |
| `error` | S→C | `{'message': 'string'}` |

### HTTP 端点

| 端点 | 方法 | 说明 |
|------|------|------|
| `/` | GET | 服务器首页 |
| `/health` | GET | 健康检查 |
| `/stats` | GET | 服务器统计 |
| `/frog` | GET | WebSocket升级 |

## 🛠️ 开发指南

### 添加新功能

1. **客户端**
   - 在 `lib/models/` 中添加新的数据模型
   - 在 `lib/providers/` 中添加状态管理
   - 在 `lib/screens/` 和 `lib/widgets/` 中添加UI组件

2. **服务器**
   - 在 `server/lib/models/` 中添加数据模型
   - 在 `server/lib/services/` 中添加业务逻辑
   - 在 `server/lib/handlers/` 中添加请求处理

### 代码生成

项目使用了代码生成工具，在修改模型后需要重新生成：

```bash
# 客户端
flutter pub run build_runner build --delete-conflicting-outputs

# 服务器
cd server
dart pub run build_runner build --delete-conflicting-outputs
```

### 调试

1. **客户端调试**
   - 使用 Flutter DevTools
   - 查看控制台日志

2. **服务器调试**
   - 查看服务器日志
   - 使用 `/stats` 端点查看状态

## 📋 系统要求

### 客户端
- Flutter 3.8.0+
- Dart 3.8.0+

### 服务器
- Dart 3.8.0+
- Docker (可选)

### 部署
- 阿里云账号
- 容器镜像服务

## 🤝 贡献指南

1. Fork 项目
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开 Pull Request

## 📝 许可证

该项目基于 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 🔗 相关链接

- [Flutter 官方文档](https://flutter.dev/docs)
- [Dart 官方文档](https://dart.dev/guides)
- [Riverpod 状态管理](https://riverpod.dev/)

## 🎮 游戏规则

井字棋是一个经典的策略游戏：

1. 两名玩家轮流在3×3的网格中放置标记（X和O）
2. 第一个将三个标记连成一线（水平、垂直或对角线）的玩家获胜
3. 如果网格填满且没有玩家获胜，则为平局

---

**享受游戏！** 🎉
