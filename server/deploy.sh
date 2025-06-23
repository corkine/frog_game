#!/bin/bash

# 青蛙跳井游戏服务器部署脚本
# 支持本地开发、Docker构建和阿里云FC部署

set -e

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 显示帮助信息
show_help() {
    echo "青蛙跳井游戏服务器部署脚本"
    echo ""
    echo "用法: $0 [命令] [选项]"
    echo ""
    echo "命令:"
    echo "  dev       - 本地开发模式运行"
    echo "  build     - 构建 Docker 镜像"
    echo "  deploy    - 部署到阿里云 FC"
    echo "  push      - 推送镜像到阿里云容器镜像服务"
    echo "  all       - 执行完整的构建和部署流程"
    echo ""
    echo "选项:"
    echo "  -h, --help     - 显示此帮助信息"
    echo "  -v, --version  - 显示版本信息"
    echo ""
    echo "环境变量:"
    echo "  REGISTRY_URL   - 容器镜像仓库地址 (默认: registry.cn-hangzhou.aliyuncs.com)"
    echo "  NAMESPACE      - 镜像命名空间 (必需)"
    echo "  IMAGE_NAME     - 镜像名称 (默认: frog-game-server)"
    echo "  IMAGE_TAG      - 镜像标签 (默认: latest)"
    echo ""
}

# 检查必需的工具
check_requirements() {
    local missing_tools=()
    
    if ! command -v dart &> /dev/null; then
        missing_tools+=("dart")
    fi
    
    if ! command -v docker &> /dev/null; then
        missing_tools+=("docker")
    fi
    
    if [ ${#missing_tools[@]} -ne 0 ]; then
        log_error "缺少必需的工具: ${missing_tools[*]}"
        log_info "请安装缺少的工具后重试"
        exit 1
    fi
}

# 设置环境变量
setup_env() {
    export REGISTRY_URL=${REGISTRY_URL:-"registry.cn-hangzhou.aliyuncs.com"}
    export IMAGE_NAME=${IMAGE_NAME:-"frog-game-server"}
    export IMAGE_TAG=${IMAGE_TAG:-"latest"}
    
    if [ -z "$NAMESPACE" ]; then
        log_warning "未设置 NAMESPACE 环境变量，使用默认值 'default'"
        export NAMESPACE="default"
    fi
    
    export FULL_IMAGE_NAME="${REGISTRY_URL}/${NAMESPACE}/${IMAGE_NAME}:${IMAGE_TAG}"
    
    log_info "镜像信息: ${FULL_IMAGE_NAME}"
}

# 本地开发模式
run_dev() {
    log_info "启动本地开发服务器..."
    
    # 生成代码
    log_info "生成 Dart 代码..."
    dart pub get
    dart pub run build_runner build --delete-conflicting-outputs
    
    # 启动服务器
    log_info "启动服务器..."
    dart run bin/server.dart
}

# 构建 Docker 镜像
build_docker() {
    log_info "构建 Docker 镜像: ${FULL_IMAGE_NAME}"
    
    # 检查 Dockerfile 是否存在
    if [ ! -f "Dockerfile" ]; then
        log_error "Dockerfile 不存在"
        exit 1
    fi
    
    # 构建镜像
    docker build -t "${FULL_IMAGE_NAME}" .
    
    log_success "Docker 镜像构建完成"
}

# 推送镜像到阿里云容器镜像服务
push_image() {
    log_info "推送镜像到阿里云容器镜像服务..."
    
    # 检查是否已登录 Docker
    if ! docker info &> /dev/null; then
        log_error "Docker 守护进程未运行或未登录"
        exit 1
    fi
    
    # 推送镜像
    docker push "${FULL_IMAGE_NAME}"
    
    log_success "镜像推送完成"
}

# 部署到阿里云 FC
deploy_fc() {
    log_info "部署到阿里云函数计算..."
    
    # 检查是否安装了 Funcraft
    if ! command -v fun &> /dev/null; then
        log_warning "未找到 Funcraft，请使用 Serverless Devs 或手动部署"
        log_info "Serverless Devs 安装: npm install -g @serverless-devs/s"
        return 1
    fi
    
    # 检查模板文件
    if [ ! -f "template.yml" ]; then
        log_error "template.yml 不存在"
        exit 1
    fi
    
    # 部署
    fun deploy
    
    log_success "部署完成"
}

# 完整流程
run_all() {
    log_info "执行完整的构建和部署流程..."
    
    build_docker
    push_image
    deploy_fc
    
    log_success "所有步骤完成！"
}

# 主函数
main() {
    case "${1:-}" in
        "dev")
            check_requirements
            run_dev
            ;;
        "build")
            check_requirements
            setup_env
            build_docker
            ;;
        "push")
            check_requirements
            setup_env
            push_image
            ;;
        "deploy")
            deploy_fc
            ;;
        "all")
            check_requirements
            setup_env
            run_all
            ;;
        "-h"|"--help")
            show_help
            ;;
        "-v"|"--version")
            echo "版本 1.0.0"
            ;;
        "")
            log_error "请指定命令"
            show_help
            exit 1
            ;;
        *)
            log_error "未知命令: $1"
            show_help
            exit 1
            ;;
    esac
}

# 执行主函数
main "$@" 