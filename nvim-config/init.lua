-- init.lua - LazyVim 入口
-- Leader 键必须在任何插件加载之前设置
vim.g.mapleader = ";"
vim.g.maplocalleader = ";"

-- 启动 lazy.nvim
require("config.lazy")
