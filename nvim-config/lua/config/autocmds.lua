-- Autocmds 自动命令
-- 在 LazyVim 完全加载后配置诊断

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    vim.diagnostic.config({
      virtual_text = false,     -- 关闭行尾错误提示
      signs = false,            -- 关闭左侧图标
      -- underline = false,    -- 保留下划线
      update_in_insert = false, -- 插入模式不更新诊断
    })
  end,
})

-- C/C++ 项目检测：打开 .c/.h 文件时自动生成 compile_commands.json
-- 缓存路径：~/.cache/clangd/<项目路径hash>/compile_commands.json
-- 自动执行，不污染项目目录
local _cc_auto_setup_done = {}
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "h", "hpp" },
  callback = function()
    local root = vim.fn.getcwd()
    -- 已经处理过的跳过
    if _cc_auto_setup_done[root] then return end

    local has_cc = vim.fn.filereadable(root .. "/compile_commands.json") == 1
        or vim.fn.filereadable(root .. "/build/compile_commands.json") == 1
    if not has_cc then
      local cache_dir = vim.fn.stdpath("cache") .. "/clangd"
      local project_hash = vim.fn.sha256(root):sub(1, 16)
      has_cc = vim.fn.filereadable(cache_dir .. "/" .. project_hash .. "/compile_commands.json") == 1
    end

    if not has_cc then
      _cc_auto_setup_done[root] = true
      -- 后台执行 CCSetup，不阻塞编辑
      vim.defer_fn(function()
        vim.cmd("CCSetup")
      end, 1000)
    end
  end,
})

-- LSP 状态检查命令
vim.api.nvim_create_user_command("LspCheck", function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    vim.notify("当前 buffer 没有活跃的 LSP 客户端", vim.log.levels.WARN)
  else
    for _, client in ipairs(clients) do
      vim.notify(
        string.format("LSP: %s (pid=%d)", client.name, client.id),
        vim.log.levels.INFO
      )
    end
  end
end, { desc = "检查当前 buffer 的 LSP 状态" })

-- C/C++ 项目快速设置：生成 compile_commands.json 到缓存目录
-- 缓存路径：~/.cache/clangd/<项目路径hash>/compile_commands.json
-- 异步执行，不阻塞前台
vim.api.nvim_create_user_command("CCSetup", function()
  local project_root = vim.fn.getcwd()
  local cache_dir = vim.fn.stdpath("cache") .. "/clangd"

  local project_hash = vim.fn.sha256(project_root):sub(1, 16)
  local cached_cc_dir = cache_dir .. "/" .. project_hash
  local cached_cc = cached_cc_dir .. "/compile_commands.json"

  vim.fn.mkdir(cached_cc_dir, "p")

  -- 检查已有的 compile_commands.json 来源
  local existing = nil
  if vim.fn.filereadable(project_root .. "/compile_commands.json") == 1 then
    existing = project_root .. "/compile_commands.json"
  elseif vim.fn.filereadable(project_root .. "/build/compile_commands.json") == 1 then
    existing = project_root .. "/build/compile_commands.json"
  end

  -- 如果项目已有，直接复制到缓存目录
  if existing then
    vim.fn.system({ "cp", existing, cached_cc })
    vim.notify("已将 compile_commands.json 复制到缓存: " .. cached_cc, vim.log.levels.INFO)
    return
  end

  -- 异步生成函数
  local function run_async(cmd, args, cwd, on_exit)
    vim.system(cmd, vim.iter(args):prepend({ cwd = cwd }):totable(), on_exit)
  end

  -- 1: CMake 项目
  if vim.fn.filereadable(project_root .. "/CMakeLists.txt") == 1 then
    vim.notify("检测到 CMake 项目，正在后台生成 compile_commands.json...", vim.log.levels.INFO)
    vim.system({
      "cmake",
      "-DCMAKE_EXPORT_COMPILE_COMMANDS=1",
      "-B", cached_cc_dir .. "/build",
      project_root,
    }, { cwd = project_root }, function(obj)
      local build_cc = cached_cc_dir .. "/build/compile_commands.json"
      if vim.fn.filereadable(build_cc) == 1 then
        vim.fn.system({ "mv", build_cc, cached_cc })
        vim.notify("已生成: " .. cached_cc .. " (通过 CMake)", vim.log.levels.INFO)
      elseif vim.fn.filereadable(project_root .. "/build/compile_commands.json") == 1 then
        vim.fn.system({ "cp", project_root .. "/build/compile_commands.json", cached_cc })
        vim.notify("已生成: " .. cached_cc .. " (通过 CMake)", vim.log.levels.INFO)
      else
        vim.notify("CMake 生成失败，请手动检查", vim.log.levels.ERROR)
      end
    end)
    return
  end

  -- 2: Make 项目
  if vim.fn.filereadable(project_root .. "/Makefile") == 1 then
    if vim.fn.executable("bear") == 1 then
      vim.notify("使用 bear 捕获编译命令（后台运行）...", vim.log.levels.INFO)
      vim.system({ "bear", "--", "make", "-C", project_root }, { cwd = project_root }, function(obj)
        if vim.fn.filereadable(project_root .. "/compile_commands.json") == 1 then
          vim.fn.system({ "cp", project_root .. "/compile_commands.json", cached_cc })
          vim.fn.delete(project_root .. "/compile_commands.json")
          vim.notify("已生成: " .. cached_cc .. " (通过 bear)", vim.log.levels.INFO)
        else
          vim.notify("bear 未能生成 compile_commands.json", vim.log.levels.ERROR)
        end
      end)
      return
    end
    if vim.fn.executable("compiledb") == 1 then
      vim.notify("使用 compiledb 解析 Makefile（后台运行）...", vim.log.levels.INFO)
      vim.system({ "compiledb", "-o", cached_cc }, { cwd = project_root }, function(obj)
        if vim.fn.filereadable(cached_cc) == 1 then
          vim.notify("已生成: " .. cached_cc .. " (通过 compiledb)", vim.log.levels.INFO)
        else
          vim.notify("compiledb 未能生成 compile_commands.json", vim.log.levels.ERROR)
        end
      end)
      return
    end
    vim.notify("Makefile 项目但没有 bear/compiledb。安装: sudo apt install bear 或 pip install compiledb", vim.log.levels.WARN)
    return
  end

  -- 3: Android 项目
  if vim.fn.filereadable(project_root .. "/Android.bp") == 1
    or vim.fn.filereadable(project_root .. "/Android.mk") == 1
  then
    vim.notify("Android 项目需要从完整编译环境中导出 compile_commands.json。", vim.log.levels.WARN)
    return
  end

  vim.notify("未检测到构建系统。手动创建 compile_commands.json 到 " .. cached_cc, vim.log.levels.WARN)
end, { desc = "为 C/C++ 项目生成 compile_commands.json（存到缓存目录）" })
