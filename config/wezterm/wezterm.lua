-- Import wezterm API
local wezterm = require("wezterm")

-- Define the configuration table
local config = {
	-- Font configuration
	-- font weights:
	-- Thin, ExtraLight, Light, Regular, Medium, SemiBold, Bold, ExtraBold, Black

	font = wezterm.font({ family = "MonoLisaVariable Nerd Font", weight = "Bold" }),
	font_size = 20.0,
	adjust_window_size_when_changing_font_size = false,
	-- List of harfbuzz features: https://wakamaifondue.com/
	-- Font from: https://www.monolisa.dev/orders
	-- aalt

	harfbuzz_features = {
		"rlig = 1",
		"sinf = 0",
		-- Accesses all alternate glyphs if available.
		"aalt = 0",
		"calt = 1",
		-- Adjusts uppercase letters and numbers to be suitable for casing (e.g., titles).
		"case = 0",
		"ccmp = 1",
		-- Converts numbers to denominator style (used in fractions).
		"dnom = 0",
		-- Formats numbers to display as fractions.
		"frac = 0",
		"liga = 1",
		"locl = 1",
		-- Converts numbers to numerator style (used in fractions).
		"numr = 0",
		-- Transforms numbers to old-style figures (proportional and varying heights).
		"onum = 1",
		-- Formats numbers or letters as ordinal indicators (e.g., 1st, 2nd).
		"ordn = 0",
		"rlig = 1",
		"sinf = 1",
		-- Formats text or numbers as scientific inferiors.
		"sinf = 0",
		-- Enables alternative stylistic set 01 for specific glyph designs.
		"ss01 = 1",
		-- Enables alternative stylistic set 03 for specific glyph designs.
		"ss03 = 1",
		-- Enables alternative stylistic set 04 for specific glyph designs.
		"ss04 = 1",
		-- Enables alternative stylistic set 05 for specific glyph designs.
		"ss05 = 1",
		-- Enables alternative stylistic set 06 for specific glyph designs.
		"ss06 = 1",
		-- Enables alternative stylistic set 08 for specific glyph designs.
		"ss08 = 1",
		-- Enables alternative stylistic set 09 for specific glyph designs.
		"ss09 = 1",
		-- Enables alternative stylistic set 12 for specific glyph designs.
		"ss12 = 1",
		-- Enables alternative stylistic set 14 for specific glyph designs.
		"ss14 = 1",
		-- Enables alternative stylistic set 17 for specific glyph designs.
		"ss17 = 1",
		-- Enables alternative stylistic set 18 for specific glyph designs.
		"ss18 = 1",
		-- Formats glyphs as subscripts (smaller and below the baseline).
		"subs = 0",
		-- Formats glyphs as superscripts (smaller and above the baseline).
		"sups = 0",
		"mark = 1",
		"mkmk = 1",
	},

	-- Window configuration
	--  window_decorations = "INTEGRATED_BUTTONS|RESIZE",
	enable_scroll_bar = true,
	window_background_opacity = 1.0,
	integrated_title_button_color = "red",

	initial_cols = 126,
	initial_rows = 37,

	-- Colors configuration
	color_scheme = "rose-pine-moon",
	force_reverse_video_cursor = true,

	-- Tab bar appearance configuration
	enable_tab_bar = true,
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

	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 10,
	},

	-- Performance & Usability Improvements
	animation_fps = 120,
	max_fps = 120,
	scroll_to_bottom_on_input = true,
	default_cursor_style = "BlinkingBlock", -- Options: BlinkingBlock, BlinkingUnderline, BlinkingBar
	cursor_blink_rate = 500,
	front_end = "WebGpu",
	audible_bell = "Disabled",
	default_prog = { "/opt/homebrew/bin/fish", "-l" },
	use_dead_keys = false,
	scrollback_lines = 5000,
	automatically_reload_config = true,
	enable_kitty_graphics = false,

	-- Color overrides
	colors = {
		selection_fg = "teal",
		selection_bg = "orange",
		cursor_bg = "blue",
		cursor_fg = "white",
		cursor_border = "blue",
	},

	-- Window frame configuration
	window_frame = {
		font = wezterm.font({ family = "MonoLisaVariable Nerd Font", weight = "Bold" }),
		font_size = 14.0,

		active_titlebar_fg = "#ffffff",
		active_titlebar_border_bottom = "#ffffff",
		inactive_titlebar_fg = "#000000",
		inactive_titlebar_border_bottom = "#ffffff",
		button_fg = "#ffffff",
		button_bg = "#ffffff",
		button_hover_fg = "#ffffff",
		button_hover_bg = "#ffffff",
	},

	--	disable_default_key_bindings = true,

	-- ---
	--
	-- Used defaults generated from `wezterm show-keys --lua`

	keys = {
		{
			key = "+",
			mods = "SUPER",
			action = wezterm.action.IncreaseFontSize,
		},
		{
			key = "-",
			mods = "SUPER",
			action = wezterm.action.DecreaseFontSize,
		},
		{
			key = "p",
			mods = "SUPER",
			action = wezterm.action.CopyTo("Clipboard"),
		},
		{
			key = "v",
			mods = "SUPER",
			action = wezterm.action.PasteFrom("Clipboard"),
		},
		{
			key = "|",
			mods = "CTRL",
			action = wezterm.action.SplitPane({ direction = "Right" }),
			size = { Percent = 50 },
		},
		{
			key = "-",
			mods = "CTRL",
			action = wezterm.action.SplitPane({ direction = "Down" }),
			size = { Percent = 50 },
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
