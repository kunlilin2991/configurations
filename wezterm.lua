local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- ==============================================
-- 基础设置（Windows 10/11 自带字体，永不报错）
-- ==============================================
config.default_prog = { "pwsh.exe", "-NoLogo" }

-- 🔥 用系统自带字体，彻底解决所有字体报错！
config.font = wezterm.font('Consolas')
config.font_size = 14
config.line_height = 1.1

config.window_decorations = "RESIZE"
config.window_padding = { left = 8, right = 8, top = 8, bottom = 8 }
config.enable_scroll_bar = true
config.scrollback_lines = 10000

-- 性能优化
config.front_end = "WebGpu"
config.cursor_blink_rate = 0
config.window_background_opacity = 0.95

-- ==============================================
-- 主题
-- ==============================================
config.color_scheme = "Catppuccin Mocha"

-- ==============================================
-- Tmux 风格快捷键（Ctrl+b）
-- ==============================================
config.keys = {
  {
    key = 'b',
    mods = 'CTRL',
    action = wezterm.action.ActivateKeyTable {
      name = 'tmux_keys',
      one_shot = false,
      timeout_milliseconds = 1000,
    },
  },

  { key = 't', mods = 'CTRL|SHIFT', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
  { key = 'w', mods = 'CTRL|SHIFT', action = wezterm.action.CloseCurrentTab { confirm = false } },
}

config.key_tables = {
  tmux_keys = {
    { key = '|', action = wezterm.action.SplitHorizontal{} },
    { key = '-', action = wezterm.action.SplitVertical{} },
    { key = 'x', action = wezterm.action.CloseCurrentPane { confirm = false } },
    { key = 'LeftArrow', action = wezterm.action.ActivatePaneDirection 'Left' },
    { key = 'RightArrow', action = wezterm.action.ActivatePaneDirection 'Right' },
    { key = 'UpArrow', action = wezterm.action.ActivatePaneDirection 'Up' },
    { key = 'DownArrow', action = wezterm.action.ActivatePaneDirection 'Down' },
    { key = 'n', action = wezterm.action.ActivateTabRelative(1) },
    { key = 'p', action = wezterm.action.ActivateTabRelative(-1) },
    { key = 'Escape', action = 'PopKeyTable' },
  },
}

-- ==============================================
-- 鼠标
-- ==============================================
config.mouse_bindings = {
  {
    event = { Down = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = wezterm.action.PasteFrom 'Clipboard',
  },
}

-- ==============================================
-- 路径补全
-- ==============================================
config.enable_kitty_keyboard = true
config.enable_csi_u_key_encoding = true

return config