# ============================================================
# ClawEase - Windows PowerShell Installer (CN Optimized)
# "Force Install & Dependency Guard Edition" v2
# ============================================================

# Force UTF-8 + TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$env:LANG = "zh_CN.UTF-8"

# Force git to use HTTPS instead of SSH (fixes libsignal-node error)
$env:GIT_CONFIG_COUNT = "1"
$env:GIT_CONFIG_KEY_0 = "url.https://github.com/.insteadOf"
$env:GIT_CONFIG_VALUE_0 = "git+ssh://git@github.com/"

Clear-Host

Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host "     ClawEase: AI Agent Pipeline (CN Edition)          " -ForegroundColor Cyan
Write-Host "     v2026.2.1 - Fixed Scoop installer                " -ForegroundColor White
Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "[INFO] Deploying your personal AI Agent..." -ForegroundColor Magenta
Write-Host ""

# ============================================================
# Scoop (with fallback sources)
# ============================================================
if (!(Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "[1/4] Installing Scoop (package manager)..." -ForegroundColor Yellow

    $scoop_installed = $false

    # Try 1: Official Scoop installer
    try {
        Write-Host "  -> Trying official installer..." -ForegroundColor Gray
        Invoke-RestMethod -Uri "https://get.scoop.sh" | Invoke-Expression
        $env:PATH += ";$HOME\scoop\shims"
        if (Get-Command scoop -ErrorAction SilentlyContinue) {
            $scoop_installed = $true
            Write-Host "  [OK] Scoop installed via official source" -ForegroundColor Green
        }
    } catch {
        Write-Host "  [!] Official source failed, trying mirror..." -ForegroundColor Yellow
    }

    # Try 2: Gitee mirror (backup)
    if (!$scoop_installed) {
        try {
            Write-Host "  -> Trying Gitee mirror..." -ForegroundColor Gray
            $installer_url = "https://gitee.com/glsnames/scoop-installer/raw/master/bin/install.ps1"
            powershell -ExecutionPolicy Bypass -Command "iwr -useb $installer_url | iex"
            $env:PATH += ";$HOME\scoop\shims"
            if (Get-Command scoop -ErrorAction SilentlyContinue) {
                $scoop_installed = $true
                Write-Host "  [OK] Scoop installed via Gitee mirror" -ForegroundColor Green
            }
        } catch {
            Write-Host "  [!] Gitee mirror also failed" -ForegroundColor Red
        }
    }

    if (!$scoop_installed) {
        Write-Host ""
        Write-Host "=======================================================" -ForegroundColor Red
        Write-Host " ERROR: Scoop installation failed!" -ForegroundColor Red
        Write-Host " Please install Scoop manually:" -ForegroundColor Yellow
        Write-Host '   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser' -ForegroundColor White
        Write-Host '   Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression' -ForegroundColor White
        Write-Host " Then re-run this installer." -ForegroundColor Yellow
        Write-Host "=======================================================" -ForegroundColor Red
        Read-Host "Press Enter to exit"
        exit 1
    }
} else {
    Write-Host "[OK] Scoop detected" -ForegroundColor Green
}

# ============================================================
# Git
# ============================================================
if (!(Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "[2/4] Installing Git..." -ForegroundColor Yellow
    scoop install git
    $env:PATH += ";$HOME\scoop\shims"
    if (!(Get-Command git -ErrorAction SilentlyContinue)) {
        Write-Host "[!] Git installation failed. Please install Git manually: https://git-scm.com/" -ForegroundColor Red
        Read-Host "Press Enter to exit"
        exit 1
    }
} else {
    Write-Host "[OK] Git detected" -ForegroundColor Green
}

# Force HTTPS globally for git (permanent fix for SSH errors)
& git config --global url."https://github.com/".insteadOf "git+ssh://git@github.com/"
& git config --global url."https://github.com/".insteadOf "ssh://git@github.com/"

# ============================================================
# Node.js
# ============================================================
$NodeInstalled = $false
if (Get-Command node -ErrorAction SilentlyContinue) {
    $NodeVersion = (node --version) -replace 'v', ''
    $NodeMajor = [int]($NodeVersion -split '\.')[0]
    if ($NodeMajor -ge 20) {
        $NodeInstalled = $true
        Write-Host "[OK] Node.js v$NodeVersion detected" -ForegroundColor Green
    } else {
        Write-Host "[!] Node.js v$NodeVersion too old, need v20+" -ForegroundColor Red
    }
}

if (!$NodeInstalled) {
    Write-Host "[3/4] Installing Node.js LTS..." -ForegroundColor Yellow
    scoop install nodejs-lts
    $env:PATH += ";$HOME\scoop\shims"
}

# ============================================================
# PNPM
# ============================================================
if (!(Get-Command pnpm -ErrorAction SilentlyContinue)) {
    Write-Host "[4/4] Installing PNPM..." -ForegroundColor Yellow
    scoop install pnpm
    $env:PATH += ";$HOME\scoop\shims"
} else {
    Write-Host "[OK] PNPM detected" -ForegroundColor Green
}

# ============================================================
# CN Mirror
# ============================================================
Write-Host "[CONFIG] Setting China mirror (npmmirror.com)..." -ForegroundColor Cyan
& pnpm config set registry https://registry.npmmirror.com

# ============================================================
# Deploy
# ============================================================
$BaseDir = "$HOME\.clawease"
if (!(Test-Path $BaseDir)) { New-Item -ItemType Directory -Path $BaseDir | Out-Null }
Set-Location $BaseDir

Write-Host "[DEPLOY] Installing OpenClaw latest..." -ForegroundColor Yellow
if (!(Test-Path "package.json")) {
    & pnpm init | Out-Null
}

$env:PATH += ";$HOME\scoop\shims"
& pnpm add openclaw@latest --reporter=default

# ============================================================
# Manual
# ============================================================
$ManualPath = "$BaseDir\GETTING_STARTED.txt"
$ManualContent = @"
=======================================================
           ClawEase - Agent Manual
=======================================================

Your AI Agent is ready.

Quick Start:
1. Wake up your Agent:
   npx openclaw onboard

2. Check status:
   npx openclaw status

3. Official docs:
   https://docs.openclaw.ai/

Tips:
- If 'git not found', reopen a new terminal window.
- Keep this window open while agent is running.
- Web console: http://localhost:18789

Config:
- Template: $BaseDir\.env.template
- Active:   $BaseDir\.env
=======================================================
"@
$ManualContent | Out-File -FilePath $ManualPath -Encoding utf8

# ============================================================
# .env Template
# ============================================================
$EnvTemplate = @"
# ClawEase Environment Configuration
TELEGRAM_BOT_TOKEN=your_telegram_bot_token_here
OPENCLAW_PORT=18789
OPENCLAW_HOST=localhost
LOG_LEVEL=info
"@

$EnvPath = "$BaseDir\.env.template"
$EnvTemplate | Out-File -FilePath $EnvPath -Encoding utf8
if (!(Test-Path "$BaseDir\.env")) {
    $EnvTemplate | Out-File -FilePath "$BaseDir\.env" -Encoding utf8
}

# ============================================================
# Done
# ============================================================
Write-Host ""
Write-Host "-------------------------------------------------------" -ForegroundColor White
Write-Host " SUCCESS! Agent is ready." -ForegroundColor Green
Write-Host "-------------------------------------------------------" -ForegroundColor White
Write-Host "Next step (reopen terminal first):" -ForegroundColor White
Write-Host "   npx openclaw onboard" -ForegroundColor Yellow
Write-Host ""
Write-Host "Manual: notepad $ManualPath" -ForegroundColor White
Write-Host "Dashboard: https://u88zero.github.io/clawease-pro/dashboard/" -ForegroundColor Cyan
Write-Host "-------------------------------------------------------" -ForegroundColor White
