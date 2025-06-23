#!/bin/bash

echo "🐸 青蛙跳井游戏服务器启动脚本"
echo "================================"

# 检查 Dart 是否安装
if ! command -v dart &> /dev/null; then
    echo "❌ 错误: 未找到 Dart SDK，请先安装 Dart"
    exit 1
fi

# 进入服务器目录
cd server

# 检查依赖
echo "📦 检查依赖..."
if [ ! -f "pubspec.lock" ]; then
    echo "📥 首次运行，正在安装依赖..."
    dart pub get
fi

# 启动服务器
echo "🚀 启动游戏服务器..."
echo ""
echo "服务器地址："
echo "  主页: http://localhost:8080"
echo "  WebSocket: ws://localhost:8080/ws"
echo "  状态页面: http://localhost:8080/stats"
echo ""
echo "按 Ctrl+C 停止服务器"
echo "================================"
echo ""

dart run bin/server.dart 