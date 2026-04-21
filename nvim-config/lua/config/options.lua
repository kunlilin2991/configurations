-- Options 基础选项
-- 迁移自 kunlynn 的 vimrc

-- Leader 键设置为 ;
-- 注意：这必须在 lazy.lua 加载之前设置，LazyVim 会在 init.lua 中处理
-- 这里再次确认
vim.g.mapleader = ";"
vim.g.maplocalleader = ";"

-- ========== Tab 和缩进 ==========
vim.opt.tabstop = 4         -- tab 显示宽度
vim.opt.softtabstop = 4     -- 插入 tab 时的宽度
vim.opt.shiftwidth = 4      -- 自动缩进宽度
vim.opt.expandtab = true    -- tab 转空格
vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

-- ========== 搜索 ==========
vim.opt.hlsearch = true     -- 高亮搜索结果
vim.opt.incsearch = true    -- 实时搜索
vim.opt.ignorecase = true   -- 忽略大小写
vim.opt.smartcase = true    -- 有大写时区分大小写
vim.opt.showmatch = true    -- 匹配括号高亮

-- ========== 显示 ==========
vim.opt.number = true           -- 显示行号
vim.opt.relativenumber = true   -- 相对行号
vim.opt.cursorline = true       -- 高亮当前行
vim.opt.cursorcolumn = true     -- 高亮当前列
vim.opt.scrolloff = 15          -- 光标距顶/底保留行数
vim.opt.showmode = true         -- 显示模式
vim.opt.showcmd = true          -- 显示命令
vim.opt.ruler = true            -- 状态栏显示光标位置
vim.opt.laststatus = 2          -- 始终显示状态栏

-- ========== 编码 ==========
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

-- ========== 折叠 ==========
vim.opt.foldenable = true
vim.opt.foldmethod = "manual"   -- 手动折叠

-- ========== 鼠标 ==========
vim.opt.mouse = "a"

-- ========== 其他 ==========
vim.opt.backspace = "indent,eol,start"  -- 退格键行为
vim.opt.wildmenu = true                 -- 命令补全菜单
vim.opt.hidden = true                   -- 允许隐藏未保存 buffer
vim.opt.spelllang = "en_us"             -- 拼写检查语言

-- ========== Diagnostic（诊断提示）==========
-- 关闭行尾错误提示（virtual text）
vim.diagnostic.config({
  virtual_text = false,
})
