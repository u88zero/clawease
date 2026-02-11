#!/bin/bash

# ClawEase - OpenClaw Linux Installer (CN Optimized Edition)
# "Domestic Speed, Global Intelligence"

set -e

echo "🕶️ ClawEase Installer (CN): 正在准备你的个人 AI 智能体..."

# 1. 环境检查
if [ "$EUID" -ne 0 ]; then 
  echo "❌ 请使用 root 权限运行 (sudo)"
  exit 1
fi

# 2. 更新并安装依赖 (使用国内源)
echo "📦 正在更新系统包并配置镜像源..."
# 针对 Debian/Ubuntu 的简单镜像优化 (可选，不强制修改用户原有配置)
# sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list

apt-get update -y && apt-get install -y curl git build-essential python3

# 3. 安装 Node.js (使用 NodeSource 镜像)
if ! command -v node &> /dev/null; then
    echo "🟢 正在安装 Node.js 22 (高速通道)..."
    curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
    apt-get install -y nodejs
fi

# 4. 安装 pnpm 并配置镜像
if ! command -v pnpm &> /dev/null; then
    echo "🟢 正在安装 pnpm..."
    npm install -g pnpm --registry=https://registry.npmmirror.com
fi

# 配置 pnpm 使用国内镜像
pnpm config set registry https://registry.npmmirror.com

# 5. 克隆 OpenClaw (使用 GitHub 镜像或直连)
INSTALL_DIR="/opt/openclaw"
if [ -d "$INSTALL_DIR" ]; then
    echo "⚠️ 检测到现有安装，正在同步代码..."
    cd "$INSTALL_DIR" && git pull
else
    echo "🟢 正在从 GitHub 克隆核心代码..."
    # 尝试使用加速镜像，如果失败则回退直连
    git clone https://mirror.ghproxy.com/https://github.com/openclaw/openclaw.git "$INSTALL_DIR" || git clone https://github.com/openclaw/openclaw.git "$INSTALL_DIR"
    cd "$INSTALL_DIR"
fi

# 6. 安装依赖 (使用国内镜像)
echo "🚀 正在下载核心组件 (v2026.2.9 最新版逻辑)..."
pnpm install

# 7. 完成
echo "-------------------------------------------------------"
echo "✅ 大功告成！OpenClaw 已在你的机器上部署完成。"
echo "-------------------------------------------------------"
echo "🕶️ 下一步操作："
echo "1. 执行 'openclaw onboard' 开始初始化。"
echo "2. 前往 @BotFather 获取你的 Telegram Token。"
echo "3. 欢迎来到智能体时代。"
echo "-------------------------------------------------------"
echo "Brought to you by ClawEase (vlyxo matrix) 🕶️"
