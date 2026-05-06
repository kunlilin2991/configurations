-- 覆盖 LazyVim 自带插件配置
return {
  -- ========== Diagnostic 诊断配置 ==========
  -- 关闭行尾错误提示（virtual text）
  {
    "LazyVim/LazyVim",
    opts = function(_, opts)
      vim.diagnostic.config({
        virtual_text = false,
      })
    end,
  },

  -- ========== bufferline: 支持 ;1~;9 跳转 ==========
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        numbers = "ordinal", -- 显示序号，方便 ;1~;9 跳转
      },
    },
  },

  -- ========== lualine: 替代 airline ==========
  -- LazyVim 默认已配置 lualine，这里微调
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      sections = {
        -- 保留你原来 airline 的习惯：显示文件名、编码、行列信息
        lualine_c = { { "filename", path = 1 } }, -- 显示相对路径
      },
    },
  },

  -- ========== neo-tree: 替代 NERDTree ==========
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          -- 对应你的 NERDTree 忽略设置
          hide_dotfiles = false,
          hide_by_pattern = {
            "*.pyc", "*.pyo", "*.obj", "*.o", "*.so", "*.egg",
          },
          hide_by_name = {
            ".git", ".svn", ".hg",
          },
        },
      },
      -- 当 neo-tree 是最后一个窗口时自动关闭（对应你的 NERDTree autocmd）
      close_if_last_window = true,
    },
  },

  -- ========== telescope: 替代 ctrlp ==========
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        file_ignore_patterns = { ".git/", ".hg/", ".svn/" },
      },
    },
  },

  -- ========== treesitter: 替代 vim-cpp-enhanced-highlight ==========
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "c", "cpp", "lua", "python", "bash", "markdown",
        "json", "yaml", "html", "css", "javascript",
        "latex", "vim", "vimdoc",
      },
    },
  },

  -- ========== LSP: 替代 YCM + ctags + gtags ==========
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--fallback-style=llvm",
          },
          settings = {
            clangd = {
              fallbackFlags = {
                "-I/usr/include",
                "-I/usr/local/include",
              },
            },
          },
          -- compile_commands.json 集中管理：类似 gutentags
          -- 缓存目录：~/.cache/clangd/<项目路径hash>/compile_commands.json
          -- clangd 启动时从缓存目录读取 --compile-commands-dir
          root_dir = require("lspconfig.util").root_pattern(
            "compile_commands.json",
            "compile_flags.txt",
            ".clangd",
            "Makefile", "CMakeLists.txt",
            "build.gradle", "pom.xml",
            "Cargo.toml", "go.mod",
            ".git" -- 兜底：git 仓库根
          ),
          on_new_config = function(new_config, root_dir)
            local cache_dir = vim.fn.stdpath("cache") .. "/clangd"
            -- 用项目路径的 hash 作为子目录名
            local project_hash = vim.fn.sha256(root_dir):sub(1, 16)
            local cached_cc_dir = cache_dir .. "/" .. project_hash

            -- 检查 1: 项目根目录已有 compile_commands.json
            if vim.fn.filereadable(root_dir .. "/compile_commands.json") == 1 then
              table.insert(new_config.cmd, "--compile-commands-dir=" .. root_dir)
              return
            end

            -- 检查 2: build/ 子目录有 compile_commands.json
            if vim.fn.filereadable(root_dir .. "/build/compile_commands.json") == 1 then
              table.insert(new_config.cmd, "--compile-commands-dir=" .. root_dir .. "/build")
              return
            end

            -- 检查 3: 缓存目录有 compile_commands.json
            if vim.fn.filereadable(cached_cc_dir .. "/compile_commands.json") == 1 then
              -- 让 clangd 从缓存目录读取
              table.insert(new_config.cmd, "--compile-commands-dir=" .. cached_cc_dir)
              vim.notify("使用缓存的 compile_commands.json: " .. cached_cc_dir, vim.log.levels.INFO)
              return
            end

            -- 都没有，clangd 使用 fallback 模式
          end,
        },
      },
    },
  },

  -- ========== Mason: 自动安装/管理语言服务器 ==========
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "clangd",
        "lua-language-server",
        "shfmt",
        "stylua",
      },
    },
  },

  -- ========== nvim-cmp: 补全行为调整 ==========
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      -- 回车选中当前项（对应你原来 YCM 的 CR 行为）
      opts.mapping = vim.tbl_extend("force", opts.mapping or {}, {
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
      })
      return opts
    end,
  },

  -- ========== todo-comments: 替代 TaskList ==========
  {
    "folke/todo-comments.nvim",
    opts = {
      keywords = {
        -- 对应你的 tlTokenList
        FIXME = { icon = " ", color = "error" },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        NOTE = { icon = " ", color = "hint" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING" } },
        MODIFY = { icon = " ", color = "info" },
      },
    },
  },

  -- ========== indent-blankline: 替代 indentLine ==========
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl", -- v3 必须指定 main
    opts = {
      indent = {
        char = "│", -- 对应你原来的 indentLine_char_list 风格
      },
    },
  },

  -- ========== Trouble: 替代 tagbar 的符号大纲 ==========
  {
    "folke/trouble.nvim",
    opts = {},
  },
}
