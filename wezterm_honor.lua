local wezterm = require("wezterm")
local act = wezterm.action

local config = {}
config.default_prog = { "pwsh.exe", "-NoLogo" }

config.term = "xterm-256color"
config.font_size = 13
config.color_scheme = "Catppuccin Mocha"
config.window_background_opacity = 0.85
-- Acrylic, Tabbed, Auto
config.win32_system_backdrop = "Auto"

-- hide status bar
-- config.window_decorations = "RESIZE"
-- Tab 栏设置
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true

config.window_padding = {
	left = 10,
	right = 10,
	top = 8,
	bottom = 8,
}

-- tmux 风格 leader 键
config.leader = { key = "l", mods = "CTRL", timeout_milliseconds = 1000 }

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

-- Alt + 数字切换 tab
for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "ALT",
		action = act.ActivateTab(i - 1),
	})
end

config.mouse_bindings = {
	{
		event = { Down = { streak = 1, button = "Right" } },
		mods = "NONE",
		action = act.PasteFrom("Clipboard"),
	},
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

-- 按住shift可以在nvim中实现到wezterm的复制
config.bypass_mouse_reporting_modifiers = "SHIFT"

config.set_environment_variables = {
	HTTP_PROXY = "",
	HTTPS_PROXY = "",
	NO_PROXY = "localhost,127.0.0.1,.hihonor.com,.honor.com",
}

return config
