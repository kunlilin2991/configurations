-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- leader key
vim.g.mapleader = ";"
vim.g.maplocalleader = ";"

--le lb in keymap.lua

-- 搜索相关设置
vim.opt.hlsearch = true       -- 高亮搜索
vim.opt.incsearch = true      -- 实时搜索
vim.opt.ignorecase = true     -- 忽略大小写
vim.opt.smartcase = true      -- 有大写时区分大小写

-- 语法与显示
vim.cmd("syntax on")          -- 语法高亮
vim.opt.showmatch = true      -- 匹配符号高亮
-- 文件编码
vim.opt.encoding = "utf-8"
-- 使用 Unix/Linux 换行符（LF）
vim.opt.fileformat = "unix"
vim.opt.fileformats = { "unix", "dos", "mac" }

-- 缩进
vim.opt.smartindent = true
vim.opt.autoindent = true

-- 高亮当前行跟列
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
-- 只在当前窗口高亮（避免分屏干扰）
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
  callback = function()
    vim.opt_local.cursorline = true
    vim.opt_local.cursorcolumn = true
  end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
  callback = function()
    vim.opt_local.cursorline = false
    vim.opt_local.cursorcolumn = false
  end,
})
-- Insert 模式只高亮行
vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function()
    vim.opt_local.cursorcolumn = false
  end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    vim.opt_local.cursorcolumn = true
  end,
})
-- 确保neovim不使用系统剪贴板，除非用户明确设置
vim.opt.clipboard = ""

-- 关闭全局诊断，用户可以根据需要在特定文件或项目中启用
vim.diagnostic.enable(false)

-- 默认缩进为 4 个空格
vim.opt.tabstop = 4        -- 一个 Tab 显示为 4 个空格
vim.opt.shiftwidth = 4    -- 自动缩进使用 4 个空格
vim.opt.softtabstop = 4   -- 插入模式下 Tab = 4 个空格
vim.opt.expandtab = true  -- 使用空格代替 Tab
-- linux kernel风格是8个
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function()
    vim.opt_local.tabstop = 8
    vim.opt_local.shiftwidth = 8
    vim.opt_local.softtabstop = 8
    vim.opt_local.expandtab = false
  end,
})
