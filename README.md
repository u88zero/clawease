# ClawEase - One-Click Deployment

> 一键部署你的 AI 智能体 | One-Click Deploy Your AI Agent

## 快速开始 | Quick Start

### Windows 用户

只需运行一个命令：

```powershell
.\install.ps1
```

脚本会自动：
- 检测系统语言（中文/英文）
- 检测并安装 Git
- 检测并安装 Node.js v20+
- 检测并安装 PNPM
- 配置 .env 环境模板
- 部署 OpenClaw 最新版本

### Linux/macOS 用户

```bash
sudo bash scripts/install.sh
```

## 目录结构 | Directory Structure

```
One-Click-Claw-Deplo/
├── install.ps1              # 统一安装脚本（Windows）
├── README.md                # 项目说明
├── docs/                    # 文档目录
│   ├── GETTING_STARTED_ZH.md
│   ├── ADVANCED_OPERATOR_GUIDE_V1.md
│   └── AUTO_INSTALLER_NOTE.md
├── web/                     # Web 界面文件
│   ├── index.html
│   ├── launcher_akiba.html
│   ├── launcher_demo.html
│   └── launcher_pro_design.html
└── scripts/                 # 其他平台脚本
    ├── install.sh           # Linux 安装脚本
    ├── install_cn.sh        # Linux 中文版
    ├── install_macos.sh     # macOS 安装脚本
    ├── install_cn.ps1       # Windows 中文版（已合并）
    ├── ClawEase-OneClick.bat
    └── STEALTH_CONFIG_FRAGMENT.json
```

## 特性 | Features

### ✅ 智能检测
- 自动检测系统语言（中文/英文）
- 精确检测 Node.js 版本（要求 v20+）
- 自动检测 Git 是否安装
- 智能选择镜像源（中国用户自动使用阿里云镜像）

### ✅ 环境配置
- 自动生成 `.env.template` 模板
- 自动创建 `.env` 配置文件
- 包含所有必要的环境变量说明

### ✅ 一键部署
- 无需手动安装依赖
- 自动配置运行环境
- 生成详细的使用手册

## 环境要求 | Requirements

- Windows 10/11 或 Linux/macOS
- PowerShell 5.1+ (Windows)
- Bash (Linux/macOS)
- 网络连接

## 安装后 | After Installation

安装完成后，运行以下命令启动智能体：

```bash
npx openclaw onboard
```

访问控制台：`http://localhost:18789`

## 配置 | Configuration

编辑 `~/.clawease/.env` 文件，配置你的环境变量：

```env
# Telegram Bot Token (从 @BotFather 获取)
TELEGRAM_BOT_TOKEN=your_telegram_bot_token_here

# OpenClaw 配置
OPENCLAW_PORT=18789
OPENCLAW_HOST=localhost

# 日志级别
LOG_LEVEL=info
```

## 故障排除 | Troubleshooting

### Git 未找到
如果提示 `git not found`，请重新打开一个新的 PowerShell 窗口。

### Node.js 版本过低
脚本会自动检测并安装 Node.js v20+。如果已安装旧版本，脚本会提示并自动升级。

### 网络问题
中国用户会自动使用国内镜像源（阿里云），无需额外配置。

## 文档 | Documentation

- [快速入门指南](docs/GETTING_STARTED_ZH.md)
- [高级操作指南](docs/ADVANCED_OPERATOR_GUIDE_V1.md)
- [自动安装说明](docs/AUTO_INSTALLER_NOTE.md)

## 官方文档 | Official Docs

https://docs.openclaw.ai/

## License

MIT
