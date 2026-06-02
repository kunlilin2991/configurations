-- 补全:blink.cmp(LazyVim 默认引擎)
-- 本地候选 = global(gtags 项目符号)+ 片段 + buffer + 路径,均无需 LSP,置顶;
-- AI(Copilot)作为一个源,默认关(只本地),<leader>tc 打开才走云端,且排在本地之下(见 ai.lua)。
return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      -- 去 lsp;本地源在前,copilot 在尾(默认关)
      opts.sources.default = { "global", "snippets", "buffer", "path", "copilot" }
      opts.sources.providers = vim.tbl_deep_extend("force", opts.sources.providers or {}, {
        -- gtags 项目级符号补全(global -c),见 lua/blink_global.lua
        global = {
          name = "global",
          module = "blink_global",
          score_offset = 0,
        },
        -- Copilot:默认 disabled(只本地);<leader>tc 打开后才出云端候选,
        -- score_offset 很低 → 永远排在本地符号下方。
        copilot = {
          name = "copilot",
          module = "blink-copilot",
          async = true,
          score_offset = -100,
          enabled = function()
            return vim.g.copilot_cmp_on == true
          end,
        },
      })
      -- 按键尽量贴近 vimrc 的 YCM / UltiSnips 习惯
      opts.keymap = vim.tbl_deep_extend("force", opts.keymap or {}, {
        preset = "enter", -- <CR> 选中当前项
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
        ["<C-j>"] = { "snippet_forward", "fallback" },
        ["<C-k>"] = { "snippet_backward", "fallback" },
      })
      return opts
    end,
  },
}
