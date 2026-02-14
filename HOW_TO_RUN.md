# 如何运行完整安装

## 方法 1: 使用 Windows PowerShell（推荐）

1. 按 `Win + X`，选择 "Windows PowerShell (管理员)" 或 "终端 (管理员)"

2. 切换到项目目录：
```powershell
cd F:\One-Click-Claw-Deplo
```

3. 运行安装脚本：
```powershell
.\install.ps1
```

如果遇到执行策略限制，使用：
```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

## 方法 2: 使用 Windows Terminal

1. 打开 Windows Terminal
2. 确保使用 PowerShell（不是 Git Bash）
3. 运行相同的命令

## 方法 3: 右键运行

1. 在文件资源管理器中找到 `install.ps1`
2. 右键点击 → "使用 PowerShell 运行"

## 安装过程会做什么

根据模拟测试，脚本会：

✅ **已有的依赖（会跳过）：**
- Git v2.49.0 ✓
- Node.js v24.11.0 ✓
- PNPM v10.29.3 ✓

⚙️ **会执行的操作：**
1. 安装 Scoop（如果没有）
2. 配置阿里云镜像（中文环境）
3. 在 `C:\Users\刘雨翔\.clawease` 创建部署目录
4. 运行 `pnpm add openclaw@latest` 安装 OpenClaw
5. 生成 `.env.template` 和 `.env` 配置文件
6. 创建使用手册 `GETTING_STARTED.txt`

## 预计时间

- 如果所有依赖都已安装：约 2-3 分钟
- 如果需要安装 Scoop：约 5-10 分钟

## 安装后

运行以下命令启动智能体：
```bash
npx openclaw onboard
```

访问控制台：
```
http://localhost:18789
```

## 测试脚本

如果你想先看看会发生什么（不实际安装）：
```powershell
.\simulate_install.ps1
```

---

**注意**: 由于我在受限的 Bash 环境中运行，无法直接打开真实的 PowerShell 窗口执行完整安装。请你在真实的 PowerShell 中手动运行上述命令。
