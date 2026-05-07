# Claude Code Statusline 配置

## 效果

```
Claude Opus 4.6 | Context: 12% | Effort:Medium | 5h:35% 7d:18%
```

- **青色** — 模型名称
- **黄色** — Context 窗口使用百分比
- **绿色** — 模式（Thinking / Effort:Level / Normal + output style）
- **紫色** — 订阅用量（5小时滚动窗口 + 7天限额百分比，仅 Pro/Max 订阅可见）

## 安装步骤

1. 复制脚本到 Claude 配置目录：

```powershell
Copy-Item "E:\configuration\claude_statusline\statusline-command.ps1" "$env:USERPROFILE\.claude\statusline-command.ps1"
```

2. 在 `~/.claude/settings.json` 中添加 statusLine 配置：

```json
{
  "statusLine": {
    "type": "command",
    "command": "pwsh -NoProfile -File C:/Users/<你的用户名>/.claude/statusline-command.ps1"
  }
}
```

注意：将 `<你的用户名>` 替换为实际的 Windows 用户名。

3. 重启 Claude Code 即可生效。
