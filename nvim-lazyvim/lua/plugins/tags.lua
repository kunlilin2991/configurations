-- 全 gtags 单源(纯 Lua 直调 GNU GLOBAL)。
-- Neovim 已移除 cscope,vim-gutentags 的 gtags_cscope 模块会硬性 throw,故不用 gutentags/gutentags_plus。
--   * 跳定义:tagfunc 调 `global -d`(<C-]>/:tag/<C-t>/jumplist 全原生)
--   * 查引用/符号/文本/文件:`global -r/-s/-g/-P` → quickfix(<C-\> 查引用;<leader>g* 见 keymaps.lua)
--   * 补全:`global -c`(见 lua/blink_global.lua)
--   * 索引集中 ~/.cache/tags/<打平的工程路径>/,不污染工程树;保存即 `global -u` 增量
--   * 普通工程:`gtags` 建库;Linux 内核:`make ARCH=<arch> gtags` 单 arch + move 到 cache + 清孤儿
--
-- 本文件无插件依赖(逻辑在模块加载时即注册 autocmd/命令),return 空 spec。
-- 系统依赖:GNU GLOBAL(gtags / global)。

-- ╔══════════════════════════════════════════════════════════════════════╗
-- ║  ▼▼▼  改这里:内核索引的目标架构(arch/<ARCH>),其余 arch 全部跳过  ▼▼▼  ║
local KERNEL_ARCH = "arm64"
-- ║  ▲▲▲  改这里(可改 "x86" / "arm" / "riscv" / "loongarch" 等)▲▲▲      ║
-- ╚══════════════════════════════════════════════════════════════════════╝

local CACHE = vim.fn.expand("~/.cache/tags")

-- 工程根 → cache 子目录(打平命名):/home/u/linux → ~/.cache/tags/home-u-linux
local function cache_dir_for(root)
  local p = root:gsub("/+$", "") .. "/"
  p = p:gsub("[/\\:]", "-"):gsub(" ", "_")
  p = p:gsub("^%-", ""):gsub("[-_]+$", "")
  return CACHE .. "/" .. p
end

-- 内核根:有 arch/ + Kbuild + Makefile(前几行含 VERSION/PATCHLEVEL)
local function is_kernel_root(dir)
  if vim.fn.isdirectory(dir .. "/arch") == 0 then
    return false
  end
  if vim.fn.filereadable(dir .. "/Kbuild") == 0 then
    return false
  end
  local mk = dir .. "/Makefile"
  if vim.fn.filereadable(mk) == 0 then
    return false
  end
  local head = table.concat(vim.fn.readfile(mk, "", 6), "\n")
  return head:match("VERSION%s*=") ~= nil and head:match("PATCHLEVEL%s*=") ~= nil
end

local kroot_cache = {}
local function kernel_root(path)
  if not path or path == "" then
    return nil
  end
  local dir = vim.fn.fnamemodify(path, ":p")
  if vim.fn.isdirectory(dir) == 0 then
    dir = vim.fn.fnamemodify(dir, ":h")
  end
  if kroot_cache[dir] ~= nil then
    return kroot_cache[dir] or nil
  end
  local cur = dir
  while cur and cur ~= "" do
    if is_kernel_root(cur) then
      kroot_cache[dir] = cur
      return cur
    end
    local parent = vim.fn.fnamemodify(cur, ":h")
    if parent == cur then
      break
    end
    cur = parent
  end
  kroot_cache[dir] = false
  return nil
end

-- 工程根:内核根优先,否则向上找工程标志
local MARKERS = { ".root", ".svn", ".git", ".hg", ".project" }
local function project_root(path)
  local k = kernel_root(path)
  if k then
    return k
  end
  if not path or path == "" then
    return nil
  end
  local dir = vim.fn.fnamemodify(path, ":p:h")
  while dir and dir ~= "" do
    for _, m in ipairs(MARKERS) do
      if vim.fn.isdirectory(dir .. "/" .. m) == 1 or vim.fn.filereadable(dir .. "/" .. m) == 1 then
        return dir
      end
    end
    local parent = vim.fn.fnamemodify(dir, ":h")
    if parent == dir then
      break
    end
    dir = parent
  end
  return nil
end

-- ── 跳定义:tagfunc 调 `global -d`(原生 tagstack/jumplist) ──
function _G.gtags_tagfunc(pattern, _flags, _info)
  local root, dbpath = vim.b.gtags_root, vim.b.gtags_dbpath
  if not (root and dbpath) then
    return nil
  end
  pattern = (pattern or ""):gsub("^%^", ""):gsub("%$$", "")
  local res = vim
    .system({ "global", "-a", "--result=grep", "-d", pattern }, {
      cwd = root,
      env = { GTAGSROOT = root, GTAGSDBPATH = dbpath },
      text = true,
    })
    :wait()
  if res.code ~= 0 or not res.stdout then
    return nil
  end
  local items = {}
  for line in res.stdout:gmatch("[^\r\n]+") do
    local file, lno = line:match("^(.-):(%d+):")
    if file then
      items[#items + 1] = { name = pattern, filename = file, cmd = lno }
    end
  end
  return items
end

-- ── 查询 → quickfix:flag = -r 引用 / -s 符号 / -g 文本 / -d 定义 / -P 文件 ──
function _G.gtags_query(flag)
  local word = vim.fn.expand("<cword>")
  local root, dbpath = vim.b.gtags_root, vim.b.gtags_dbpath
  if not (root and dbpath) then
    vim.notify("不在工程内,或 gtags 索引尚未建立", vim.log.levels.WARN)
    return
  end
  local path_mode = (flag == "-P")
  local args = { "global", "-a" }
  if not path_mode then
    table.insert(args, "--result=grep")
  end
  table.insert(args, flag)
  table.insert(args, word)
  local res = vim.system(args, { cwd = root, env = { GTAGSROOT = root, GTAGSDBPATH = dbpath }, text = true }):wait()
  local items = {}
  for line in (res.stdout or ""):gmatch("[^\r\n]+") do
    if path_mode then
      items[#items + 1] = { filename = line, lnum = 1, text = line }
    else
      local file, lno, text = line:match("^(.-):(%d+):(.*)$")
      if file then
        items[#items + 1] = { filename = file, lnum = tonumber(lno), text = text }
      end
    end
  end
  if #items == 0 then
    vim.notify("gtags 无结果: " .. word, vim.log.levels.INFO)
    return
  end
  vim.fn.setqflist({}, " ", { title = "gtags " .. flag .. " " .. word, items = items })
  if #items == 1 then
    vim.cmd("cfirst")
  else
    vim.cmd("copen")
  end
end

-- ── 建库 / 增量 ──
local indexing, dirty = {}, {}
local incr_update -- forward

local function index_done(root)
  local d = cache_dir_for(root)
  return vim.fn.filereadable(d .. "/GTAGS") == 1 and vim.fn.filereadable(d .. "/.kindex.ok") == 1
end

-- 内核全量遗留在根目录的 GTAGS/GRTAGS/GPATH(中断残留)→ 删除(权威副本在 cache)
local function clean_orphans(root)
  if indexing[root] then
    return
  end
  for _, f in ipairs({ "GTAGS", "GRTAGS", "GPATH" }) do
    local p = root .. "/" .. f
    if vim.fn.filereadable(p) == 1 then
      vim.fn.delete(p)
    end
  end
end

-- 内核全量:make gtags 写内核根 → mkdir cache → move 三件套 → 写标记
local function full_build(root, quiet)
  if indexing[root] then
    return
  end
  indexing[root] = true
  local d = cache_dir_for(root)
  vim.fn.delete(d .. "/.kindex.ok")
  if not quiet then
    vim.notify("内核索引中(全量,ARCH=" .. KERNEL_ARCH .. "):" .. root .. " …", vim.log.levels.INFO)
  end
  local sh = string.format(
    "make -C %s ARCH=%s -s gtags && mkdir -p %s && mv -f %s/GTAGS %s/GRTAGS %s/GPATH %s/",
    vim.fn.shellescape(root),
    KERNEL_ARCH,
    vim.fn.shellescape(d),
    vim.fn.shellescape(root),
    vim.fn.shellescape(root),
    vim.fn.shellescape(root),
    vim.fn.shellescape(d)
  )
  vim.fn.jobstart({ "sh", "-c", sh }, {
    on_exit = function(_, code)
      indexing[root] = nil
      if code == 0 then
        vim.fn.writefile({}, d .. "/.kindex.ok")
        if not quiet then
          vim.notify("内核索引完成:" .. d, vim.log.levels.INFO)
        end
      else
        vim.notify("内核索引失败(code " .. code .. "),确认已安装 GNU GLOBAL(gtags)", vim.log.levels.ERROR)
      end
      if dirty[root] then
        dirty[root] = nil
        incr_update(root)
      end
    end,
  })
end

-- 普通工程全量:gtags 直接把库写进 cache 子目录(cwd=root 决定索引范围)
local function normal_build(root, quiet)
  if indexing[root] then
    return
  end
  indexing[root] = true
  local d = cache_dir_for(root)
  vim.fn.mkdir(d, "p")
  vim.fn.delete(d .. "/.kindex.ok")
  if not quiet then
    vim.notify("建立 gtags 索引:" .. root .. " …", vim.log.levels.INFO)
  end
  vim.fn.jobstart({ "gtags", d }, {
    cwd = root,
    env = { GTAGSROOT = root },
    on_exit = function(_, code)
      indexing[root] = nil
      if code == 0 then
        vim.fn.writefile({}, d .. "/.kindex.ok")
        if not quiet then
          vim.notify("gtags 索引完成:" .. root, vim.log.levels.INFO)
        end
      else
        vim.notify("gtags 索引失败(code " .. code .. "),确认已安装 GNU GLOBAL(gtags)", vim.log.levels.ERROR)
      end
      if dirty[root] then
        dirty[root] = nil
        incr_update(root)
      end
    end,
  })
end

-- 增量:global -u 只重扫改动文件,只写 cache(两种工程通用)
incr_update = function(root)
  if indexing[root] then
    dirty[root] = true
    return
  end
  if not index_done(root) then
    return
  end
  indexing[root] = true
  vim.fn.jobstart({ "global", "-u" }, {
    cwd = root,
    env = { GTAGSROOT = root, GTAGSDBPATH = cache_dir_for(root) },
    on_exit = function(_, code)
      indexing[root] = nil
      if code ~= 0 then
        vim.notify("gtags 增量更新失败(global -u, code " .. code .. ")", vim.log.levels.WARN)
      end
      if dirty[root] then
        dirty[root] = nil
        incr_update(root)
      end
    end,
  })
end

local function index_root(root, quiet)
  if is_kernel_root(root) then
    full_build(root, quiet)
  else
    normal_build(root, quiet)
  end
end

-- ── buffer 接线:tagfunc + b:vars + <C-\> 查引用 + 缺库则建 ──
local function setup_nav(buf)
  if vim.b[buf].gtags_nav_done then
    return
  end
  local root = project_root(vim.api.nvim_buf_get_name(buf))
  if not root then
    return
  end
  vim.b[buf].gtags_root = root
  vim.b[buf].gtags_dbpath = cache_dir_for(root)
  vim.bo[buf].tagfunc = "v:lua.gtags_tagfunc" -- <C-]>/:tag/<C-t> 走 gtags
  vim.keymap.set("n", "<C-\\>", function()
    _G.gtags_query("-r")
  end, { buffer = buf, silent = true, desc = "gtags 查引用" })
  vim.b[buf].gtags_nav_done = true
  if is_kernel_root(root) then
    clean_orphans(root)
  end
  if not index_done(root) then
    index_root(root, false)
  end
end

-- ── 注册(模块加载即生效) ──
if vim.fn.isdirectory(CACHE) == 0 then
  vim.fn.mkdir(CACHE, "p")
end

local grp = vim.api.nvim_create_augroup("Gtags", { clear = true })
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  group = grp,
  callback = function(ev)
    setup_nav(ev.buf)
  end,
  desc = "gtags:接线 + 缺库则建",
})
vim.api.nvim_create_autocmd("BufWritePost", {
  group = grp,
  callback = function(ev)
    local root = project_root(vim.api.nvim_buf_get_name(ev.buf))
    if root then
      incr_update(root)
    end
  end,
  desc = "gtags:保存后 global -u 增量",
})

vim.api.nvim_create_user_command("GtagsIndex", function()
  local root = project_root(vim.api.nvim_buf_get_name(0))
  if not root then
    vim.notify("当前文件不在工程内", vim.log.levels.WARN)
    return
  end
  index_root(root, false)
end, { desc = "强制重建当前工程的 gtags 索引(内核为单 arch=" .. KERNEL_ARCH .. ")" })
vim.api.nvim_create_user_command("KernelIndex", "GtagsIndex", { desc = "同 :GtagsIndex(兼容旧名)" })

return {}
