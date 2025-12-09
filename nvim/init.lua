-- ~/.config/nvim/init.lua

-- 定义 <Leader> 键为分号（;），替代默认的反斜杠（\）
vim.g.mapleader = ";"

-- 加载基础配置
require("config.lazy")
require("config.options")
require("config.keymaps")

-- 启用插件系统（lazy.nvim）
require("plugins")
