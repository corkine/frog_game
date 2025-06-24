# 使用官方 Dart 运行时作为基础镜像
FROM dart:stable AS build

# 设置工作目录
WORKDIR /app

# 1. 声明构建参数，用于接收来自 CI 的版本号
ARG APP_VERSION=local-dev

# 2. 将收到的构建参数值，设置为容器的运行时环境变量
ENV APP_VERSION=$APP_VERSION

# 复制 pubspec 文件
COPY pubspec.* ./

# 安装依赖
RUN dart pub get

# 复制源代码
COPY . .

# 生成代码（如果需要）
RUN dart pub run build_runner build --delete-conflicting-outputs

# 编译应用
RUN dart compile exe bin/server.dart -o bin/server

# 使用更小的基础镜像运行应用
FROM debian:bullseye-slim

# 再次声明 ARG 和 ENV 以便在运行时访问
ARG APP_VERSION=local-dev
ENV APP_VERSION=$APP_VERSION

# 安装运行时依赖
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl && \
    rm -rf /var/lib/apt/lists/*

# 创建非root用户
RUN useradd -r -s /bin/false appuser

# 设置工作目录
WORKDIR /app

# 从构建阶段复制编译好的二进制文件
COPY --from=build /app/bin/server /app/server

# 更改文件所有者
RUN chown -R appuser:appuser /app

# 切换到非root用户
USER appuser

# 暴露端口
EXPOSE 8080

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1

# 3. 运行服务器。此时，Dart代码可以通过 Platform.environment 读取到 ENV 设置的 APP_VERSION
CMD ["/app/server"] 