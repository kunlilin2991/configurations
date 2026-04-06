-- 额外插件（LazyVim 不自带，但你的 vimrc 中有的功能）
return {
  -- ========== rainbow-delimiters: 替代 rainbow 括号配色 ==========
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "BufReadPost",
    config = function()
      require("rainbow-delimiters.setup").setup({})
    end,
  },

  -- ========== vim-easy-align: 保留你的 EasyAlign 习惯 ==========
  {
    "junegunn/vim-easy-align",
    event = "VeryLazy",
  },

  -- ========== undotree: 替代 gundo ==========
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
  },
  
  -- ========== venn.nvim: 替代 DrawIt（ASCII 绘图）==========
  -- 如果你需要 ASCII 绘图功能，取消注释
  -- {
  --   "jbyuki/venn.nvim",
  --   cmd = "VBox",
  -- },
}
