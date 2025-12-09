-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- ~/.config/nvim/lua/config/keymaps.lua
local map = vim.keymap.set

-- 行首/行尾快速跳转
-- 对应原 .vimrc: nmap le $, nmap lb 0
map("n", "le", "$", { desc = "Jump to end of line" })
map("n", "lb", "0", { desc = "Jump to beginning of line" })

-- 窗口导航
-- 对应原 .vimrc: wn, <leader>wl/r/j/k
map("n", "wn", "<C-w><C-w>", { desc = "Cycle through windows" })
map("n", "<leader>wl", "<C-w>l", { desc = "Go to right window" })
map("n", "<leader>wr", "<C-w>h", { desc = "Go to left window" })
map("n", "<leader>wj", "<C-w>j", { desc = "Go to window below" })
map("n", "<leader>wk", "<C-w>k", { desc = "Go to window above" })

-- 搜索与命令历史
-- 对应原 .vimrc: <leader>/ (clear highlight), <leader>. (repeat last Ex command), <leader>m (% match)
map("n", "<leader>/", ':let @/=""<CR>', { desc = "Clear search highlights" })
map("n", "<leader>m", "%", { desc = "Jump to matching bracket" })
