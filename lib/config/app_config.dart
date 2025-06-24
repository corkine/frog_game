/// 应用程序配置类
class AppConfig {
  /// 服务器URL。
  // ignore: unintended_html_in_doc_comment
  /// 该值通过 --dart-define=SERVER_URL=<your_url> 在编译时注入。
  /// Flutter run/build 时若未提供，则默认为本地开发服务器。
  static const String serverUrl = String.fromEnvironment(
    'SERVER_URL',
    defaultValue: 'ws://localhost:8080/frog',
  );

  /// 当前环境
  static const bool isDebug = bool.fromEnvironment('dart.vm.product') == false;

  /// 游戏配置
  static const int maxPlayersPerRoom = 2;
  static const int connectionTimeoutSeconds = 10;
  static const int heartbeatIntervalSeconds = 30;

  /// UI配置
  static const String appName = '青蛙跳井';
  static const String appVersion =
      "${String.fromEnvironment('APP_VERSION', defaultValue: 'local-dev')} · 由 AI 驱动开发";
  static const double pageMaxWidth = 600;
}
