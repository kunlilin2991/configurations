# nvim-lazyvim

从 `vimrc` 的按键习惯迁移过来的**全新 LazyVim 配置**(与 `nvim-config/` 并存,互不影响)。

## 部署

复制到 `~/.config/nvim/`(先备份现有的):

```sh
mv ~/.config/nvim ~/.config/nvim.bak    # 如已有
cp -r nvim-lazyvim ~/.config/nvim
```

首次启动 `nvim` 会自动 bootstrap lazy.nvim 并安装全部插件。

## 设计取向(与众不同的几点)

- **无 clangd / 无任何 LSP**:目标场景是 qcom / Linux 内核这类不可编译、没有 `compile_commands.json` 的大型代码仓 —— 上 clangd 只会满屏波浪线。因此本配置**没有 LSP 诊断、没有波浪线**。
- **导航/索引全靠 gtags(GNU GLOBAL)单源**,不用 ctags、不用 LSP。**纯 Lua 直调 `gtags`/`global`**(Neovim 已移除 cscope,故不用 vim-gutentags/gutentags_plus)。带原生增量(`global -u`),保存即新。索引集中放 `~/.cache/tags/<打平的工程路径>/`,**不污染工程树**。普通工程用 `gtags` 建库。
- **Linux 内核特殊处理**:检测到内核树时改用 `make ARCH=<arch> gtags`,**只索引单一架构**(默认 `arm64`),其余 arch 全部跳过。见下方"Linux 内核索引"。
- **高亮靠 treesitter**(不需要编译)。函数/变量/成员/类型的分色就来自它。
- **补全靠 blink.cmp**,本地候选 = gtags 符号(`global -c`)+ 片段 + buffer + 路径(无 LSP source),**置顶**。
- **AI 补全(Copilot)默认关闭**:同一补全菜单里多一个 Copilot 源,**默认只走本地**;按 `<leader>tc` 打开才走云端,且云端候选**排在本地符号下方**。需 Node.js + `:Copilot auth`。
- **AI 改写/对话靠 Claude Code**(claudecode.nvim),需要时主动唤起;不挂内联灰字补全。

## 系统依赖(需各装一次)

| 依赖 | 用途 |
|------|------|
| `GNU GLOBAL`(`gtags` / `global`) | **唯一索引引擎**:跳定义 / 查引用 / 补全 / 增量(纯 Lua 直调) |
| `claude`(Claude Code CLI) | claudecode.nvim 接入 |
| `Node.js` + `:Copilot auth` | Copilot 云端补全(默认关,`<leader>tc` 开) |
| `ripgrep`、`fd` | picker(查找文件/文本) |
| 一款 Nerd Font | 图标(tagbar/状态栏等) |

## 配色

默认 `gruvbox-material`。`<leader>uC` 实时预览切换;备选:sonokai / kanagawa / monokai-pro / dracula / nightfox / onedarkpro / vscode。

## 按键:相对 LazyVim 默认的改动(均以 vimrc 习惯为准)

| 键 | 本配置 | LazyVim 默认 |
|----|--------|--------------|
| `<leader>W` | sudo 保存 | — |
| `<leader>f` | 模糊找文件 | 文件/查找组前缀 |
| `<leader>/` | 清除搜索高亮 | grep |
| `<leader>n` | 文件树(`<leader>e` 仍可用) | — |
| `<leader>g{g,r,s,t,f}` | gtags 定义/引用/符号/文本/文件(global→quickfix) | git 组 |
| `<leader>cc` | 注释/取消(`gcc`/`gc` 仍可用) | code 组前缀 |
| `<leader>jd` / `<leader>jc` | 跳定义(gtags) | — |
| `<C-]>` / `<C-\>` | 查定义 / 查引用(gtags,buffer-local 仅代码 buffer) | `<C-]>` 默认=跳定义 |
| `<leader>tb` / `<F9>` | aerial 大纲(treesitter) | — |
| `<leader>su` | undo 树 | — |
| `<leader>td` | TODO/FIXME 列表 | — |
| `<leader>i*` | Claude Code | — |
| `<leader>tc` | 切换 Copilot 云端补全(默认关) | — |
| `le` / `lb` | 行尾 / 行首 | — |

导航键(代码 buffer):`<C-]>` 查定义(经 `tagfunc` 接 gtags,原生压 tagstack)、`<C-\>` 查引用(`global -r`→quickfix)、`<C-t>` 弹栈返回、`<C-o>`/`<C-i>` jumplist —— 后两个原生。

> Neovim 已移除 cscope,故跳定义走 `tagfunc`(调 `global -d`)、查引用/查询直调 `global`→quickfix,都不依赖 cscope/gutentags。

## 索引落点(集中 cache,不污染工程)

所有 gtags 库放在 `~/.cache/tags/<打平的工程路径>/` 下(打平命名):

```
工程 /home/l00024352/linux
→ ~/.cache/tags/home-l00024352-linux/
                   ├── GTAGS / GRTAGS / GPATH
                   └── .kindex.ok   (仅内核:全量完成标记)
```

- 普通工程:`gtags <cache目录>` 直接写到这里。
- 内核:`make gtags` 先写内核根,**立即 move 到上面 cache 目录**;`global -u` 增量只写 cache。**编辑期内核树零写入**;游离的 `GTAGS/GRTAGS/GPATH`(中断残留)在下次打开内核文件时**自动清理**。

## Linux 内核索引

为什么不用 clangd:内核需先**完整编译**再生成 `compile_commands.json`,且 clangd 不认大量 GCC 专有 flag、~8 万文件索引慢吃内存 —— 与"开箱即用"冲突。本配置改用 gtags 单源 + 内核自带 make 目标:

- **自动检测**:文件位于内核树(`arch/` + `Kbuild` + Makefile 含 `VERSION`/`PATCHLEVEL`)时自动生效。
- **单 arch**:`make ARCH=<arch> gtags` 只索引当前 arch(读 SRCARCH),含内核宏解析(`scripts/tags.sh`),**无需编译内核**。
- **首次自动后台全量**:无完整索引时自动生成 → move 到 cache → 写 `.kindex.ok`。
- **保存即增量**:`:w` 后台 `global -u`(只重扫改动文件,快),跳定义/查引用即时刷新。
- **防半截索引**:全量成功才写 `.kindex.ok`;中途退出被杀不会留下"看似完整"的索引,下次自动重建。
- **`:KernelIndex`**:手动强制全量重建。
- 全程后台异步(`jobstart`),**不阻塞 nvim 退出**。

**改架构**:编辑 `lua/plugins/tags.lua` 顶部 `KERNEL_ARCH`(默认 `"arm64"`)。

补全菜单:`<CR>` 选中、`<C-n>`/`<C-p>` 上下、`<Tab>`/`<S-Tab>` 展开/跳片段、`<C-j>`/`<C-k>` 片段前后跳。

## 结构

```
init.lua                 leader=; → require config.lazy
lua/config/lazy.lua      bootstrap;LazyVim 核心(不引入任何 lang extra)
lua/config/options.lua   移植 vimrc 的 set 选项
lua/config/keymaps.lua   移植 vimrc 的全部按键
lua/blink_global.lua     blink 源:global -c 项目符号补全
lua/plugins/
  colorscheme.lua        gruvbox-material + 高区分度主题集合
  treesitter.lua         C/C++ 等高亮(无 markdown)
  coding.lua             blink.cmp + global/片段/buffer/路径 source(+ Copilot 默认关)
  tags.lua               全 gtags 索引(纯 Lua 直调 global:建库/增量 + tagfunc 跳定义 + 查引用)
  editor.lua             aerial / undotree(lua) / mini.align / rainbow / todo / comment
  ai.lua                 claudecode.nvim + Copilot(blink 源,默认关)
```
