# ClawEase - Windows PowerShell Installer
# "The NT Way to AI"

Write-Host "🕶️ ClawEase Windows Installer: Preparing your Agent..." -ForegroundColor Cyan

# 1. Install Scoop if missing
if (!(Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "🟢 Installing Scoop..." -ForegroundColor Cyan
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    irm get.scoop.sh | iex
    # 核心修复：安装完 Scoop 后立即将路径加入当前会话，避免找不到命令
    $env:PATH += ";$HOME\scoop\shims"
}

# 2. Install Nodejs, Git, pnpm
Write-Host "📦 Installing dependencies via Scoop..." -ForegroundColor Cyan
scoop install nodejs-lts git pnpm
# 再次加固 PATH
$env:PATH += ";$HOME\scoop\apps\nodejs-lts\current\bin;$HOME\scoop\apps\pnpm\current"

# 3. Clone and Setup
$InstallDir = "$HOME\.clawease\openclaw"
if (!(Test-Path "$HOME\.clawease")) { New-Item -ItemType Directory -Path "$HOME\.clawease" }

if (Test-Path $InstallDir) {
    Write-Host "⚠️ Updating code but PRESERVING your config..." -ForegroundColor Yellow
    Set-Location $InstallDir
    git pull
} else {
    Write-Host "🟢 Cloning OpenClaw..."
    git clone https://github.com/openclaw/openclaw.git $InstallDir
    Set-Location $InstallDir
}

# 4. pnpm Install
Write-Host "🚀 Installing brains and 30+ built-in Skills..." -ForegroundColor Cyan
# 核心修复：直接调用 pnpm 的完整路径或确保环境变量生效
& pnpm install

Write-Host "✅ SUCCESS! run 'node dist\index.js onboard' inside $InstallDir to begin." -ForegroundColor Green
