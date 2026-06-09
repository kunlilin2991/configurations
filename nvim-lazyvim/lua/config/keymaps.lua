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

-- ── 快速跳转(vimrc: easymotion → flash.nvim;w/W 词首前/后,f/F 字符前/后)
-- 字符查找(输入字符后出标签):;;f 向前 / ;;F 向后
map({ "n", "x", "o" }, "<leader><leader>f", function()
  require("flash").jump({ search = { forward = true, wrap = false } })
end, { desc = "flash 字符(向前)" })
map({ "n", "x", "o" }, "<leader><leader>F", function()
  require("flash").jump({ search = { forward = false, wrap = false } })
end, { desc = "flash 字符(向后)" })

-- 词首跳转:两段式双字符标签(flash 官方 HopWord 配方,词多于标签也能全标)
-- forward=true 只标光标之后的词首;false 只标之前的
local function flash_word(forward)
  local Flash = require("flash")
  local function format(opts)
    return {
      { opts.match.label1, "FlashMatch" },
      { opts.match.label2, "FlashLabel" },
    }
  end
  Flash.jump({
    search = { mode = "search", forward = forward, wrap = false },
    label = { after = false, before = { 0, 0 }, uppercase = false, format = format },
    pattern = [[\<]],
    action = function(match, state)
      state:hide()
      Flash.jump({
        search = { max_length = 0 },
        highlight = { matches = false },
        label = { format = format },
        matcher = function(win)
          return vim.tbl_filter(function(m)
            return m.label == match.label and m.win == win
          end, state.results)
        end,
        labeler = function(matches)
          for _, m in ipairs(matches) do
            m.label = m.label2
          end
        end,
      })
    end,
    labeler = function(matches, state)
      local labels = state:labels()
      for m, match in ipairs(matches) do
        match.label1 = labels[math.floor((m - 1) / #labels) + 1]
        match.label2 = labels[(m - 1) % #labels + 1]
        match.label = match.label1
      end
    end,
  })
end
map({ "n", "x", "o" }, "<leader><leader>w", function()
  flash_word(true)
end, { desc = "flash 词首(向前)" })
map({ "n", "x", "o" }, "<leader><leader>W", function()
  flash_word(false)
end, { desc = "flash 词首(向后)" })

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

-- ── 跳定义(走 gtags 的 tagfunc;<C-]>=定义 原生、<C-\>=查引用 由 tags.lua 按 buffer 绑)
--    <C-t> 回跳、<C-o>/<C-i> jumplist 都是 neovim 原生,无需配置。
map("n", "<leader>jd", function()
  vim.cmd("tag " .. vim.fn.expand("<cword>"))
end, { silent = true, desc = "跳到定义(gtags)" })
map("n", "<leader>jc", function()
  vim.cmd("tselect " .. vim.fn.expand("<cword>"))
end, { silent = true, desc = "跳到定义(多个时列出)" })

-- ── 注释(vimrc: nerdcommenter):;cc 注释 / ;cu 取消,见 plugins/editor.lua(Comment.nvim)
--    原生 gcc(行)/ gc(选区)的 toggle 仍可用。

-- ── gtags 查询(直调 global → quickfix;neovim 已移除 cscope,故不再用 GscopeFind)
--    定义 / 引用 / 符号 / 文本 / 文件;callers/callees 等 cscope 专有功能不再提供
map("n", "<leader>gg", function()
  _G.gtags_query("-d")
end, { silent = true, desc = "gtags 定义" })
map("n", "<leader>gr", function()
  _G.gtags_query("-r")
end, { silent = true, desc = "gtags 引用" })
map("n", "<leader>gs", function()
  _G.gtags_query("-s")
end, { silent = true, desc = "gtags 符号" })
map("n", "<leader>gt", function()
  _G.gtags_query("-g")
end, { silent = true, desc = "gtags 文本" })
map("n", "<leader>gf", function()
  _G.gtags_query("-P")
end, { silent = true, desc = "gtags 文件" })
