# nvim-lazyvim 键位速查

Leader 键为 **`;`**（在 `init.lua` 设置）。下表中 `<leader>` 即 `;`。
无 LSP/clangd，代码导航全靠 ctags + gtags(gutentags_plus)。

## 一、基础编辑（`lua/config/keymaps.lua`）

### 行内移动
| 键位 | 作用 | 模式 |
|------|------|------|
| `le` | 跳到行尾（`$`） | n/x/o |
| `lb` | 跳到行首（`0`） | n/x/o |
| `;m` | 在结对符（括号等）之间跳转（`%`） | n |

### 系统剪贴板
| 键位 | 作用 |
|------|------|
| `;y` | 复制到系统剪贴板（`"+y`） |
| `;p` | 从系统剪贴板粘贴（`"+p`） |

### 保存 / Buffer
| 键位 | 作用 |
|------|------|
| `;W` | sudo 提权保存（`w !sudo tee`） |
| `;1`~`;9` | 跳到第 1~9 个 buffer（BufferLine） |

### 搜索 / 命令
| 键位 | 作用 |
|------|------|
| `;/` | 清除搜索高亮 |
| `;.` | 重复上一条命令行命令（`:<up><cr>`） |

### 文件 / 文件树
| 键位 | 作用 |
|------|------|
| `;n` | 切换文件树（Neotree） |
| `;f` | 模糊查找文件（原 CtrlP 习惯） |

### 注释
| 键位 | 作用 | 模式 |
|------|------|------|
| `;cc` | 注释/取消注释当前行 | n |
| `;cc` | 注释/取消注释选区 | x |

> 另：neovim 原生的 `gcc`（行）、`gc`（选区）也可用。

## 二、代码导航（全 gtags，`keymaps.lua` + `lua/plugins/tags.lua`）

### 定义 / 引用 / 栈（代码 buffer，buffer-local）
| 键位 | 作用 | 模式 |
|------|------|------|
| `<C-]>` | 查定义（`:cstag`，压 tagstack） | n |
| `<C-\>` | 查引用（谁用了这个符号） | n |
| `<C-t>` | 弹栈返回 | n（原生） |
| `<C-o>` / `<C-i>` | jumplist 后退 / 前进 | n（原生） |
| `;jd` | 跳到定义（gtags） | n |
| `;jc` | 多个定义时列出选择 | n |

> `<C-]>`=跳定义 与 Vim 原生约定一致；`<C-\>`=查引用。两者仅在代码 buffer 生效（buffer-local）。
>
> **Linux 内核树**：以上自动改用 `make ARCH=arm64 gtags` 生成的单 arch 索引（改 `lua/plugins/tags.lua` 顶部 `KERNEL_ARCH`）。保存（`:w`）后台 `global -u` 增量；`:KernelIndex` 手动全量重建。索引集中在 `~/.cache/tags/<打平路径>/`，不污染工程树。详见 `README.md`。

### gtags 符号查询（对光标下单词 `<cword>`）
| 键位 | 查询类型 |
|------|----------|
| `;gs` | 符号(symbol) |
| `;gg` | 定义(definition) |
| `;gc` | 调用者(callers) |
| `;gt` | 文本(text) |
| `;ge` | egrep 模式 |
| `;gd` | 被调用者(called) |
| `;ga` | 赋值(assignment) |
| `;gz` | 类型 z 查询 |
| `;gf` | 找文件（对 `<cfile>`） |
| `;gi` | 找包含此文件的文件（对 `<cfile>`） |

## 三、结构 / 历史 / 切换（`lua/plugins/editor.lua`）

| 键位 | 作用 |
|------|------|
| `<F9>` 或 `;tb` | 切换代码结构大纲（aerial，treesitter 后端） |
| `;su` | 切换 undo 历史树（undotree，Lua 版） |
| `;td` | TODO/FIXME 列表（Trouble） |

### 对齐（mini.align）
| 键位 | 作用 | 模式 |
|------|------|------|
| `ga` | 启动对齐 | n/x |
| `gA` | 启动对齐（带预览） | n/x |
| `<CR>`（回车） | 启动对齐（同 `ga`） | x（可视模式） |

## 四、AI / Claude Code（`lua/plugins/ai.lua`，前缀 `;i`）

| 键位 | 作用 | 模式 |
|------|------|------|
| `;ic` | 切换 Claude Code 窗口 | n |
| `;if` | 聚焦 Claude 窗口 | n |
| `;ir` | 恢复会话（`--resume`） | n |
| `;iC` | 继续上次会话（`--continue`） | n |
| `;ib` | 把当前文件加入上下文 | n |
| `;is` | 发送选区给 Claude | v（可视模式） |
| `;ia` | 接受 diff | n |
| `;id` | 拒绝 diff | n |
| `;tc` | 切换 Copilot 云端补全（默认关，只本地） | n |

> `;a` 留给了头/源切换，所以 AI 前缀用 `;i`。

## 五、补全键位（`lua/plugins/coding.lua`，blink.cmp）

补全来源：gtags 符号（`global -c`）+ buffer + 片段 + 路径（本地，无 LSP，置顶）+ Copilot（云端，默认关，`;tc` 开启后排在本地候选下方）。

| 键位 | 作用 |
|------|------|
| `<CR>`（回车） | 选中当前补全项 |
| `<C-n>` / `<C-p>` | 下一个 / 上一个候选 |
| `<Tab>` / `<S-Tab>` | 展开片段 / 反向，或选下一个/上一个 |
| `<C-j>` / `<C-k>` | 片段占位符向前 / 向后跳 |

## 六、主题（LazyVim 默认）

| 键位 | 作用 |
|------|------|
| `;uC` | 切换配色主题（实时预览），默认 `gruvbox-material` |
