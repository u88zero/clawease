#!/bin/bash

# ClawEase - macOS One-Click Installer
# "The Unix Way to AI"

set -e

echo "🕶️ ClawEase macOS Installer: Preparing your Agent..."

# 1. Check for Homebrew
if ! command -v brew &> /dev/null; then
    echo "🟢 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# 2. Install Node.js 22 & Git
echo "📦 Installing core dependencies..."
brew install node@22 git pnpm

# 3. Clone and Setup
INSTALL_DIR="$HOME/.clawease/openclaw"
mkdir -p "$HOME/.clawease"
if [ -d "$INSTALL_DIR" ]; then
    echo "⚠️  Updating code but PRESERVING your config..."
    cd "$INSTALL_DIR" && git pull
else
    echo "🟢 Cloning OpenClaw..."
    git clone https://github.com/openclaw/openclaw.git "$INSTALL_DIR"
    cd "$INSTALL_DIR"
fi

# 4. pnpm Install
echo "🚀 Installing brains and 30+ built-in Skills..."
pnpm install

echo "✅ SUCCESS! run 'cd $INSTALL_DIR && node dist/index.js onboard' to begin."
