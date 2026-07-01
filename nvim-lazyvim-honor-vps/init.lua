-- nvim-lazyvim/init.lua
-- leader 必须在加载任何插件之前设置(与 vimrc 一致:leader = ";")
vim.g.mapleader = ";"
vim.g.maplocalleader = ";"

require("config.lazy")
