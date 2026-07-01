-- treesitter:语法高亮(+ 折叠基础),不需要编译、不需要 compile_commands.json。
-- 在这套无 LSP 的配置里,函数/变量/成员/类型 的分色就是它提供的。
-- 不装 markdown(按需求剔除)。
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "c", "cpp", "lua", "vim", "vimdoc", "bash", "python", "json", "yaml", "make",
      },
    },
  },
}
