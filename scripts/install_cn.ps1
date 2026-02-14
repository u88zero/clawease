# ClawEase - Windows PowerShell Installer (CN Optimized Edition)
# "Force Install & Dependency Guard"

# 1. 强制开启 TLS 1.2 并设置编码
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Clear-Host
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host "     ClawEase: Your Personal AI Agent Pipeline (CN)    " -ForegroundColor Cyan
Write-Host "      'Force Install & Dependency Guard Edition'        " -ForegroundColor White
Write-Host "=======================================================" -ForegroundColor Cyan

Write-Host "Boss，Tony V 正在暴力破解权限限制，请稍后..." -ForegroundColor Magenta
Write-Host ""

# 2. 强制安装 Scoop (针对权限受限环境优化)
if (!(Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "[1/4] 系统缺失 Scoop，正在强制安装并绕过策略..." -ForegroundColor Yellow
    # 使用国内镜像加速
    $installer_url = "https://gitee.com/glacier/scoop-installer/raw/master/install.ps1"
    
    # 执行强制越狱安装
    powershell -ExecutionPolicy Bypass -Command "iwr -useb $installer_url | iex"
    
    # 刷新当前进程的环境变量，确得装完立刻能用
    $env:PATH += ";$HOME\scoop\shims"
}

# 3. 核心依赖守护：安装 Git, Node.js & PNPM
# 解决截图中的 "npm error syscall spawn git" 问题
Write-Host "[2/4] 检查核心生存依赖 (Git & Runtime)..." -ForegroundColor Yellow

if (!(Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "[*] 关键发现：系统缺少 Git！正在通过 Scoop 强制补齐..." -ForegroundColor Cyan
    scoop install git
}

if (!(Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "[*] 正在通过 Scoop 安装 Node.js (LTS)..." -ForegroundColor Cyan
    scoop install nodejs-lts
}

if (!(Get-Command pnpm -ErrorAction SilentlyContinue)) {
    Write-Host "[*] 正在通过 Scoop 安装 PNPM..." -ForegroundColor Cyan
    scoop install pnpm
}

# 4. 配置 NPM 镜像源加速下载
Write-Host "[3/4] 正在配置国内高速源 (阿里云)..." -ForegroundColor Cyan
& pnpm config set registry https://registry.npmmirror.com

# 5. 准备部署目录
$BaseDir = "$HOME\.clawease"
if (!(Test-Path $BaseDir)) { New-Item -ItemType Directory -Path $BaseDir }
Set-Location $BaseDir

# 6. 安装最新版 OpenClaw (v2026.2.9)
Write-Host "[4/4] 正在部署最新核心 v2026.2.9..." -ForegroundColor Yellow
if (!(Test-Path "package.json")) {
    & pnpm init | Out-Null
}

# 解决某些环境下 pnpm 找不到 git 的问题
$env:PATH += ";$HOME\scoop\shims"
& pnpm add openclaw@latest --reporter=default

# 7. 创建本地操作手册
$ManualPath = "$BaseDir\GETTING_STARTED.txt"
$ManualContent = @"
=======================================================
           ClawEase - 你的智能体管理手册
=======================================================

恭喜 Boss！你的 AI 助手 (Tony V) 已经部署完毕。

快速启动:
1. 运行此命令唤醒助手:
   npx openclaw onboard

2. 查看当前状态:
   npx openclaw status

3. 官方文档:
   https://docs.openclaw.ai/

提示:
- 如果提示 'git not found'，请重开一个窗口再试。
- 保持此窗口开启，助手即可持续运行。
- 你可以通过浏览器访问控制台: http://localhost:18789
=======================================================
"@
$ManualContent | Out-File -FilePath $ManualPath -Encoding utf8

# 8. 成功谢幕
Write-Host ""
Write-Host "-------------------------------------------------------" -ForegroundColor White
Write-Host " SUCCESS! 搞定！Boss，你已经正式跨入智能体时代。" -ForegroundColor Green
Write-Host "-------------------------------------------------------" -ForegroundColor White
Write-Host "下一步操作 (请重开窗口以刷新环境变量)：" -ForegroundColor White
Write-Host "   npx openclaw onboard" -ForegroundColor Yellow
Write-Host ""
Write-Host "详细手册：notepad $ManualPath" -ForegroundColor White
Write-Host "-------------------------------------------------------" -ForegroundColor White
