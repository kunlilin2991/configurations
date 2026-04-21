-- lazy.lua - 插件管理器启动
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
  spec = {
    -- LazyVim 核心
    {
      "LazyVim/LazyVim",
      import = "lazyvim.plugins",
      opts = {
        colorscheme = "solarized-osaka", -- 接近你原来的 solarized 配色
      },
    },
    -- LazyVim extras（按需启用）
    { import = "lazyvim.plugins.extras.lang.clangd" },     -- C/C++ LSP
    { import = "lazyvim.plugins.extras.lang.markdown" },    -- Markdown
    -- { import = "lazyvim.plugins.extras.lang.python" },      -- Python（如需要取消注释）
    { import = "lazyvim.plugins.extras.lang.json" },        -- JSON
    -- { import = "lazyvim.plugins.extras.lang.tex" },      -- LaTeX（如需要取消注释）

    -- 你的自定义插件配置
    { import = "plugins" },
  },
  defaults = {
    lazy = false,
    version = false,
  },
  checker = { enabled = true }, -- 自动检查插件更新
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
