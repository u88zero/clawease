#!/bin/bash

# ClawEase - OpenClaw One-Click Installer
# "From Zero to Tony V in 60 seconds"

set -e

echo "🕶️  ClawEase Installer: Preparing your personal AI Agent..."

# 1. Environment Check
if [ "$EUID" -ne 0 ]; then 
  echo "❌ Please run as root (use sudo)"
  exit 1
fi

# 2. Update and Install Dependencies
echo "📦 Updating system packages..."
apt-get update -y && apt-get install -y curl git build-essential python3

# 3. Install Node.js (Version 22 recommended)
if ! command -v node &> /dev/null; then
    echo "🟢 Installing Node.js 22..."
    curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
    apt-get install -y nodejs
fi

# 4. Install pnpm
if ! command -v pnpm &> /dev/null; then
    echo "🟢 Installing pnpm..."
    npm install -g pnpm
fi

# 5. Clone OpenClaw
INSTALL_DIR="/opt/openclaw"
if [ -d "$INSTALL_DIR" ]; then
    echo "⚠️  Existing installation found at $INSTALL_DIR. Updating code but PRESERVING your config..."
    cd "$INSTALL_DIR" && git pull
else
    echo "🟢 Cloning OpenClaw repository..."
    git clone https://github.com/openclaw/openclaw.git "$INSTALL_DIR"
    cd "$INSTALL_DIR"
fi

# 6. Install OpenClaw dependencies and Bundled Skills
echo "🚀 Installing Agent brains and pre-loading 30+ Skills..."
pnpm install

# 7. Final Polish
echo "-------------------------------------------------------"
echo "✅ SUCCESS! OpenClaw is now installed on your machine."
echo "-------------------------------------------------------"
echo "🕶️  Next Steps:"
echo "1. Run 'openclaw onboard' to wake up your agent."
echo "2. Set up your Telegram token with @BotFather."
echo "3. Welcome to the Agentic Era."
echo "-------------------------------------------------------"
echo "Brought to you by ClawEase (vlyxo matrix) 🕶️"
