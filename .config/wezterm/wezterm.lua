-- Import wezterm API
local wezterm = require("wezterm")

-- Define the configuration table
local config = {

	-- Font configuration
	font = wezterm.font({ family = "MonoLisa", weight = "Black" }),
	font_size = 20.0,
	adjust_window_size_when_changing_font_size = false,

	-- Window configuration
	window_decorations = "INTEGRATED_BUTTONS|RESIZE",
	enable_scroll_bar = false,
	window_background_opacity = 1.0,
	enable_tab_bar = true,
	integrated_title_button_color = "red",

	initial_cols = 126,
	initial_rows = 37,

	-- Colors configuration
	color_scheme = "rose-pine",
	force_reverse_video_cursor = true,

	-- Tab bar appearance configuration
	hide_tab_bar_if_only_one_tab = true,
	show_new_tab_button_in_tab_bar = false,
	use_fancy_tab_bar = true,
	tab_max_width = 40,
	switch_to_last_active_tab_when_closing_tab = true,
	tab_bar_at_bottom = true,

	-- Dim inactive pane
	inactive_pane_hsb = {
		saturation = 1.0,
		brightness = 0.4,
	},

	-- Performance & Usability Improvements
	animation_fps = 120,
	scroll_to_bottom_on_input = true,
	cursor_blink_rate = 500,
	front_end = "WebGpu",

	audible_bell = "Disabled",
	default_prog = { "/opt/homebrew/bin/fish", "-l" },
	use_dead_keys = false,
	scrollback_lines = 5000,
	automatically_reload_config = true,

	-- Color overrides
	colors = {
		selection_fg = "teal",
		selection_bg = "orange",
	},

	-- Window frame configuration
	window_frame = {
		font = wezterm.font({ family = "MonoLisa", weight = "Black" }),
		font_size = 16,

		active_titlebar_fg = "#ffffff",
		active_titlebar_border_bottom = "#ffffff",
		inactive_titlebar_fg = "#000000",
		inactive_titlebar_border_bottom = "#ffffff",
		button_fg = "#ffffff",
		button_bg = "#ffffff",
		button_hover_fg = "#ffffff",
		button_hover_bg = "#ffffff",
	},

	disable_default_key_bindings = true,
	keys = {
		{
			key = "+",
			mods = "CTRL",
			action = wezterm.action.IncreaseFontSize,
		},
		{
			key = "-",
			mods = "CTRL",
			action = wezterm.action.DecreaseFontSize,
		},
		{
			key = "|",
			mods = "CMD",
			action = wezterm.action.SplitPane({ direction = "Right" }),
			size = { Percent = 50 },
		},
		{
			key = "-",
			mods = "CMD",
			action = wezterm.action.SplitPane({ direction = "Down" }),
			size = { Percent = 50 },
		},
		{
			key = "v",
			mods = "CMD",
			action = wezterm.action.PasteFrom("Clipboard"),
		},
		{
			key = "h",
			mods = "CMD",
			action = wezterm.action.ActivatePaneDirection("Left"),
		},
		{
			key = "l",
			mods = "CMD",
			action = wezterm.action.ActivatePaneDirection("Right"),
		},
		{
			key = "t",
			mods = "CTRL",
			action = wezterm.action.SpawnTab("DefaultDomain"),
		},
		{
			key = "j",
			mods = "CMD",
			action = wezterm.action.ActivatePaneDirection("Down"),
		},
		{
			key = "k",
			mods = "CMD",
			action = wezterm.action.ActivatePaneDirection("Up"),
		},
	},
}

return config
