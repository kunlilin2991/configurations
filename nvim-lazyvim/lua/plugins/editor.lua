-- 从 vimrc 迁移过来的编辑增强插件
return {
  -- 注释(vimrc: nerdcommenter 的 ;cc 注释 / ;cu 取消,各做一件事)
  -- 不接管 gc(原生 gcc/gc 的 toggle 保留),只用其 API 实现显式 注释/取消。
  {
    "numToStr/Comment.nvim",
    opts = { mappings = false },
    keys = {
      {
        "<leader>cc",
        function()
          require("Comment.api").comment.linewise.current()
        end,
        desc = "注释当前行",
      },
      {
        "<leader>cu",
        function()
          require("Comment.api").uncomment.linewise.current()
        end,
        desc = "取消注释当前行",
      },
      {
        "<leader>cc",
        "<Esc><cmd>lua require('Comment.api').comment.linewise(vim.fn.visualmode())<cr>",
        mode = "x",
        desc = "注释选区",
      },
      {
        "<leader>cu",
        "<Esc><cmd>lua require('Comment.api').uncomment.linewise(vim.fn.visualmode())<cr>",
        mode = "x",
        desc = "取消注释选区",
      },
    },
  },

  -- 代码结构大纲(treesitter 后端,无需 ctags/LSP;vimrc: tagbar → aerial,F9 / <leader>tb)
  {
    "stevearc/aerial.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = { "AerialToggle", "AerialOpen" },
    keys = {
      { "<F9>", "<cmd>AerialToggle<cr>", desc = "结构大纲(aerial)" },
      { "<leader>tb", "<cmd>AerialToggle<cr>", desc = "结构大纲(aerial)" },
    },
    opts = {
      backends = { "treesitter", "markdown", "man" }, -- 无 LSP
      layout = { width = 32, default_direction = "right" },
      attach_mode = "global",
      show_guides = true,
    },
  },

  -- undo 历史树(Lua 版;<leader>su)
  {
    "jiaoshijie/undotree",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    keys = {
      {
        "<leader>su",
        function()
          require("undotree").toggle()
        end,
        desc = "undo 历史树",
      },
    },
  },

  -- 对齐(vim-easy-align → mini.align;ga 启动,可视模式 <CR> 同效)
  {
    "echasnovski/mini.align",
    opts = {},
    keys = {
      { "ga", mode = { "n", "x" }, desc = "对齐(mini.align)" },
      { "gA", mode = { "n", "x" }, desc = "对齐+预览(mini.align)" },
      { "<cr>", "ga", mode = "x", remap = true, desc = "对齐(mini.align)" },
    },
  },

  -- 括号配色(vimrc: rainbow → rainbow-delimiters,基于 treesitter)
  { "HiPhish/rainbow-delimiters.nvim" },

  -- TODO/FIXME/HACK 等高亮与跳转(vimrc: TaskList,<leader>td)
  {
    "folke/todo-comments.nvim",
    opts = {
      keywords = {
        MODIFY = { icon = " ", color = "hint" }, -- vimrc 自定义关键字
      },
    },
    keys = {
      { "<leader>td", "<cmd>TodoTrouble<cr>", desc = "TODO/FIXME 列表" },
    },
  },
}
