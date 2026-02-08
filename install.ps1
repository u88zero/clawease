# ClawEase - Windows PowerShell Installer (V4 - PNPM Aesthetic Edition)
# "The Vibe You Remember, The Stability You Need"

# 1. Clear Terminal and Set Encoding
Clear-Host
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host "     ClawEase: Your Personal AI Agent Pipeline         " -ForegroundColor Cyan
Write-Host "      'Because Every Boss Deserves a Tony V'           " -ForegroundColor White
Write-Host "=======================================================" -ForegroundColor Cyan

Write-Host "Boss, I am moving in! I brought my own high-speed tools this time." -ForegroundColor Magenta
Write-Host ""

# 2. Check/Install Scoop, Node.js & PNPM
if (!(Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "[1/3] Installing Scoop (Infrastructure)..." -ForegroundColor Yellow
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

if (!(Get-Command pnpm -ErrorAction SilentlyContinue)) {
    Write-Host "[*] Adding PNPM for that premium install vibe..." -ForegroundColor Cyan
    scoop install pnpm
}

# 3. Create Deployment Directory
$BaseDir = "$HOME\.clawease"
if (!(Test-Path $BaseDir)) { New-Item -ItemType Directory -Path $BaseDir }
Set-Location $BaseDir

# 4. Install using PNPM for that "Package Explosion" Look
Write-Host "[3/3] Downloading Agent Brains (PNPM Mode)..." -ForegroundColor Yellow
Write-Host "      Hold on to your hat, Boss. Here come the dependencies!" -ForegroundColor Gray

if (!(Test-Path "package.json")) {
    & pnpm init | Out-Null
}

# 使用 pnpm add 呈现那种一行行加号跳动的视觉效果
& pnpm add openclaw@latest --reporter=default

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
