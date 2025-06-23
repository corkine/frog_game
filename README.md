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
│   └── deploy.sh             # 部署脚本
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
flutter run
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
./deploy.sh dev
```

服务器将在 `http://localhost:8080` 启动。

## 🐳 Docker 部署

### 构建镜像

```bash
cd server

# 构建Docker镜像
docker build -t frog-game-server .

# 运行容器
docker run -p 8080:8080 frog-game-server
```

### 使用部署脚本

```bash
cd server

# 给予执行权限
chmod +x deploy.sh

# 构建镜像
./deploy.sh build

# 推送到阿里云容器镜像服务
export NAMESPACE=your-namespace
./deploy.sh push

# 完整部署流程
./deploy.sh all
```

## ☁️ 阿里云函数计算部署

### 准备工作

1. 创建阿里云容器镜像服务仓库
2. 安装 Serverless Devs 工具

```bash
npm install -g @serverless-devs/s
```

### 部署步骤

1. **推送镜像到阿里云**

```bash
# 登录阿里云容器镜像服务
docker login registry.cn-hangzhou.aliyuncs.com

# 设置环境变量
export NAMESPACE=your-namespace

# 构建并推送
cd server
./deploy.sh build
./deploy.sh push
```

2. **更新部署模板**

修改 `server/template.yml` 中的镜像地址：

```yaml
CustomContainerConfig:
  Image: registry.cn-hangzhou.aliyuncs.com/your-namespace/frog-game-server:latest
```

3. **部署到函数计算**

```bash
s deploy
```

## 🔧 配置说明

### 环境变量

| 变量名 | 说明 | 默认值 |
|--------|------|--------|
| `PORT` | 服务器端口 | `8080` |
| `REGISTRY_URL` | 容器镜像仓库地址 | `registry.cn-hangzhou.aliyuncs.com` |
| `NAMESPACE` | 镜像命名空间 | `default` |
| `IMAGE_NAME` | 镜像名称 | `frog-game-server` |
| `IMAGE_TAG` | 镜像标签 | `latest` |

### 客户端配置

在 `lib/services/websocket_service.dart` 中修改服务器地址：

```dart
static const String defaultServerUrl = 'ws://your-server-domain/ws';
```

## 📡 API 文档

### WebSocket 协议

#### 连接
```
WS ws://server-domain/ws
```

#### 消息格式
```json
{
  "type": "MessageType",
  "roomId": "123456",
  "playerId": "player123",
  "data": {...},
  "error": "error message",
  "timestamp": 1640995200000
}
```

#### 消息类型

| 类型 | 方向 | 说明 |
|------|------|------|
| `createRoom` | C→S | 创建房间 |
| `joinRoom` | C→S | 加入房间 |
| `leaveRoom` | C→S | 离开房间 |
| `gameMove` | C→S | 游戏移动 |
| `gameReset` | C→S | 重置游戏 |
| `roomCreated` | S→C | 房间创建成功 |
| `roomJoined` | S→C | 加入房间成功 |
| `playerJoined` | S→C | 玩家加入通知 |
| `playerLeft` | S→C | 玩家离开通知 |
| `gameUpdate` | S→C | 游戏状态更新 |
| `error` | S→C | 错误消息 |

### HTTP 端点

| 端点 | 方法 | 说明 |
|------|------|------|
| `/` | GET | 服务器首页 |
| `/health` | GET | 健康检查 |
| `/stats` | GET | 服务器统计 |
| `/ws` | GET | WebSocket升级 |

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
- 函数计算服务

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
- [阿里云函数计算](https://www.aliyun.com/product/fc)
- [Riverpod 状态管理](https://riverpod.dev/)

## 🎮 游戏规则

井字棋是一个经典的策略游戏：

1. 两名玩家轮流在3×3的网格中放置标记（X和O）
2. 第一个将三个标记连成一线（水平、垂直或对角线）的玩家获胜
3. 如果网格填满且没有玩家获胜，则为平局

---

**享受游戏！** 🎉
