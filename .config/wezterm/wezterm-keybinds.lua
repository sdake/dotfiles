-- Import wezterm API
local wezterm = require("wezterm")

-- Define the configuration table
-- In Lua, we can use the `---@type` comment convention to describe types for Lua logic checking
---@type table
local config = {}

-- Font configuration
---@type table
local font_config = {
	font = wezterm.font("MonoLisa"),
	font_size = 20.0,
}

-- Colors configuration
---@type table
local color_scheme_config = {
	-- Use a built-in scheme or customize your colors using "color_schemes" and refer here by name
	color_scheme = "rose pine",
	-- Alternatively, overwrite specific UI element colors
	force_reverse_video_cursor = true,
}

local colors_config = {
	selection_fg = "teal",
	selection_bg = "orange",
}

-- Tab bar appearance configuration
---@type table
local tab_bar_config = {
	hide_tab_bar_if_only_one_tab = true,
	show_new_tab_button_in_tab_bar = false,
}

-- Window configuration
---@type table
local window_config = {
	window_decorations = "RESIZE", -- Can be "RESIZE", "NONE", "TITLE", etc.
	enable_scroll_bar = false,
	window_background_opacity = 0.9,
	enable_tab_bar = true, -- Controls whether the tab bar is visible
}

local leader_config = {
	key = "a",
	mods = "CTRL",
	timeout_milliseconds = 2000,
}

-- Key bindings configuration
---@type table
local key_bindings = {
	-- Override default keybindings
	keys = {
		{

			mods = "CTRL",
			action = wezterm.action.CloseCurrentTab({ confirm = true }),
		},
		{
			key = "t",
			mods = "CTRL",
			action = wezterm.action.SpawnTab("DefaultDomain"),
		},
		{
			key = "d",
			mods = "CTRL",
			action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
		},
		-- Add additional keybindings as needed
	},
}

-- Miscellaneous configuration
---@type table
local misc_config = {
	audible_bell = "Disabled", -- Turn off the bell sound
	default_prog = { "/opt/homebrew/bin/fish", "-l" }, -- Defaults to zsh. Change this based on your shell.
}

-- Assign configurations to the main config table
-- This groups everything at the top level for easy access
config.font = font_config.font
config.font_size = font_config.font_size

for k, v in pairs(color_scheme_config) do
	config[k] = v
end

config.colors = colors_config
config.leader = leader_config

-- for k, v in pairs(colors_config) do
-- 	config[k] = v
-- end

for k, v in pairs(tab_bar_config) do
	config[k] = v
end

for k, v in pairs(window_config) do
	config[k] = v
end

for k, v in pairs(misc_config) do
	config[k] = v
end

config.keys = key_bindings.keys

-- Return the configuration to WezTerm
return config
