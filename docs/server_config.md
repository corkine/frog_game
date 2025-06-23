# 服务器配置说明

## 配置后端服务器地址

Flutter 应用支持多种方式配置后端服务器地址：

### 1. 默认配置

应用会根据运行环境自动选择服务器地址：

- **开发环境** (Debug模式): `ws://localhost:8080/ws`
- **生产环境** (Release模式): `wss://your-server-domain.com/ws`

### 2. 环境变量配置

您可以通过环境变量 `SERVER_URL` 来覆盖默认配置：

```bash
# 编译时指定服务器地址
flutter build apk --dart-define=SERVER_URL=wss://your-server.com/ws

# 运行时指定服务器地址
flutter run --dart-define=SERVER_URL=ws://192.168.1.100:8080/ws
```

### 3. 修改配置文件

编辑 `lib/config/app_config.dart` 文件：

```dart
class AppConfig {
  /// 开发环境配置
  static const String devServerUrl = 'ws://localhost:8080/ws';
  
  /// 生产环境配置 - 替换为您的实际服务器地址
  static const String prodServerUrl = 'wss://your-server-domain.com/ws';
}
```

## 服务器部署

### 本地开发

1. 启动后端服务器：
```bash
cd server
dart run bin/server.dart
```

2. 服务器将在 `http://localhost:8080` 启动
3. WebSocket 端点为 `ws://localhost:8080/ws`

### 生产部署

1. 修改 `prodServerUrl` 为您的实际服务器地址
2. 确保使用 HTTPS/WSS 协议以支持安全连接
3. 配置防火墙开放相应端口

## 网络协议

- **开发环境**: 使用 `ws://` 协议
- **生产环境**: 建议使用 `wss://` 协议（加密连接）

## 故障排除

### 连接失败

1. 检查服务器是否正在运行
2. 验证网络连接
3. 确认防火墙设置
4. 检查服务器地址配置是否正确

### 常见错误

- `Connection refused`: 服务器未启动或地址错误
- `WebSocket connection failed`: 网络问题或协议不匹配
- `Timeout`: 服务器响应超时

### 调试模式

在调试模式下，应用会输出详细的连接日志，帮助诊断问题。 