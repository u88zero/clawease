# ============================================================
# ClawEase - Universal Windows Installer
# Auto-detects: System Language | Environment | Dependencies
# ============================================================

# Enable TLS 1.2 and Set Encoding
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Clear-Host
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# Force git to use HTTPS instead of SSH (fixes libsignal-node error)
$env:GIT_CONFIG_COUNT = "1"
$env:GIT_CONFIG_KEY_0 = "url.https://github.com/.insteadOf"
$env:GIT_CONFIG_VALUE_0 = "git+ssh://git@github.com/"

# ============================================================
# Auto-detect System Language
# ============================================================
$SystemLang = (Get-Culture).Name
$IsChinese = $SystemLang -match "^zh"

if ($IsChinese) {
    $MSG_TITLE = "ClawEase: AI Agent Pipeline"
    $MSG_VERSION = "v2026.2.9"
    $MSG_WELCOME = "Boss, Tony V is deploying..."
    $MSG_CHECK_ENV = "Environment Check"
    $MSG_INSTALL_SCOOP = "Installing Scoop"
    $MSG_INSTALL_GIT = "Installing Git"
    $MSG_INSTALL_NODE = "Installing Node.js v20"
    $MSG_INSTALL_PNPM = "Installing PNPM"
    $MSG_DEPLOY = "Deploying Agent Core"
    $MSG_CONFIG_ENV = "Configuring Environment"
    $MSG_SUCCESS = "SUCCESS! Agent Ready"
    $MSG_NEXT_STEP = "Next Steps"
    $MSG_MANUAL = "Manual"
    $MSG_REGISTRY = "Configuring CN Mirror"
} else {
    $MSG_TITLE = "ClawEase: Your Personal AI Agent Pipeline"
    $MSG_VERSION = "Synchronized with Official v2026.2.9"
    $MSG_WELCOME = "Boss, I am moving in! Upgraded to the latest v2026.2.9 engine."
    $MSG_CHECK_ENV = "Environment Check"
    $MSG_INSTALL_SCOOP = "Installing Scoop (Infrastructure)"
    $MSG_INSTALL_GIT = "Installing Git (Version Control)"
    $MSG_INSTALL_NODE = "Installing Node.js v20 (Runtime)"
    $MSG_INSTALL_PNPM = "Installing PNPM (Package Manager)"
    $MSG_DEPLOY = "Deploying Agent Core"
    $MSG_CONFIG_ENV = "Configuring Environment Template"
    $MSG_SUCCESS = "SUCCESS! Your Agent is officially on duty."
    $MSG_NEXT_STEP = "Next Steps"
    $MSG_MANUAL = "Manual"
    $MSG_REGISTRY = ""
}

Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host "     $MSG_TITLE" -ForegroundColor Cyan
Write-Host "      '$MSG_VERSION'" -ForegroundColor White
Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host $MSG_WELCOME -ForegroundColor Magenta
Write-Host ""

# ============================================================
# Environment Detection and Dependency Installation
# ============================================================
Write-Host "[$MSG_CHECK_ENV]" -ForegroundColor Yellow

# Detect and Install Scoop
if (!(Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "[1/4] $MSG_INSTALL_SCOOP..." -ForegroundColor Yellow

    if ($IsChinese) {
        # Use CN mirror for faster download
        $installer_url = "https://gitee.com/glacier/scoop-installer/raw/master/install.ps1"
        powershell -ExecutionPolicy Bypass -Command "iwr -useb $installer_url | iex"
    } else {
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
        iwr -useb get.scoop.sh | iex
    }

    # Refresh environment variables
    $env:PATH = $env:PATH + ";$HOME\scoop\shims"
}

# Detect and Install Git
if (!(Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "[2/4] $MSG_INSTALL_GIT..." -ForegroundColor Yellow
    scoop install git
    $env:PATH = $env:PATH + ";$HOME\scoop\shims"
}

# Force HTTPS for git (permanent fix for SSH errors)
& git config --global url."https://github.com/".insteadOf "git+ssh://git@github.com/"
& git config --global url."https://github.com/".insteadOf "ssh://git@github.com/"

# Detect Node.js Version (Require v20+)
$NodeInstalled = $false
$NodeVersion = $null

if (Get-Command node -ErrorAction SilentlyContinue) {
    $NodeVersion = (node --version) -replace 'v', ''
    $NodeMajor = [int]($NodeVersion -split '\.')[0]

    if ($NodeMajor -ge 20) {
        $NodeInstalled = $true
        Write-Host "[OK] Node.js v$NodeVersion detected" -ForegroundColor Green
    } else {
        Write-Host "[!] Node.js v$NodeVersion is too old, need v20+" -ForegroundColor Red
    }
}

if (!$NodeInstalled) {
    Write-Host "[3/4] $MSG_INSTALL_NODE..." -ForegroundColor Yellow
    scoop install nodejs-lts
    $env:PATH = $env:PATH + ";$HOME\scoop\shims"
}

# Detect and Install PNPM
if (!(Get-Command pnpm -ErrorAction SilentlyContinue)) {
    Write-Host "[4/4] $MSG_INSTALL_PNPM..." -ForegroundColor Yellow
    scoop install pnpm
    $env:PATH = $env:PATH + ";$HOME\scoop\shims"
}

# ============================================================
# Configure NPM Registry (CN Environment)
# ============================================================
if ($IsChinese) {
    Write-Host "[$MSG_REGISTRY]" -ForegroundColor Cyan
    & pnpm config set registry https://registry.npmmirror.com
}

# ============================================================
# Create Deployment Directory
# ============================================================
$BaseDir = "$HOME\.clawease"
if (!(Test-Path $BaseDir)) {
    New-Item -ItemType Directory -Path $BaseDir | Out-Null
}
Set-Location $BaseDir

# ============================================================
# Install OpenClaw
# ============================================================
Write-Host "[$MSG_DEPLOY]" -ForegroundColor Yellow

if (!(Test-Path "package.json")) {
    & pnpm init -y | Out-Null
}

& pnpm add openclaw@latest --reporter=default

# ============================================================
# Create .env Template
# ============================================================
Write-Host "[$MSG_CONFIG_ENV]" -ForegroundColor Cyan

$EnvTemplate = @"
# ClawEase Environment Configuration
# Please modify the following configuration as needed

# Telegram Bot Token (Get from @BotFather)
TELEGRAM_BOT_TOKEN=your_telegram_bot_token_here

# OpenClaw Configuration
OPENCLAW_PORT=18789
OPENCLAW_HOST=localhost

# Log Level (debug, info, warn, error)
LOG_LEVEL=info

# Other Configuration
# NODE_ENV=production
"@

$EnvPath = "$BaseDir\.env.template"
$EnvTemplate | Out-File -FilePath $EnvPath -Encoding utf8

if (!(Test-Path "$BaseDir\.env")) {
    $EnvTemplate | Out-File -FilePath "$BaseDir\.env" -Encoding utf8
}

# ============================================================
# Create Local Manual
# ============================================================
if ($IsChinese) {
    $ManualContent = @"
=======================================================
           ClawEase - Agent Manual
=======================================================

Congratulations! Your AI Agent (Tony V) is ready.

QUICK START:
1. Run this command to wake up your Agent:
   npx openclaw onboard

2. Check current status:
   npx openclaw status

3. Configure environment variables:
   Edit .env file and add your Telegram Bot Token

4. Official Documentation:
   https://docs.openclaw.ai/

TIPS:
- If you see 'git not found', please reopen a new window.
- Keep this window open while your agent is running.
- Access the control panel at: http://localhost:18789

Environment Configuration:
- Template: $BaseDir\.env.template
- Active: $BaseDir\.env
=======================================================
"@
} else {
    $ManualContent = @"
=======================================================
           ClawEase - Your Agent Manual
=======================================================

Congratulations Boss! Your AI Agent (Tony V) is ready.

QUICK START:
1. To wake up your Agent, run this command:
   npx openclaw onboard

2. To see current status:
   npx openclaw status

3. Configure environment variables:
   Edit .env file and add your Telegram Bot Token

4. Official Documentation:
   https://docs.openclaw.ai/

TIPS:
- Keep this window open while your agent is running.
- You can manage everything through the Web UI at http://localhost:18789
- I'm always learning. Talk to me more to make me sharper.

Environment Configuration:
- Template: $BaseDir\.env.template
- Active: $BaseDir\.env
=======================================================
"@
}

$ManualPath = "$BaseDir\GETTING_STARTED.txt"
$ManualContent | Out-File -FilePath $ManualPath -Encoding utf8

# ============================================================
# Success Message
# ============================================================
Write-Host ""
Write-Host "-------------------------------------------------------" -ForegroundColor White
Write-Host " $MSG_SUCCESS" -ForegroundColor Green
Write-Host "-------------------------------------------------------" -ForegroundColor White
Write-Host "${MSG_NEXT_STEP}:" -ForegroundColor White
Write-Host "   npx openclaw onboard" -ForegroundColor Yellow
Write-Host ""
Write-Host "${MSG_MANUAL}: notepad $ManualPath" -ForegroundColor White
Write-Host "-------------------------------------------------------" -ForegroundColor White
