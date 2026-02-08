# ClawEase - Windows PowerShell Installer
# "The NT Way to AI"

# 解决终端乱码问题，确保 Emoji 和中文正常显示
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "🕶️ ClawEase Windows Installer: Preparing your Agent..." -ForegroundColor Cyan

# 1. Install Scoop if missing
if (!(Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "🟢 Installing Scoop..." -ForegroundColor Cyan
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    irm get.scoop.sh | iex
}

# 核心修复：无论是否新装，都强制刷新当前会话的环境变量
$env:PATH += ";$HOME\scoop\shims;$HOME\scoop\apps\nodejs-lts\current\bin;$HOME\scoop\apps\pnpm\current"

# 2. Install Nodejs, Git, pnpm
Write-Host "📦 Checking/Installing dependencies..." -ForegroundColor Cyan
scoop install nodejs-lts git pnpm 2>$null # 忽略已安装的错误

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

# 4. pnpm Install & Build
Write-Host "🚀 Installing brains and building Agent cores..." -ForegroundColor Cyan
& pnpm install
# 核心修复：确保源码被编译
& pnpm run build

Write-Host "-------------------------------------------------------" -ForegroundColor White
Write-Host "✅ SUCCESS! OpenClaw is ready to wake up." -ForegroundColor Green
Write-Host "-------------------------------------------------------" -ForegroundColor White
Write-Host "🕶️  Next Steps:" -ForegroundColor White
Write-Host "1. Run: cd $InstallDir" -ForegroundColor White
Write-Host "2. Run: node dist/index.js onboard" -ForegroundColor White
Write-Host "-------------------------------------------------------" -ForegroundColor White
