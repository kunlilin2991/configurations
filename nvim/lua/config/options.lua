-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- ~/.config/nvim/lua/config/options.lua
local opt = vim.opt

-- 允许 backspace 删除自动缩进、行首空格和换行符
-- 对应原 .vimrc: set backspace=indent,eol,start
opt.backspace = "indent,eol,start"

-- 自动缩进相关设置
-- 对应原 .vimrc: set ai, autoindent, smartindent
opt.autoindent = true
opt.smartindent = true

-- 启用自动换行（视觉折行）
opt.wrap = true

-- 可选但强烈推荐：在单词边界处折行，避免在单词中间断开
opt.linebreak = true

-- 缩进与 Tab 设置：使用 4 空格代替 Tab
-- 对应原 .vimrc: set shiftwidth=4, sw=4, tabstop=4, expandtab, smarttab
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

-- 搜索设置：高亮、增量、忽略大小写但智能区分
-- 对应原 .vimrc: set hlsearch, incsearch, ignorecase, smartcase
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- 显示设置：行号、状态栏、光标行/列、滚动边距
-- 对应原 .vimrc: set number, relativenumber, laststatus=2, ruler, showmode, cursorline, cursorcolumn, scrolloff=15
opt.number = true
opt.relativenumber = true
opt.laststatus = 2
opt.ruler = true
opt.showmode = true
opt.cursorline = true
opt.cursorcolumn = true
opt.scrolloff = 15

-- 折叠设置：启用折叠，但仅手动创建（zf）
-- 对应原 .vimrc: set foldenable, foldmethod=manual
opt.foldenable = true
opt.foldmethod = "manual"

-- 鼠标支持：在所有模式下启用鼠标（a = all）
-- 对应原 .vimrc: set mouse=a
opt.mouse = "a"

-- 编码设置：使用 UTF-8（Neovim 默认已为 UTF-8，显式声明更清晰）
-- 对应原 .vimrc: set encoding=utf-8
opt.encoding = "utf-8"

-- 匹配括号高亮（输入 ) 时短暂跳转到 ( ）
-- 对应原 .vimrc: set showmatch
opt.showmatch = true
