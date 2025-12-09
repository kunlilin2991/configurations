-- ~/.config/nvim/lua/plugins/init.lua

return {
  -- 插件管理器（必须第一个）
  { "folke/lazy.nvim", version = false },

  -- 状态栏美化（替代 vim-airline）
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },

  -- 文件树（替代 NERDTree）
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },

  -- 模糊查找（替代 ctrlp.vim）
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

  -- 代码补全（替代 YouCompleteMe）
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "L3MON4D3/LuaSnip", -- 代码片段引擎（替代 UltiSnips）
      "saadparwaiz1/cmp_luasnip", -- 补全 LuaSnip 片段
      "hrsh7th/cmp-nvim-lsp", -- LSP 补全
      "rafamadriz/friendly-snippets", -- 社区代码片段
    },
  },

  -- LSP 支持（提供智能补全、跳转、诊断等）
  { "neovim/nvim-lspconfig" },

  -- 代码注释（替代 nerdcommenter）
  { "numToStr/Comment.nvim", event = "VeryLazy" },

  -- 缩进线（替代 indentLine）
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },

  -- 括号高亮（替代 rainbow）
  { "hiphish/rainbow-delimiters.nvim", event = "UiEnter" },

  -- 大纲视图（替代 Tagbar）
  { "simrat39/symbols-outline.nvim" },

  -- 配色方案（solarized 的现代替代）
  { "folke/tokyonight.nvim", priority = 1000 },
}
