# nvim-lazyvim 插件清单

按用途分组。三类:**框架**、**显式声明/定制的**、**LazyVim 核心默认带来的**。
（`<leader>` = `;`）

## 一、框架 / 管理

| 插件 | 作用 |
|------|------|
| `folke/lazy.nvim` | 插件管理器（`lua/config/lazy.lua` bootstrap）。`:Lazy` 管理、`:Lazy sync` 安装/更新 |
| `LazyVim/LazyVim` | 发行版预设：一次性带来一套默认插件 + 键位（见第三节）。在其基础上做减法——不引入任何 lang extra（不要 clangd） |

## 二、显式声明 / 定制的插件

### 高亮 / 索引 / 导航
| 插件 | 作用 | 用法 |
|------|------|------|
| `nvim-treesitter/nvim-treesitter` | 语法高亮 + 结构（无 LSP 下函数/变量/类型分色靠它） | 自动；装 c/cpp/lua/bash/python/json/yaml/make 等 parser |
| *(纯 Lua，无插件)* `lua/plugins/tags.lua` | 直调 GNU GLOBAL 自动建/增量索引（`gtags` / `global -u`，写 `~/.cache/tags/`，保存即增量）。Neovim 已移除 cscope，故**不用** vim-gutentags / gutentags_plus | 自动 |
| *(纯 Lua)* gtags 查询 | `global` 查定义/引用/符号/文本/文件 → quickfix | `;gg/;gr/;gs/;gt/;gf` |

> 导航键：`<C-]>` 查定义（`tagfunc` 接 gtags，原生压 tagstack）、`<C-\>` 查引用（`global -r`→quickfix）、`<C-t>` 弹栈、`<C-o>`/`<C-i>` jumplist。`;jd`/`;jc` 跳定义。

### 补全
| 插件 | 作用 | 用法 |
|------|------|------|
| `saghen/blink.cmp` | 补全引擎（LazyVim 核心，定制了源） | `<C-n>/<C-p>` 选、`<CR>` 确认、`<Tab>` 片段、`<C-j>/<C-k>` 片段跳 |
| `zbirenbaum/copilot.lua` | Copilot 引擎（关掉自带灰字/面板，只当数据源） | 默认关 |
| `fang2hou/blink-copilot` | 把 Copilot 接成 blink 的一个源 | `;tc` 开/关云端补全 |
| *(本地模块 `lua/blink_global.lua`)* | 非插件，自定义 blink 源：`global -c` 项目符号补全 | 自动出现在补全菜单，置顶 |

### AI
| 插件 | 作用 | 用法 |
|------|------|------|
| `coder/claudecode.nvim` | 把 Claude Code CLI 连进编辑器（选区/文件/整仓上下文、inline diff） | `;ic/;if/;ir/;iC/;ib/;is/;ia/;id` |

### 编辑增强（`editor.lua`）
| 插件 | 作用 | 用法 |
|------|------|------|
| `numToStr/Comment.nvim` | 显式注释/取消（不接管原生 `gc`） | `;cc` 注释、`;cu` 取消（行/选区） |
| `stevearc/aerial.nvim` | 代码结构大纲（treesitter 后端，无需 ctags） | `<F9>` 或 `;tb` |
| `jiaoshijie/undotree` | undo 历史树（Lua 版） | `;su` |
| `nvim-mini/mini.align` | 列对齐 | `ga` / `<CR>`（可视） / `gA`（预览） |
| `HiPhish/rainbow-delimiters.nvim` | 括号按层级配色（treesitter） | 自动 |
| `folke/todo-comments.nvim` | TODO/FIXME/HACK 高亮 + 列表（自定义 MODIFY 关键字） | `;td` |
| `nvim-lua/plenary.nvim` | Lua 工具库（undotree 等依赖） | 间接 |

### 配色（`colorscheme.lua`，`;uC` 实时切换）
| 插件 | 备注 |
|------|------|
| `sainnhe/gruvbox-material` | **默认主题**（暖色、高区分度） |
| `sainnhe/sonokai` · `rebelot/kanagawa.nvim` · `loctvl842/monokai-pro.nvim` · `Mofiqul/dracula.nvim` · `EdenEast/nightfox.nvim` · `olimorris/onedarkpro.nvim` · `Mofiqul/vscode.nvim` | 备选，`;uC` 切换 |

## 三、LazyVim 核心默认带来的（未在 spec 里，但在用）

`import = "lazyvim.plugins"` 自动装一批，常用的有：

| 插件 | 作用 | 用法 |
|------|------|------|
| `folke/snacks.nvim` | 合集：picker、文件浏览、终端、lazygit、通知、dashboard（也是 claudecode 依赖） | `;f` 找文件、picker 等 |
| `nvim-neo-tree/neo-tree.nvim` | 文件树 | `;n`（自定义）/ `;e` |
| `folke/which-key.nvim` | 按键提示弹窗 | 按 `;` 停顿即弹 |
| `akinsho/bufferline.nvim` | 顶部 buffer 标签 | `;1`~`;9` 跳 buffer |
| `nvim-lualine/lualine.nvim` | 状态栏 | 自动 |
| `lewis6991/gitsigns.nvim` | git 改动标记 / hunk 跳转 | `]h` / `[h` 等 |
| `folke/flash.nvim` | 快速跳转 | `s` |
| `folke/noice.nvim` | 命令行/消息 UI | 自动 |
| `folke/trouble.nvim` | 诊断/列表 UI | 间接 |
| `nvim-lspconfig` | LSP 框架**存在但未配任何 server**（刻意无 clangd），基本不生效 | — |
| `mini.pairs` / `mini.icons` / `nvim-web-devicons` 等 | 自动括号、图标 | 自动 |

> LazyVim 默认还带 `conform.nvim`（格式化）、`nvim-lint` 等；无语言配置时基本静默。

## 小结

- **核心特色**：treesitter（高亮）+ gtags（索引/导航，**纯 Lua 直调 `global`**，无 cscope/gutentags）+ blink.cmp（本地 `global -c` 补全）+ Copilot（默认关）+ Claude Code（AI 对话/改写）+ aerial（大纲）。
- **已无 vimscript 插件依赖**：gtags 自动化改为纯 Lua 直调 `gtags`/`global`（因 Neovim 移除了 cscope，vim-gutentags 的 gtags_cscope 模块无法启用）。
- 设计取向、内核索引细节见 `README.md`；键位速查见 `KEYMAPS.md`。
