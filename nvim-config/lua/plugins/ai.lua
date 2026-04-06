-- AI 补全插件
-- 以下三个选一个启用，其余注释掉

return {
  -- ========== 方案 1: GitHub Copilot（推荐，LazyVim 官方支持）==========
  -- 需要 GitHub Copilot 订阅（$10/月，学生免费）
  -- 安装后运行 :Copilot auth 登录
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<M-l>",       -- Alt+l 接受建议
          accept_word = "<M-k>",  -- Alt+k 接受一个词
          next = "<M-]>",         -- Alt+] 下一个建议
          prev = "<M-[>",         -- Alt+[ 上一个建议
          dismiss = "<C-]>",      -- Ctrl+] 取消建议
        },
      },
      panel = { enabled = true },
    },
  },

  -- ========== 方案 2: Codeium（免费替代）==========
  -- 免费，功能类似 Copilot
  -- 安装后运行 :Codeium Auth 登录
  -- {
  --   "Exafunction/codeium.nvim",
  --   event = "InsertEnter",
  --   dependencies = { "nvim-lua/plenary.nvim", "hrsh7th/nvim-cmp" },
  --   config = function()
  --     require("codeium").setup({})
  --   end,
  -- },

  -- ========== 方案 3: Supermaven（速度最快）==========
  -- 免费版可用，Pro $10/月
  -- {
  --   "supermaven-inc/supermaven-nvim",
  --   event = "InsertEnter",
  --   opts = {
  --     keymaps = {
  --       accept_suggestion = "<Tab>",
  --       clear_suggestion = "<C-]>",
  --       accept_word = "<C-j>",
  --     },
  --   },
  -- },

  -- ========== avante.nvim: AI 对话窗口（类似 Cursor）==========
  -- 可以在编辑器内和 AI 对话，支持多种后端
  -- {
  --   "yetone/avante.nvim",
  --   event = "VeryLazy",
  --   build = "make",
  --   opts = {
  --     provider = "claude",  -- 或 "openai", "copilot"
  --   },
  --   dependencies = {
  --     "nvim-treesitter/nvim-treesitter",
  --     "stevearc/dressing.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "MunifTanjim/nui.nvim",
  --   },
  -- },
}
