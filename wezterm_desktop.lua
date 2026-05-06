local wezterm = require 'wezterm'
local config = wezterm.config_builder()
-- 修复核心错误：定义 act 变量
local act = wezterm.action

-- ==============================================
-- 基础设置
-- ==============================================
config.default_prog = { "pwsh.exe", "-NoLogo" }
-- 防止 SSH 断开
config.ssh_backend = "Ssh2"


-- 系统字体
config.font = wezterm.font('Consolas')
config.font_size = 14
config.line_height = 1.1

-- 窗口按钮 正常显示（最小化、最大化、关闭）
config.window_decorations = "TITLE|RESIZE|INTEGRATED_BUTTONS"
config.integrated_title_buttons = { 'Hide', 'Maximize', 'Close' }
config.hide_tab_bar_if_only_one_tab = false

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
config.leader = { key="l", mods="CTRL", timeout_milliseconds=1000 }
config.keys = {
  -- leader + c 新 tab
  {key="c", mods="LEADER", action=act.SpawnTab "CurrentPaneDomain"},
  -- leader + x 关闭 pane
  {key="x", mods="LEADER", action=act.CloseCurrentPane{confirm=true}},
  -- leader + z 最大化 pane
  {key="z", mods="LEADER", action=act.TogglePaneZoomState},
  -- leader + | 左右分屏
  {key = "|", mods = "LEADER|SHIFT", action = act.SplitHorizontal { domain = "CurrentPaneDomain" }},
  -- leader + - 上下分屏
  {key = "-", mods = "LEADER", action = act.SplitVertical { domain = "CurrentPaneDomain" }},
  -- leader + hjkl 切换 pane
  {key="h", mods="LEADER", action=act.ActivatePaneDirection "Left"},
  {key="j", mods="LEADER", action=act.ActivatePaneDirection "Down"},
  {key="k", mods="LEADER", action=act.ActivatePaneDirection "Up"},
  {key="l", mods="LEADER", action=act.ActivatePaneDirection "Right"},

  -- 补充：切换标签页 更实用
  {key="Tab", mods="LEADER", action=act.ActivateLastTab},
  {key="LeftArrow", mods="CTRL", action=act.ActivateTabRelative(-1)},
  {key="RightArrow", mods="CTRL", action=act.ActivateTabRelative(1)},
}

-- ==============================================
-- 鼠标右键粘贴
-- ==============================================
config.mouse_bindings = {
  {
    event = { Down = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = act.PasteFrom 'Clipboard',
  },
}

-- 增大 scrollback 缓冲区（默认 3500 行，可以调大）
config.scrollback_lines = 10000

-- 显示右侧滚动条（可选，方便直观看到位置）
config.enable_scroll_bar = true

-- 确保鼠标滚轮在非 alt screen 模式下可以滚动
config.mouse_bindings = {
  -- 鼠标滚轮向上 = 滚动查看历史
  {
    event = { Down = { streak = 1, button = { WheelUp = 1 } } },
    mods = 'NONE',
    action = wezterm.action.ScrollByCurrentEventWheelDelta,
    alt_screen = false,
  },
  -- 鼠标滚轮向下 = 滚动回来
  {
    event = { Down = { streak = 1, button = { WheelDown = 1 } } },
    mods = 'NONE',
    action = wezterm.action.ScrollByCurrentEventWheelDelta,
    alt_screen = false,
  },
}

-- ==============================================
-- 键盘兼容性
-- ==============================================
config.enable_kitty_keyboard = true
config.enable_csi_u_key_encoding = true

-- ==============================================
-- 鼠标
-- ==============================================
-- 右键粘贴
config.mouse_bindings = {
	{
		event = { Down = { streak = 1, button = "Right" } },
		mods = "NONE",
		action = wezterm.action.PasteFrom("Clipboard"),
	},
}

config.set_environment_variables = {
  -- vmiss proxy/hiddify proxy SOCKS5 代理（端口比如 1080、10808，Clash/V2Ray/Xray 常用）
  -- ALL_PROXY = "socks5://127.0.0.1:12334",
  -- SOCKS_PROXY = "socks5://127.0.0.1:12334",
  -- NO_PROXY = "localhost,127.0.0.1,::1,192.168.0.0/16,10.0.0.0/8,172.16.0.0/12",
  -- ：clash proxy SOCKS5 代理（端口比如 1080、10808，Clash/V2Ray/Xray 常用）
  ALL_PROXY = "socks5://127.0.0.1:7890",
  SOCKS_PROXY = "socks5://127.0.0.1:7890",
  -- NO_PROXY = "localhost,127.0.0.1,::1,192.168.0.0/16,10.0.0.0/8,172.16.0.0/12",
}
return config