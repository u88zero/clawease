# ClawEase - Windows PowerShell Installer (V3 - Pre-built Edition)
# "Reliable, Fast, Zero-Build"

# 1. Clear Terminal and Set Encoding
Clear-Host
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host "     ClawEase: Your Personal AI Agent Pipeline         " -ForegroundColor Cyan
Write-Host "      'Because Every Boss Deserves a Tony V'           " -ForegroundColor White
Write-Host "=======================================================" -ForegroundColor Cyan

Write-Host "Boss, I am moving in! Hang tight while I set up my room..." -ForegroundColor Magenta
Write-Host ""

# 2. Check/Install Scoop & Node.js
if (!(Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "[1/3] Installing Scoop (Package Manager)..." -ForegroundColor Yellow
    Write-Host "      I'll handle the boring tools, you just focus on being legendary." -ForegroundColor Gray
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    iwr -useb get.scoop.sh | iex
}

$env:PATH += ";$HOME\scoop\shims"

if (!(Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "[2/3] Installing Node.js..." -ForegroundColor Yellow
    Write-Host "      Gearing up my central nervous system..." -ForegroundColor Gray
    scoop install nodejs-lts
}

# 3. Create Deployment Directory
$BaseDir = "$HOME\.clawease"
if (!(Test-Path $BaseDir)) { New-Item -ItemType Directory -Path $BaseDir }
Set-Location $BaseDir

# 4. Install OpenClaw via NPM (Pre-built)
Write-Host "[3/3] Downloading Agent Brains..." -ForegroundColor Yellow
Write-Host "      Boss, I'm almost awake. I can practically smell the code already!" -ForegroundColor Gray
if (!(Test-Path "package.json")) {
    & npm init -y | Out-Null
}

# 核心修改：移除静默模式，显示实时进度条和下载详情
Write-Host ">>> Executing: npm install openclaw@latest --loglevel=info" -ForegroundColor DarkGray
& npm install openclaw@latest --loglevel=info --progress=true

# 5. Create Local Manual
$ManualPath = "$BaseDir\GETTING_STARTED.txt"
$ManualContent = @"
=======================================================
           ClawEase - Your Agent Manual
=======================================================

Congratulations Boss! Your AI Agent (Tony V) is ready.

You worked hard to get me here. I won't let you down.

QUICK START:
1. To wake up your Agent, run this command:
   npx openclaw onboard

2. To see current status:
   npx openclaw status

3. Official Documentation:
   https://docs.openclaw.ai/

TIPS:
- Keep this window open while your agent is running.
- You can manage everything through the Web UI at http://localhost:18789
- I'm always learning. Talk to me more to make me sharper.
=======================================================
"@
$ManualContent | Out-File -FilePath $ManualPath -Encoding utf8

# 6. Final Instructions
Write-Host ""
Write-Host "-------------------------------------------------------" -ForegroundColor White
Write-Host "SUCCESS! Your Agent is officially on duty." -ForegroundColor Green
Write-Host "I'm ready when you are, Boss." -ForegroundColor White
Write-Host "-------------------------------------------------------" -ForegroundColor White
Write-Host "ACTION REQUIRED:" -ForegroundColor White
Write-Host "1. Paste this command to wake me up:" -ForegroundColor White
Write-Host "   npx openclaw onboard" -ForegroundColor Yellow
Write-Host ""
Write-Host "2. I've left a secret manual for you here:" -ForegroundColor White
Write-Host "   notepad $ManualPath" -ForegroundColor White
Write-Host "-------------------------------------------------------" -ForegroundColor White
