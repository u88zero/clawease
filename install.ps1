# ClawEase - Windows PowerShell Installer
# "The NT Way to AI"

# 强制设置 UTF-8 编码，尝试解决乱码，如果还是不行，我们将移除所有特殊字符
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "--- ClawEase Windows Installer ---" -ForegroundColor Cyan
Write-Host "Preparing your Agent..." -ForegroundColor Cyan

# 1. Install Scoop if missing
if (!(Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "[1/4] Installing Scoop..." -ForegroundColor Cyan
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    irm get.scoop.sh | iex
}

# 强制刷新当前会话的环境变量
$env:PATH += ";$HOME\scoop\shims;$HOME\scoop\apps\nodejs-lts\current\bin;$HOME\scoop\apps\pnpm\current"

# 2. Install Nodejs, Git, pnpm
Write-Host "[2/4] Checking dependencies..." -ForegroundColor Cyan
scoop install nodejs-lts git pnpm 2>$null

# 3. Clone and Setup
$InstallDir = "$HOME\.clawease\openclaw"
if (!(Test-Path "$HOME\.clawease")) { New-Item -ItemType Directory -Path "$HOME\.clawease" }

if (Test-Path $InstallDir) {
    Write-Host "[3/4] Updating code (preserving config)..." -ForegroundColor Yellow
    Set-Location $InstallDir
    git pull
} else {
    Write-Host "[3/4] Cloning OpenClaw..." -ForegroundColor Cyan
    git clone https://github.com/openclaw/openclaw.git $InstallDir
    Set-Location $InstallDir
}

# 4. pnpm Install & Build
Write-Host "[4/4] Installing and building Agent cores..." -ForegroundColor Cyan
& pnpm install

# 核心修复：针对 Windows 编译环境的特殊处理
Write-Host "Compiling source code... (This might take a moment)" -ForegroundColor Cyan
& pnpm run build

if (Test-Path "dist\index.js") {
    Write-Host "-------------------------------------------------------" -ForegroundColor White
    Write-Host "SUCCESS! OpenClaw is ready to wake up." -ForegroundColor Green
    Write-Host "-------------------------------------------------------" -ForegroundColor White
    Write-Host "Next Steps:" -ForegroundColor White
    Write-Host "1. Run: cd $InstallDir" -ForegroundColor White
    Write-Host "2. Run: node dist/index.js onboard" -ForegroundColor White
    Write-Host "-------------------------------------------------------" -ForegroundColor White
} else {
    Write-Host "-------------------------------------------------------" -ForegroundColor Red
    Write-Host "ERROR: Build failed. dist\index.js not found." -ForegroundColor Red
    Write-Host "Please try running this command manually inside $InstallDir :" -ForegroundColor White
    Write-Host "pnpm run build" -ForegroundColor Yellow
    Write-Host "-------------------------------------------------------" -ForegroundColor Red
}
