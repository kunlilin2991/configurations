-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- 到行首和行尾
vim.keymap.set("n", "le", "$", { noremap = true, silent = true })
vim.keymap.set("n", "lb", "0", { noremap = true, silent = true })

-- 块选择替换为leader v，不再是默认的Ctrl v
vim.keymap.set("n", "<leader>v", "<C-v>", { noremap = true, silent = true })

-- 窗口切换（等价 nnoremap）
vim.keymap.set("n", "wn", "<C-w><C-w>", { desc = "Next window" })
vim.keymap.set("n", "<leader>wl", "<C-w>l", { desc = "Window right" })
vim.keymap.set("n", "<leader>wr", "<C-w>h", { desc = "Window left" })
vim.keymap.set("n", "<leader>wj", "<C-w>j", { desc = "Window down" })
vim.keymap.set("n", "<leader>wk", "<C-w>k", { desc = "Window up" })
-- 清除搜索高亮
vim.keymap.set(
  "n",
  "<leader>/",
  function()
    vim.fn.setreg("/", "")
    vim.cmd("nohlsearch")
  end,
  { desc = "Clear search highlight" }
)

-- 复制到系统剪贴板
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
-- 整行复制
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Yank line to system clipboard" })
-- 从系统剪贴板粘贴
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from system clipboard" })
-- 显式删除并 yank
vim.keymap.set({ "n", "v" }, "<leader>d", "d", { desc = "Delete with yank" })

-- Flash 实现快速跳转 easymotion的功能
local flash = require("flash")
-- word motions
vim.keymap.set("n", "<leader><leader>w", function()
  flash.jump({
    search = { mode = "forward" },
    pattern = "\\<\\w",
  })
end, { desc = "Flash EasyMotion w" })

vim.keymap.set("n", "<leader><leader>b", function()
  flash.jump({
    search = { mode = "backward" },
    pattern = "\\<\\w",
  })
end, { desc = "Flash EasyMotion b" })

vim.keymap.set("n", "<leader><leader>e", function()
  flash.jump({
    search = { mode = "forward" },
    pattern = "\\w\\>",
  })
end, { desc = "Flash EasyMotion e" })
-- f / F / t / T
vim.keymap.set({ "n", "x", "o" }, "<leader><leader>f", function()
  flash.jump({ search = { mode = "forward" } })
end, { desc = "Flash EasyMotion f" })

vim.keymap.set({ "n", "x", "o" }, "<leader><leader>F", function()
  flash.jump({ search = { mode = "backward" } })
end, { desc = "Flash EasyMotion F" })

vim.keymap.set({ "n", "x", "o" }, "<leader><leader>t", function()
  flash.jump({
    search = { mode = "forward" },
    jump = { offset = -1 },
  })
end, { desc = "Flash EasyMotion t" })

vim.keymap.set({ "n", "x", "o" }, "<leader><leader>T", function()
  flash.jump({
    search = { mode = "backward" },
    jump = { offset = 1 },
  })
end, { desc = "Flash EasyMotion T" })

-- j / k 行跳转
vim.keymap.set("n", "<leader><leader>j", function()
  flash.jump({
    search = { mode = "forward" },
    pattern = "^",
  })
end, { desc = "Flash EasyMotion j" })

vim.keymap.set("n", "<leader><leader>k", function()
  flash.jump({
    search = { mode = "backward" },
    pattern = "^",
  })
end, { desc = "Flash EasyMotion k" })

-- Mini Comment 注释切换
vim.keymap.set({ "n", "v" }, "<leader>cc", function()
  require("mini.comment").toggle()
end, { desc = "Comment toggle" })
vim.keymap.set({ "n", "v" }, "<leader>cu", function()
  require("mini.comment").toggle({ force = false })
end, { desc = "Comment uncomment" })

-- 只在vscode-neovim中生效的功能
vim.keymap.set({ "n", "v" }, "<leader>cu", function()
  require("mini.comment").toggle({ force = false })
end, { desc = "Comment uncomment" })
-- 窗口切换
if vim.g.vscode then
  vim.keymap.set("n", "<leader>wh", function()
    vim.fn.VSCodeNotify("workbench.action.focusLeftGroup")
  end)
  vim.keymap.set("n", "<leader>wj", function()
    vim.fn.VSCodeNotify("workbench.action.focusBelowGroup")
  end)
  vim.keymap.set("n", "<leader>wk", function()
    vim.fn.VSCodeNotify("workbench.action.focusAboveGroup")
  end)
  vim.keymap.set("n", "<leader>wl", function()
    vim.fn.VSCodeNotify("workbench.action.focusRightGroup")
  end)
end

-- 缩进功能
if vim.g.vscode then
  vim.keymap.set("n", "<leader>i", function()
    vim.fn.VSCodeNotify("editor.action.reindentlines")
  end, { desc = "Reindent line (VSCode)" })

  vim.keymap.set("v", "<leader>i", function()
    vim.fn.VSCodeNotify("editor.action.reindentlines")
  end, { desc = "Reindent selection (VSCode)" })
end
if vim.g.vscode then
	vim.keymap.set("n", "==", function()
	  local line = vim.fn.line(".")
	  local file = vim.fn.expand("%:p")

	  vim.fn.system({
		"clang-format",
		"-lines=" .. line .. ":" .. line,
		file,
	  })

	  -- 重新加载 buffer
	  vim.cmd("checktime")
	end, { desc = "Format current line (clang-format)" })
	vim.keymap.set("v", "==", function()
	  local start = vim.fn.line("'<")
	  local finish = vim.fn.line("'>")
	  local file = vim.fn.expand("%:p")

	  vim.fn.system({
		"clang-format",
		"-lines=" .. start .. ":" .. finish,
		file,
	  })

	  vim.cmd("checktime")
	end, { desc = "Format selected lines (clang-format)" })
end
