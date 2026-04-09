local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- ==============================================
-- 基础设置（Windows 10/11 自带字体，永不报错）
-- ==============================================
config.default_prog = { "pwsh.exe", "-NoLogo" }

-- 🔥 用系统自带字体，彻底解决所有字体报错！
config.font = wezterm.font("Consolas")
config.font_size = 14
config.line_height = 1.1

-- Tab 栏设置
-- hide status bar
-- config.window_decorations = "RESIZE"
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.window_padding = { left = 8, right = 8, top = 8, bottom = 8 }
config.enable_scroll_bar = true
config.scrollback_lines = 10000

-- 性能优化
config.front_end = "WebGpu"
config.cursor_blink_rate = 0
config.window_background_opacity = 0.95

-- 取消实现的连字否则，否则不等号会显示为数学的不等号
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
-- ==============================================
-- 主题
-- ==============================================
config.color_scheme = "Catppuccin Mocha"

-- ==============================================
-- Tmux 风格快捷键（Ctrl+b）
-- ==============================================
-- tmux 风格 leader 键
config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = {
	-- leader + c 新 tab
	{ key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	-- leader + x 关闭 pane
	{ key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
	-- leader + z 最大化 pane
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
	-- leader + |左右分屏
	{ key = "|", mods = "LEADER|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	-- leader + verticle split
	{ key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	-- leader + hjkl 切换 pane
	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
}

-- Catppuccin UI 优化（tab、cursor、selection、split line）
config.colors = {
	tab_bar = {
		background = "#1e1e2e",
		active_tab = {
			bg_color = "#89b4fa",
			fg_color = "#1e1e2e",
		},
		inactive_tab = {
			bg_color = "#181825",
			fg_color = "#cdd6f4",
		},
		new_tab = {
			bg_color = "#181825",
			fg_color = "#cdd6f4",
		},
	},
	-- pane 分割线颜色
	split = "#313244",
	-- 光标
	cursor_bg = "#f5e0dc",
	cursor_border = "#f5e0dc",
	cursor_fg = "#1e1e2e",
	-- 选中文本
	selection_bg = "#585b70",
	selection_fg = "#cdd6f4",
}

-- Alt + 数字切换 tab
for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "ALT",
		action = act.ActivateTab(i - 1),
	})
end

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

-- ==============================================
-- 路径补全
-- ==============================================
config.enable_kitty_keyboard = true
config.enable_csi_u_key_encoding = true

return config
