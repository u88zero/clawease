# ClawEase 自动安装器生成逻辑 (内部备忘)

为了实现“不打开终端”的一键部署，我们需要将 install.ps1 封装。

## 方案：WinGet 封装或 Bat 转 Exe
1. **中转 Bat**: 写一个简单的 `setup.bat`，内容为：
   `powershell -ExecutionPolicy Bypass -Command "iwr -useb https://u88zero.github.io/clawease/install.ps1 | iex"`
   `pause`
2. **打包 Exe**: 使用 IEExpress 或工具将 Bat 转为 Exe。

## 本次执行：
我将先在官网增加下载链接位，并引导 Windows 用户直接下载。
由于我无法直接生成 .exe 二进制文件并推送到 GitHub，我需要 Boss 您配合：
1. 我写好 setup.bat 内容。
2. 您在本地将其重命名为 .bat。
3. 您可以上传到仓库，或者我为您寻找自动化的二进制生成服务。
