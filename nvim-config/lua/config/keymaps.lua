-- Keymaps 按键映射
-- 迁移自 kunlynn 的 vimrc
-- Leader 键是 ;

local map = vim.keymap.set

-- ========== 行首行尾（原 le/lb）==========
-- 原 vimrc: nmap le $  /  nmap lb 0
map("n", "le", "$", { desc = "跳到行尾" })
map("n", "lb", "0", { desc = "跳到行首" })
-- visual 模式下也支持
map("v", "le", "$", { desc = "选到行尾" })
map("v", "lb", "0", { desc = "选到行首" })

-- ========== 系统剪贴板 ==========
-- 原 vimrc: map <leader>y "+y  /  map <leader>p "+p
map({ "n", "v" }, "<leader>y", '"+y', { desc = "复制到系统剪贴板" })
map({ "n", "v" }, "<leader>p", '"+p', { desc = "从系统剪贴板粘贴" })

-- ========== 保存/退出 ==========
-- 原 vimrc: ;w 保存, ;wq 保存退出, ;Q 关闭 buffer
-- map("n", "<leader>w", "<cmd>w<CR>", { desc = "保存" })
-- map("n", "<leader>wq", "<cmd>wa<CR><cmd>q<CR>", { desc = "保存全部并退出" })
-- map("n", "<leader>Q", "<cmd>bd<CR>", { desc = "关闭当前 buffer" })
-- sudo 保存（需要 suda.vim 插件或手动方式）
map("n", "<leader>W", "<cmd>w !sudo tee % > /dev/null<CR>", { desc = "sudo 保存" })

-- ========== 窗口切换 ==========
-- 原 vimrc: wn 遍历, ;wl 右, ;wr 左, ;wj 下, ;wk 上
-- 注意：原配置中 ;wr 映射到 <C-W>h（左），;wl 映射到 <C-W>l（右）
map("n", "wn", "<C-W><C-W>", { desc = "遍历窗口" })
map("n", "<leader>wl", "<C-W>l", { desc = "跳到右窗口" })
map("n", "<leader>wr", "<C-W>h", { desc = "跳到左窗口" })
map("n", "<leader>wj", "<C-W>j", { desc = "跳到下窗口" })
map("n", "<leader>wk", "<C-W>k", { desc = "跳到上窗口" })

-- ========== 搜索相关 ==========
-- 原 vimrc: ;/ 清除搜索高亮, ;. 重复上次命令, ;m 跳转匹配括号
map("n", "<leader>/", "<cmd>let @/=''<CR>", { desc = "清除搜索高亮" })
map("n", "<leader>.", ":<UP><CR>", { desc = "重复上次命令" })
map("n", "<leader>m", "%", { desc = "跳转匹配括号" })

-- ========== Buffer 切换 ==========
-- 原 vimrc: [b 上一个, ]b 下一个
map("n", "[b", "<cmd>bp<CR>", { desc = "上一个 buffer" })
map("n", "]b", "<cmd>bn<CR>", { desc = "下一个 buffer" })

-- ;1 ~ ;9 跳转到对应 buffer（通过 bufferline 插件实现）
for i = 1, 9 do
  map("n", "<leader>" .. i, function()
    require("bufferline").go_to(i, true)
  end, { desc = "跳转到 buffer " .. i })
end

-- ========== 文件树（Neo-tree 替代 NERDTree）==========
-- 原 vimrc: ;n 切换文件树
map("n", "<leader>n", "<cmd>Neotree toggle<CR>", { desc = "切换文件树" })

-- ========== 文件查找（Telescope 替代 CtrlP）==========
-- 原 vimrc: ;f 查找文件
map("n", "<leader>f", "<cmd>Telescope find_files<CR>", { desc = "查找文件" })

-- ========== 代码跳转（LSP 替代 YCM）==========
-- 原 vimrc: ;jc 跳到声明, ;jd 跳到定义
map("n", "<leader>jc", vim.lsp.buf.declaration, { desc = "跳到声明" })
map("n", "<leader>jd", vim.lsp.buf.definition, { desc = "跳到定义" })
-- IDE 风格快捷键: Ctrl+\ 跳到定义, Ctrl+T 返回, Ctrl+O/I 跳转栈前进后退
map("n", "<C-\\>", vim.lsp.buf.definition, { desc = "跳到定义" })
map("n", "<C-t>", "<C-t>", { desc = "从定义返回 (tag 栈)" })
map("n", "<C-o>", "<C-o>", { desc = "跳转栈后退" })
map("n", "<C-i>", "<C-i>", { desc = "跳转栈前进" })

-- ========== 头文件/源文件切换（clangd 替代 a.vim / fswitch）==========
-- 原 vimrc: ;a 头文件切换, ;sw 声明定义切换
map("n", "<leader>a", "<cmd>ClangdSwitchSourceHeader<CR>", { desc = "头文件/源文件切换" })
map("n", "<leader>sw", "<cmd>ClangdSwitchSourceHeader<CR>", { desc = "头文件/源文件切换" })

-- ========== 注释（Comment.nvim 替代 nerdcommenter）==========
-- LazyVim 默认使用 mini.comment 或 Comment.nvim
-- gcc 注释当前行, gc 注释选中区域（这是默认行为）
-- 为了保留你的 ;cc 和 ;cu 习惯：
map("n", "<leader>cc", "gcc", { remap = true, desc = "注释当前行" })
map("v", "<leader>cc", "gc", { remap = true, desc = "注释选中区域" })
-- ;cu 取消注释（再次 toggle 即可）
map("n", "<leader>cu", "gcc", { remap = true, desc = "取消注释当前行" })
map("v", "<leader>cu", "gc", { remap = true, desc = "取消注释选中区域" })

-- ========== 结构大纲（Trouble/symbols-outline 替代 tagbar）==========
-- 原 vimrc: ;tb 或 F9 切换 tagbar
map("n", "<leader>tb", "<cmd>Trouble symbols toggle<CR>", { desc = "符号大纲" })
map("n", "<F9>", "<cmd>Trouble symbols toggle<CR>", { desc = "符号大纲" })

-- ========== Undo 树（undotree 替代 gundo）==========
-- 原 vimrc: ;su 切换 undo 树
map("n", "<leader>su", "<cmd>UndotreeToggle<CR>", { desc = "Undo 树" })

-- ========== TODO/FIXME 跳转（todo-comments 替代 TaskList）==========
-- 原 vimrc: ;td 打开 TaskList
map("n", "<leader>td", "<cmd>TodoTelescope<CR>", { desc = "搜索 TODO/FIXME" })

-- ========== 对齐（EasyAlign）==========
-- 原 vimrc: visual 模式下 Enter 触发 EasyAlign
map("v", "<CR>", "<Plug>(EasyAlign)", { desc = "EasyAlign 对齐" })

-- ========== 粘贴模式 ==========
-- 原 vimrc: ;sp 切换粘贴模式
-- Neovim 中粘贴模式基本不需要了，但保留习惯
map("n", "<leader>sp", "<cmd>set invpaste<CR>", { desc = "切换粘贴模式" })
