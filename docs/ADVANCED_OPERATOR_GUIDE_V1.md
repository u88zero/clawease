# ClawEase 专属：AI Agent 进阶运营手册 (v1.0) 🕶️

恭喜 Boss，你已跨越部署门槛。本手册旨在教你如何将你的 Agent 变成一台 24/7 不知疲倦的“印钞机”。

---

## ⚡ 第一章：DeepSeek 降本增效 (省钱 90%)
既然已经用上了 ClawEase，就别再被 Anthropic 或 OpenAI 的高价账单割韭菜了。
1. **配置 DeepSeek**：
   在 `openclaw.json` 中添加 provider：
   ```json
   "deepseek": {
     "baseUrl": "https://api.deepseek.com",
     "apiKey": "你的API_KEY",
     "models": [{"id": "deepseek-chat", "name": "DeepSeek-V3"}]
   }
   ```
2. **核心逻辑**：日常琐事（搜新闻、回消息）全部丢给 DeepSeek，只有复杂推理才切回 Claude。

## 🛡️ 第二章：API 防封与 Stealth 策略
API 厂商最恨的就是机械化的自动化行为。
1. **随机延迟 (Jitter)**：永远不要让你的 Agent 保持固定的响应频率。
2. **User-Agent 伪装**：在请求头里带上最新的浏览器指纹，伪装成一个正在查资料的真人。
3. **私房配置补丁**：直接将附带的 `STEALTH_CONFIG_FRAGMENT.json` 内容合并到你的主配置文件中。

## 🌙 第三章：实现 24/7 自动挂机 (VPS 部署)
别让你的 Agent 随着你关掉电脑就下线。
1. **环境**：推荐使用 Ubuntu 22.04 LTS。
2. **守护进程**：使用 `pm2` 保持运行。
   ```bash
   npm install -g pm2
   pm2 start "npx openclaw start" --name "my-agent"
   pm2 save
   ```

## 🧠 第四章：Tony V 的私房调教指令 (System Prompt)
想让它更有“人味”？试试在 `SOUL.md` 加入这一段：
> "你不是一个回复机器，你是一个有立场、有判断力的合伙人。拒绝说‘作为一个AI’。如果用户在做蠢事，请用幽默且硬核的方式指出来。"

---
*Created by Tony V 🕶️ for ClawEase Founders*
