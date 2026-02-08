# ClawEase - Windows PowerShell Installer (V3 - Pre-built Edition)
# "Reliable, Fast, Zero-Build"

# 1. Clear Terminal and Set Encoding
Clear-Host
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host "ClawEase: Preparing your AI Agent (Windows)" -ForegroundColor Cyan
Write-Host "=======================================================" -ForegroundColor Cyan

# 2. Check/Install Scoop & Node.js
if (!(Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "[1/3] Installing Scoop (Package Manager)..." -ForegroundColor Yellow
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    iwr -useb get.scoop.sh | iex
}

$env:PATH += ";$HOME\scoop\shims"

if (!(Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "[2/3] Installing Node.js..." -ForegroundColor Yellow
    scoop install nodejs-lts
}

# 3. Create Deployment Directory
$BaseDir = "$HOME\.clawease"
if (!(Test-Path $BaseDir)) { New-Item -ItemType Directory -Path $BaseDir }
Set-Location $BaseDir

# 4. Install OpenClaw via NPM (Pre-built)
Write-Host "[3/3] Downloading Agent Brains..." -ForegroundColor Yellow
if (!(Test-Path "package.json")) {
    & npm init -y | Out-Null
}
& npm install openclaw@latest

# 5. Create Local Manual
$ManualPath = "$BaseDir\GETTING_STARTED.txt"
$ManualContent = @"
=======================================================
           ClawEase - Your Agent Manual
=======================================================

Congratulations! Your AI Agent (Tony V) is ready.

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
=======================================================
"@
$ManualContent | Out-File -FilePath $ManualPath -Encoding utf8

# 6. Final Instructions
Write-Host ""
Write-Host "-------------------------------------------------------" -ForegroundColor White
Write-Host "SUCCESS! Your Agent is installed." -ForegroundColor Green
Write-Host "-------------------------------------------------------" -ForegroundColor White
Write-Host "WHAT TO DO NOW:" -ForegroundColor White
Write-Host "1. Paste this command to start the wizard:" -ForegroundColor White
Write-Host "   npx openclaw onboard" -ForegroundColor Yellow
Write-Host ""
Write-Host "2. Read your local manual for more tips:" -ForegroundColor White
Write-Host "   notepad $ManualPath" -ForegroundColor White
Write-Host "-------------------------------------------------------" -ForegroundColor White
