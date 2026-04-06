-- 覆盖 LazyVim 自带插件配置
return {
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
          -- clangd 同时提供 switchSourceHeader（替代 a.vim 和 fswitch）
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
          },
        },
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
