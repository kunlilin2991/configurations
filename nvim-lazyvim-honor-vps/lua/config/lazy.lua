-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "克隆 lazy.nvim 失败:\n", "ErrorMsg" },
      { out, "WarningMsg" },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- LazyVim 核心。
    -- 故意不引入任何 lang extra:不要 clangd(无 compile_commands.json 会满屏报错),
    -- 也不要 markdown / latex。C/C++ 的高亮交给 treesitter,导航交给 ctags/gtags。
    {
      "LazyVim/LazyVim",
      import = "lazyvim.plugins",
      opts = { colorscheme = "gruvbox-material" },
    },
    -- 自定义插件
    { import = "plugins" },
  },
  defaults = { lazy = false, version = false },
  install = { colorscheme = { "gruvbox-material", "habamax" } },
  checker = { enabled = true, notify = false }, -- 自动检查更新,不弹通知
  performance = {
    rtp = {
      disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin" },
    },
  },
})
