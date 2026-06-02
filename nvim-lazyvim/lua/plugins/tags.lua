-- 全 gtags(GNU GLOBAL)单源:跳定义 / 查引用 / 补全 全靠它,带原生增量(global -u)。
-- 不用 ctags、不用 LSP。索引集中放 ~/.cache/tags/<打平的工程路径>/,不污染工程树。
--   * 普通工程:由 gutentags 负责(仅 gtags_cscope 模块),保存即增量。
--   * Linux 内核:特殊处理 —— 单 arch + `make gtags` + move 到 cache + 自动清孤儿 + global -u 增量。
--
-- 导航键(buffer-local,仅代码 buffer):
--   <C-]> 查定义(:cstag,压 tagstack)、<C-\> 查引用、<C-t> 弹栈、<C-o>/<C-i> jumplist —— 后三个原生。
--
-- 系统依赖:GNU GLOBAL(gtags / global / gtags-cscope)。

-- ╔══════════════════════════════════════════════════════════════════════╗
-- ║  ▼▼▼  改这里:内核索引的目标架构(arch/<ARCH>),其余 arch 全部跳过  ▼▼▼  ║
local KERNEL_ARCH = "arm64"
-- ║  ▲▲▲  改这里(可改 "x86" / "arm" / "riscv" / "loongarch" 等)▲▲▲      ║
-- ╚══════════════════════════════════════════════════════════════════════╝

local CACHE = vim.fn.expand("~/.cache/tags")

-- 把工程根打平成 cache 子目录(复刻 gutentags 命名,两边风格统一)
-- /home/l00024352/linux  →  ~/.cache/tags/home-l00024352-linux
local function cache_dir_for(root)
  local p = root:gsub("/+$", "") .. "/" -- stripslash + 末尾 '/'
  p = p:gsub("[/\\:]", "-"):gsub(" ", "_") -- tr('\/: ', '---_')
  p = p:gsub("^%-", "") -- 去开头 '-'(来自根的前导 '/')
  p = p:gsub("[-_]+$", "") -- 去末尾 '-'/'_'
  return CACHE .. "/" .. p
end

-- ── 内核根检测:有 arch/ + Kbuild + Makefile(前几行含 VERSION/PATCHLEVEL) ──
local kroot_cache = {}
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

local function kernel_root(path)
  if path == nil or path == "" then
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

-- 工程根:内核根优先,否则向上找工程标志(与 gutentags 一致)
local MARKERS = { ".root", ".svn", ".git", ".hg", ".project" }
local function project_root(path)
  local k = kernel_root(path)
  if k then
    return k
  end
  if path == nil or path == "" then
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

-- gutentags 门控:内核树返回 0(关掉 gutentags,改用下面的 make 索引)
function _G._kernel_gutentags_gate(path)
  return kernel_root(path) == nil and 1 or 0
end

-- ── 内核索引(单 arch,集中 cache) ──
local indexing = {} -- root -> true(运行中,防重叠)
local dirty = {} -- root -> true(运行期间又保存,收尾再增量一次)
local incr_update -- forward

local function index_done(root)
  local d = cache_dir_for(root)
  return vim.fn.filereadable(d .. "/GTAGS") == 1 and vim.fn.filereadable(d .. "/.kindex.ok") == 1
end

-- 删内核根下游离的 GTAGS/GRTAGS/GPATH(权威副本在 cache;清理中断残留)
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

-- 全量:make gtags 写内核根 → mkdir cache → move 三件套过去 → 写完成标记
local function full_build(root, quiet)
  if indexing[root] then
    if not quiet then
      vim.notify("内核索引已在进行中:" .. root, vim.log.levels.WARN)
    end
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

-- 增量:global -u 只重扫改动文件,只写 cache(GTAGSDBPATH),绝不碰内核树
incr_update = function(root)
  if indexing[root] then
    dirty[root] = true
    return
  end
  if not index_done(root) then
    full_build(root, true)
    return
  end
  indexing[root] = true
  local d = cache_dir_for(root)
  vim.fn.jobstart({ "global", "-u" }, {
    cwd = root,
    env = { GTAGSROOT = root, GTAGSDBPATH = d },
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

-- 内核 buffer:接线到 cache 的库 + 清孤儿 + 缺则全量
local function setup_kernel_buf(buf)
  local root = kernel_root(vim.api.nvim_buf_get_name(buf))
  if not root then
    return
  end
  local d = cache_dir_for(root)
  vim.api.nvim_buf_call(buf, function()
    -- 供 GscopeFind(<leader>g*)定位库
    vim.b.gutentags_root = root
    vim.b.gutentags_files = { gtags_cscope = d .. "/GTAGS" }
  end)
  clean_orphans(root)
  if not index_done(root) then
    full_build(root, false)
  end
end

-- ── 导航:原生 cscope 接 gtags(buffer-local 键,栈行为原生) ──
local cscope_added = {} -- gtags 文件路径 -> 已 cs add
local function ensure_cscope(gtags, root)
  if cscope_added[gtags] then
    return true
  end
  if vim.fn.filereadable(gtags) ~= 1 then
    return false
  end
  vim.env.GTAGSROOT = root
  vim.env.GTAGSDBPATH = vim.fn.fnamemodify(gtags, ":h")
  local ok = pcall(vim.cmd, "cscope add " .. vim.fn.fnameescape(gtags) .. " " .. vim.fn.fnameescape(root))
  if ok then
    cscope_added[gtags] = true
  end
  return ok
end

local function setup_nav(buf)
  if vim.b[buf].gtags_nav_done then
    return
  end
  local root = project_root(vim.api.nvim_buf_get_name(buf))
  if not root then
    return
  end
  local d = cache_dir_for(root)
  -- 供 global -c 补全源读取
  vim.b[buf].gtags_root = root
  vim.b[buf].gtags_dbpath = d
  if not ensure_cscope(d .. "/GTAGS", root) then
    return -- 库还没生成,等建好后下次 BufEnter 再绑
  end
  local function bmap(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { buffer = buf, silent = true, desc = desc })
  end
  bmap("<C-]>", function()
    vim.cmd("cstag " .. vim.fn.expand("<cword>"))
  end, "gtags 查定义")
  bmap("<C-\\>", function()
    vim.cmd("cscope find s " .. vim.fn.expand("<cword>"))
  end, "gtags 查引用")
  vim.b[buf].gtags_nav_done = true
end

return {
  {
    "ludovicchabant/vim-gutentags",
    dependencies = { "skywind3000/gutentags_plus" },
    event = { "BufReadPost", "BufNewFile" },
    init = function()
      -- 普通工程:gutentags 只用 gtags_cscope 模块(去掉 ctags)
      vim.g.gutentags_project_root = { ".root", ".svn", ".git", ".hg", ".project" }
      vim.g.gutentags_modules = { "gtags_cscope" }
      vim.g.gutentags_cache_dir = CACHE
      vim.g.gutentags_plus_nomap = 1 -- 用 keymaps.lua 的 <leader>g* 习惯
      vim.g.gutentags_define_advanced_commands = 1
      vim.g.gutentags_generate_on_write = 1 -- 保存即增量(普通工程)
      if vim.fn.isdirectory(CACHE) == 0 then
        vim.fn.mkdir(CACHE, "p")
      end

      -- 内核树关掉 gutentags(避免整树/多 arch),改走 make 索引
      vim.cmd([[
        function! KernelTagsGate(path) abort
          return v:lua._kernel_gutentags_gate(a:path)
        endfunction
      ]])
      vim.g.gutentags_init_user_func = "KernelTagsGate"

      -- cscope 用 gtags-cscope 当后端;引用类多结果进 quickfix
      vim.o.cscopeprg = "gtags-cscope"
      vim.opt.cscopequickfix = "s-,c-,d-,i-,t-,e-,a-"

      local grp = vim.api.nvim_create_augroup("GtagsKernel", { clear = true })

      vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
        group = grp,
        callback = function(ev)
          setup_kernel_buf(ev.buf)
          setup_nav(ev.buf)
        end,
        desc = "gtags:内核接线/索引 + 导航键",
      })

      -- 库建好后(首次打开时还没绑上)在 BufEnter 补绑导航键
      vim.api.nvim_create_autocmd("BufEnter", {
        group = grp,
        callback = function(ev)
          setup_nav(ev.buf)
        end,
        desc = "gtags:补绑导航键",
      })

      -- 内核树:保存即后台增量(普通工程由 gutentags 自己处理)
      vim.api.nvim_create_autocmd("BufWritePost", {
        group = grp,
        callback = function(ev)
          local root = kernel_root(vim.api.nvim_buf_get_name(ev.buf))
          if root then
            incr_update(root)
          end
        end,
        desc = "gtags:内核保存增量(global -u)",
      })

      -- :KernelIndex —— 当前文件所属内核根强制全量重建
      vim.api.nvim_create_user_command("KernelIndex", function()
        local root = kernel_root(vim.api.nvim_buf_get_name(0))
        if not root then
          vim.notify("当前文件不在内核树中", vim.log.levels.WARN)
          return
        end
        full_build(root, false)
      end, { desc = "全量重建内核 gtags 索引(单 arch=" .. KERNEL_ARCH .. ")" })
    end,
  },
}
