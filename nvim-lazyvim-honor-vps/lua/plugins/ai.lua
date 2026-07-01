-- Claude Code 接入(coder/claudecode.nvim)
-- 通过 WebSocket 把 Claude Code CLI 连进 neovim(与官方 VS Code 扩展同一套协议):
-- 选区/文件发送、整仓上下文、inline diff 的 agentic 编辑都在编辑器里完成。
-- 注意:它不是 Copilot 那种"边打字边出灰字"的内联补全 —— 需要 AI 时主动唤起。
--
-- 前缀用 <leader>i(<leader>a 留给头/源切换的习惯键)。
-- 系统依赖:Claude Code CLI(claude)需已安装。
return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = true,
    keys = {
      { "<leader>i", nil, desc = "AI / Claude Code" },
      { "<leader>ic", "<cmd>ClaudeCode<cr>", desc = "切换 Claude Code" },
      { "<leader>if", "<cmd>ClaudeCodeFocus<cr>", desc = "聚焦 Claude" },
      { "<leader>ir", "<cmd>ClaudeCode --resume<cr>", desc = "恢复会话" },
      { "<leader>iC", "<cmd>ClaudeCode --continue<cr>", desc = "继续上次会话" },
      { "<leader>ib", "<cmd>ClaudeCodeAdd %<cr>", desc = "把当前文件加入上下文" },
      { "<leader>is", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "发送选区给 Claude" },
      { "<leader>ia", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "接受 diff" },
      { "<leader>id", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "拒绝 diff" },
    },
  },

  -- GitHub Copilot:仅作为 blink 补全的"一个源",默认关闭(只走本地补全),
  -- 按 <leader>tc 打开后才走云端;不挂内联灰字/面板(那些另由 Claude Code 负责)。
  -- 系统依赖:Node.js + 首次 `:Copilot auth` 登录。
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    init = function()
      vim.g.copilot_cmp_on = false -- 默认只本地;blink 的 copilot 源据此启停(见 coding.lua)
    end,
    opts = {
      suggestion = { enabled = false }, -- 关掉自带内联灰字
      panel = { enabled = false }, -- 关掉自带面板
    },
    keys = {
      {
        "<leader>tc",
        function()
          vim.g.copilot_cmp_on = not vim.g.copilot_cmp_on
          vim.notify("Copilot 云端补全:" .. (vim.g.copilot_cmp_on and "开" or "关(仅本地)"), vim.log.levels.INFO)
        end,
        desc = "切换 Copilot 云端补全",
      },
    },
  },
  -- 把 Copilot 暴露成 blink.cmp 的 source
  { "fang2hou/blink-copilot" },
}
