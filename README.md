# 🐸 青蛙跳井 - 在线对战游戏

一个基于 Flutter 开发的在线井字棋游戏，支持实时多人对战。

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)

<img src="https://static2.mazhangjing.com/cyber/202506/d4c26313_image.png" width="400">

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

# 4. 运行应用
# 在本地开发时，应用默认连接 ws://localhost:8080/frog
# 如果需要连接其他服务器，请使用 --dart-define 指定 SERVER_URL
flutter run --dart-define=SERVER_URL=ws://your-custom-server.com/frog
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

### 构建打包

```bash
# 客户端
flutter build macos \
    --release \
    --dart-define=SERVER_URL=ws://your-custom-server.com/frog \
    --dart-define=APP_VERSION=v1.0.0

# 服务端
cd server
docker build --build-arg APP_VERSION=v1.0.0 -t corkine/frog-game:v1.0.0 .
```

## 📡 API 文档

### WebSocket 协议

#### 连接
```
WS ws://server-domain/frog
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
| `roomCreated` | S→C | `{'roomInfo': RoomInfo}` |
| `roomJoined` | S→C | `{'roomInfo': RoomInfo}` |
| `playerJoined` | S→C | `{'roomInfo': RoomInfo}` |
| `playerLeft` | S→C | `{'roomInfo': RoomInfo}` |
| `gameUpdate` | S→C | `{'roomInfo': RoomInfo}` |
| `gameOver` | S→C | `{'roomInfo': RoomInfo}` |
| `gameReset` | S→C | `{'roomInfo': RoomInfo}` |
| `error` | S→C | 无 `data`，错误信息在顶层 `error` 字段 |

### HTTP 端点

| 端点 | 方法 | 说明 |
|------|------|------|
| `/` | GET | 服务器首页 |
| `/health` | GET | 健康检查 |
| `/stats` | GET | 服务器统计 |
| `/version` | GET | 获取服务器版本 |
| `/frog` | GET | WebSocket升级 |

## 📦 版本管理与发布

本项目的客户端和服务端版本保持严格一致，通过 Git 标签进行统一管理和自动化发布。

### 版本管理策略

- **版本号格式**：遵循 [语义化版本](https://semver.org/lang/zh-CN/) 规范，例如 `v1.2.3`。
- **Git 标签**：每次发布都需要创建一个以 `v` 开头的 Git 标签，例如 `git tag v1.0.0`。

### 自动化发布流程

当一个 `v*` 格式的标签被推送到 GitHub 仓库时，会自动触发 `GitHub Actions` CI/CD 工作流，执行以下操作：

1.  **注入版本号与配置**：
    -   将 Git 标签（例如 `v1.0.0`）作为版本号，通过 `--dart-define=APP_VERSION=v1.0.0` 注入到 Flutter 客户端。
    -   将生产服务器 URL 通过 `--dart-define=SERVER_URL=...` 注入到 Flutter 客户端。
    -   将版本号通过构建参数注入到服务端的 Docker 镜像中。

2.  **构建和发布服务端**：
    -   构建 Docker 镜像。
    -   镜像标签与 Git 标签保持一致。
    -   推送到指定的容器镜像仓库。

3.  **构建客户端**：
    -   并行构建 Web、Android、iOS、macOS、Windows 和 Linux 的发行版本。
    -   将所有构建产物（如 APK、ZIP 包等）上传到 GitHub Actions 的 Artifacts，方便下载。

### 如何发布新版本

1.  确保所有代码更改已经合并到 `main` 分支。
2.  在本地创建并推送一个新的 Git 标签：
    ```bash
    # 创建一个新标签
    git tag v1.1.0

    # 推送标签到远程仓库，这将触发CI/CD
    git push origin v1.1.0
    ```
3.  等待 GitHub Actions 完成所有构建和发布任务。

## 🛠️ 开发指南

### 代码生成

项目使用了代码生成工具，在修改模型后需要重新生成：

```bash
# 客户端
flutter pub run build_runner build --delete-conflicting-outputs

# 服务器
cd server
dart pub run build_runner build --delete-conflicting-outputs
```

## 🤝 贡献指南

1. Fork 项目
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开 Pull Request

## 📝 许可证

该项目基于 MIT 许可证。