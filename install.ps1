# ClawEase - Windows PowerShell Installer
# "The NT Way to AI"

Write-Host "🕶️ ClawEase Windows Installer: Preparing your Agent..." -ForegroundColor Cyan

# 1. Install Scoop if missing
if (!(Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "🟢 Installing Scoop..."
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    irm get.scoop.sh | iex
}

# 2. Install Nodejs, Git, pnpm
Write-Host "📦 Installing dependencies via Scoop..."
scoop install nodejs-lts git pnpm

# 3. Clone and Setup
$InstallDir = "$HOME\.clawease\openclaw"
if (!(Test-Path "$HOME\.clawease")) { New-Item -ItemType Directory -Path "$HOME\.clawease" }

if (Test-Path $InstallDir) {
    Write-Host "⚠️ Updating existing installation..."
    Set-Location $InstallDir
    git pull
} else {
    Write-Host "🟢 Cloning OpenClaw..."
    git clone https://github.com/openclaw/openclaw.git $InstallDir
    Set-Location $InstallDir
}

# 4. pnpm Install
Write-Host "🚀 Installing brains..."
pnpm install

Write-Host "✅ SUCCESS! run 'node dist\index.js onboard' inside $InstallDir to begin." -ForegroundColor Green
