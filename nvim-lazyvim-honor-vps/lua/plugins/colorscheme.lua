-- 完全照搬 vimrc 的配色与背景风格:
--   set background=dark
--   colorscheme jellybeans
--   hi Normal ctermbg=NONE guibg=NONE   " 背景透明,用终端背景
-- 这里用原版 nanotech/jellybeans.vim(与 vim 中 vim-colorschemes 里的 jellybeans 同源)。
-- 切换备选主题:<leader>uC(实时预览)。
return {
  -- 默认配色:jellybeans(与 vim 一致)
  {
    "nanotech/jellybeans.vim",
    lazy = false,
    priority = 1000,
    init = function()
      vim.opt.background = "dark"
      -- jellybeans 官方透明背景配置,等价 vimrc 的 hi Normal guibg=NONE
      vim.g.jellybeans_overrides = {
        background = { guibg = "none" },
      }
      -- 兜底:任何主题加载后都把背景清成透明(等价 vimrc 的 hi Normal ctermbg=NONE guibg=NONE)
      -- 覆盖 Normal 及周边组,确保终端背景能透出来(浮窗/侧边栏一并透明)。
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("TransparentBg", { clear = true }),
        callback = function()
          for _, g in ipairs({
            "Normal",
            "NormalNC",
            "NormalFloat",
            "FloatBorder",
            "SignColumn",
            "EndOfBuffer",
            "LineNr",
            "FoldColumn",
          }) do
            vim.api.nvim_set_hl(0, g, { bg = "none", ctermbg = "NONE" })
          end
          -- 透明背景下主题默认的 CursorLine/CursorColumn(近黑 #1c1c1c)几乎看不见,
          -- 这里改成更明显的灰色,保证光标行/列高亮可见。
          vim.api.nvim_set_hl(0, "CursorLine", { bg = "#303030", ctermbg = 236 })
          vim.api.nvim_set_hl(0, "CursorColumn", { bg = "#303030", ctermbg = 236 })
        end,
      })
    end,
  },

  -- 让 LazyVim 启动时就用 jellybeans
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "jellybeans",
    },
  },

  -- 备选主题(高区分度风格,按需 <leader>uC 切换)
  { "sainnhe/gruvbox-material", lazy = true },
  { "sainnhe/sonokai", lazy = true },
  { "rebelot/kanagawa.nvim", lazy = true },
  { "loctvl842/monokai-pro.nvim", lazy = true },
  { "Mofiqul/dracula.nvim", lazy = true },
  { "EdenEast/nightfox.nvim", lazy = true },
  { "olimorris/onedarkpro.nvim", lazy = true },
  { "Mofiqul/vscode.nvim", lazy = true },
}
