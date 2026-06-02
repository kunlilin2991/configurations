-- keymaps.lua —— 移植自 vimrc(leader = ";",在 init.lua 设置)
-- 原则:与 LazyVim 默认键位冲突处,一律以 vimrc 习惯为准。
-- 本文件在 LazyVim 默认键位之后加载,因此这里的映射会覆盖默认。
local map = vim.keymap.set

-- ── 行首/行尾(vimrc: le→$  lb→0)
map({ "n", "x", "o" }, "le", "$", { desc = "行尾" })
map({ "n", "x", "o" }, "lb", "0", { desc = "行首" })

-- ── 系统剪贴板(vimrc: <leader>y / <leader>p)
map({ "n", "x" }, "<leader>y", '"+y', { desc = "复制到系统剪贴板" })
map({ "n", "x" }, "<leader>p", '"+p', { desc = "粘贴自系统剪贴板" })

-- ── 保存(vimrc)
map("n", "<leader>W", "<cmd>w !sudo tee % > /dev/null<cr>", { desc = "sudo 保存" })

-- ── 搜索相关(vimrc)
map("n", "<leader>/", "<cmd>nohlsearch<cr>", { desc = "清除搜索高亮" })
map("n", "<leader>.", ":<up><cr>", { desc = "重复上一条命令行命令" })
map("n", "<leader>m", "%", { desc = "结对符之间跳转" })

-- ── buffer 切换(vimrc: <leader>1..9 选 tab)
for i = 1, 9 do
  map("n", "<leader>" .. i, "<cmd>BufferLineGoToBuffer " .. i .. "<cr>", { desc = "buffer " .. i })
end

-- ── 文件树(vimrc: <leader>n);LazyVim 默认 <leader>e 仍可用
map("n", "<leader>n", "<cmd>Neotree toggle<cr>", { desc = "文件树" })

-- ── 模糊找文件(vimrc: ctrlp <leader>f),picker 无关
map("n", "<leader>f", function()
  if _G.LazyVim and LazyVim.pick then
    LazyVim.pick("files")()
  else
    pcall(vim.cmd, "Telescope find_files")
  end
end, { desc = "查找文件" })

-- ── 跳定义(现走 gtags;<C-\>=定义 / <C-]>=查引用 由 tags.lua 按 buffer 绑)
--    <C-t> 回跳、<C-o>/<C-i> jumplist 都是 neovim 原生,无需配置。
map("n", "<leader>jd", function()
  vim.cmd("cstag " .. vim.fn.expand("<cword>"))
end, { silent = true, desc = "跳到定义(gtags)" })
map("n", "<leader>jc", function()
  vim.cmd("cscope find g " .. vim.fn.expand("<cword>"))
end, { silent = true, desc = "跳到定义(多个时列出)" })

-- ── 注释(vimrc: nerdcommenter):;cc 注释 / ;cu 取消,见 plugins/editor.lua(Comment.nvim)
--    原生 gcc(行)/ gc(选区)的 toggle 仍可用。

-- ── gtags 符号查询(vimrc: gutentags_plus 的 GscopeFind 全套习惯)
--    s 符号 / g 定义 / c 调用者 / t 文本 / e egrep / d 被调用 / a 赋值 / z
local gscope_word = { gs = "s", gg = "g", gc = "c", gt = "t", ge = "e", gd = "d", ga = "a", gz = "z" }
for lhs, q in pairs(gscope_word) do
  map("n", "<leader>" .. lhs, function()
    vim.cmd("GscopeFind " .. q .. " " .. vim.fn.expand("<cword>"))
  end, { silent = true, desc = "gtags 查 " .. q })
end
-- f 找文件 / i 找包含此文件的文件(用 <cfile>)
map("n", "<leader>gf", function()
  vim.cmd("GscopeFind f " .. vim.fn.expand("<cfile>"))
end, { silent = true, desc = "gtags 找文件" })
map("n", "<leader>gi", function()
  vim.cmd("GscopeFind i " .. vim.fn.expand("<cfile>"))
end, { silent = true, desc = "gtags 找包含者" })
