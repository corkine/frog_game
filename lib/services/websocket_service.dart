import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/network_message.dart';

/// 全局唯一的WebSocket服务Provider
final webSocketServiceProvider = Provider<WebSocketService>((ref) {
  return WebSocketService();
});

class WebSocketService {
  WebSocketChannel? _channel;
  Stream<dynamic>? _broadcastStream;

  /// 连接到WebSocket服务器并返回消息流
  ///
  /// [serverUrl] 要连接的服务器地址
  /// [onDone] 连接关闭时的回调
  /// [onError] 发生错误时的回调
  Stream<dynamic>? connect(
    String serverUrl, {
    void Function()? onDone,
    void Function(Object, StackTrace)? onError,
  }) {
    if (_channel != null) {
      disconnect();
    }
    try {
      if (kDebugMode) {
        print('尝试连接到: $serverUrl');
      }
      _channel = WebSocketChannel.connect(Uri.parse(serverUrl));
      
      // 我们需要一个可以被多次监听的流
      _broadcastStream = _channel!.stream.asBroadcastStream(
        onCancel: (subscription) {
          if (kDebugMode) print('WebSocket stream listener canceled.');
        },
        onListen: (subscription) {
          if (kDebugMode) print('WebSocket stream listener added.');
        },
      );

      _broadcastStream!.listen(
        null, // 数据由外部监听者处理
        onDone: () {
          if (kDebugMode) print('WebSocket 连接关闭');
          onDone?.call();
          _reset();
        },
        onError: (error, stackTrace) {
          if (kDebugMode) print('WebSocket 错误: $error');
          onError?.call(error, stackTrace);
          _reset();
        },
      );
      
      return _broadcastStream;
    } catch (e) {
      if (kDebugMode) {
        print('WebSocket 连接失败: $e');
      }
      _reset();
      return null;
    }
  }

  /// 断开连接
  void disconnect() {
    if (kDebugMode) {
      print('主动断开WebSocket连接');
    }
    _channel?.sink.close();
    _reset();
  }

  /// 发送消息
  void sendMessage(NetworkMessage message) {
    if (_channel != null) {
      final jsonData = jsonEncode(message.toJson());
      if (kDebugMode) {
        print('发送消息: $jsonData');
      }
      _channel!.sink.add(jsonData);
    } else {
      if (kDebugMode) {
        print('无法发送消息：WebSocket未连接');
      }
    }
  }

  /// 重置内部状态
  void _reset() {
    _channel = null;
    _broadcastStream = null;
  }
}
