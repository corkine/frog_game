/// 应用程序配置类
class AppConfig {
  /// 开发环境配置
  static const String devServerUrl = 'wss://frogme.mazhangjing.com/ws';

  /// 生产环境配置 - 替换为您的实际服务器地址
  static const String prodServerUrl = 'wss://frogme.mazhangjing.com/ws';

  /// 当前环境
  static const bool isDebug = bool.fromEnvironment('dart.vm.product') == false;

  /// 获取当前环境的服务器URL
  static String get serverUrl {
    // 优先使用环境变量配置
    const String envServerUrl = String.fromEnvironment('SERVER_URL');
    if (envServerUrl.isNotEmpty) {
      return envServerUrl;
    }

    // 其次根据调试模式选择
    if (isDebug) {
      return devServerUrl;
    } else {
      return prodServerUrl;
    }
  }

  /// 游戏配置
  static const int maxPlayersPerRoom = 2;
  static const int connectionTimeoutSeconds = 10;
  static const int heartbeatIntervalSeconds = 30;

  /// UI配置
  static const String appName = '青蛙跳井';
  static const String appVersion = '1.0.0';
}
