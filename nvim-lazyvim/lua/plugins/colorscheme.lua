-- 高区分度主题集合(避开 tokyonight / nord / rose-pine 那类低对比、各组颜色偏统一的风格)
-- 这些主题对 treesitter 捕获组着色丰富,能明显区分 函数 / 变量 / 成员 / 类型 / 参数。
-- 切换:<leader>uC(实时预览)。默认 gruvbox-material。
return {
  -- 默认配色:gruvbox-material(暖色,区分度高)
  {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    init = function()
      vim.g.gruvbox_material_background = "medium" -- soft / medium / hard
      vim.g.gruvbox_material_foreground = "original" -- material / mix / original;original 配色最鲜明
      vim.g.gruvbox_material_enable_bold = 1
      vim.g.gruvbox_material_enable_italic = 1
      vim.g.gruvbox_material_better_performance = 1
    end,
  },

  -- 备选主题(都是高区分度风格,按需 <leader>uC 切换)
  { "sainnhe/sonokai", lazy = true },
  { "rebelot/kanagawa.nvim", lazy = true },
  { "loctvl842/monokai-pro.nvim", lazy = true },
  { "Mofiqul/dracula.nvim", lazy = true },
  { "EdenEast/nightfox.nvim", lazy = true },
  { "olimorris/onedarkpro.nvim", lazy = true },
  { "Mofiqul/vscode.nvim", lazy = true },
}
