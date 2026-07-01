-- options.lua —— 移植自 vimrc 的编辑器设置
-- 本文件在 LazyVim 默认 options 之后加载,因此这里的设置会覆盖 LazyVim 默认。
local opt = vim.opt

-- leader = ";" —— 必须在这里设!LazyVim 默认 options 会把 init.lua 设的 mapleader
-- 覆盖成空格;本文件在其之后加载,这里设才真正生效(否则所有 ; 开头的键全失效)。
vim.g.mapleader = ";"
vim.g.maplocalleader = ";"

-- 缩进:一律 4 空格(vimrc: shiftwidth/tabstop/softtabstop=4 + expandtab)
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smarttab = true
opt.autoindent = true
opt.smartindent = true

-- 行号:绝对 + 相对(vimrc: number + relativenumber)
opt.number = true
opt.relativenumber = true

-- 光标行/列高亮(vimrc: cursorline + cursorcolumn)
opt.cursorline = true
opt.cursorcolumn = true

-- 编辑行尽量保持在屏幕中部(vimrc: scrolloff=15)
opt.scrolloff = 15

-- 搜索(vimrc: hlsearch/incsearch/ignorecase/smartcase)
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- 折叠:手动折叠(vimrc: foldmethod=manual)
opt.foldenable = true
opt.foldmethod = "manual"

-- 鼠标(vimrc: mouse=a)
opt.mouse = "a"

-- 拼写语言(vimrc: spelllang=en_us);spell 默认关
opt.spelllang = { "en_us" }

-- conceal:LazyVim 默认 conceallevel=2,会隐藏 markdown 的 * / _ 等标记(以及任何带
-- conceal 属性的字符)。这里改成 0 = 原样显示所有字符,保证引号、星号等都不被吃掉。
-- 想要 markdown 的干净渲染(隐藏 *bold* 的星号)可改回 2。
opt.conceallevel = 0

-- 说明:
--  * vimrc 的 `set autochdir` 没有移植 —— 它会不停把 cwd 切到当前文件目录,
--    与 gutentags 工程根检测、picker/neo-tree 的 root 机制冲突;改用工程根标记。
--  * vimrc 的 `set pastetoggle` 没有移植 —— neovim 已自动处理括号粘贴,该选项已被移除。
