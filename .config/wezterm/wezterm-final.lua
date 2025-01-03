local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- General configuration
config.default_prog = { "/opt/homebrew/bin/fish", "-l" }
config.color_scheme = "rose-pine"
config.font = wezterm.font("MonoLisa", { weight = "Black" })
-- config.font = wezterm.font("Berkeley Mono Trial", { weight = "Black" })
-- config.window_frame = wezterm.font({
-- 	wezterm.font({ family = "MonoLisa", weight = "Black" }),
-- })
-- 	font_size = 9,

-- config.window_frame = wezterm.font({ family = "MonoLisa", weight = "Black"},

config.font_size = 20
config.enable_tab_bar = true
config.window_decorations = "RESIZE"
config.window_close_confirmation = "NeverPrompt"
config.scrollback_lines = 10000
config.adjust_window_size_when_changing_font_size = false
config.native_macos_fullscreen_mode = true
config.automatically_reload_config = true

-- ** Adaptive Animation for Variable Refresh Rate **
config.front_end = "OpenGL" -- GPU acceleration for smooth rendering
config.animation_fps = 120 -- Target 120 FPS for ProMotion, with room for VRR adjustment
-- config.debounce_text_changes = 3 -- Coarser debouncing to align with VRR latencies
config.max_fps = 120 -- Match animation FPS; this caps redraws to align with ProMotion

-- ** Smoother Scrolling and Mouse Selection **
-- config.scroll_lines_at_cursor = 3 -- Scroll 3 lines at a time for balanced performance and fluidity
-- config.selection_scrollback_behavior = "ScrollbackAndViewport" -- Keep selection smooth across scrollback buffer

-- Window padding and appearance
config.window_background_opacity = 1.00 -- Transparent background for better visuals
config.enable_scroll_bar = true -- Optional: Show a scrollbar for visible feedback

-- ** Enhanced Selection Visibility **
config.colors = {
	selection_fg = "teal",
	selection_bg = "orange",
	compose_cursor = "purple",
	-- Colors for copy_mode and quick_select
	-- available since: 20220807-113146-c2fee766
	-- In copy_mode, the color of the active text is:
	-- 1. copy_mode_active_highlight_* if additional text was selected using the mouse
	-- 2. selection_* otherwise
	copy_mode_active_highlight_bg = { Color = "#000000" },
	-- use `AnsiColor` to specify one of the ansi color palette values
	-- (index 0-15) using one of the names "Black", "Maroon", "Green",
	--  "Olive", "Navy", "Purple", "Teal", "Silver", "Grey", "Red", "Lime",
	-- "Yellow", "Blue", "Fuchsia", "Aqua" or "White".
	copy_mode_active_highlight_fg = { AnsiColor = "Black" },
	copy_mode_inactive_highlight_bg = { Color = "#52ad70" },
	copy_mode_inactive_highlight_fg = { AnsiColor = "White" },

	quick_select_label_bg = { Color = "peru" },
	quick_select_label_fg = { Color = "#ffffff" },
	quick_select_match_bg = { AnsiColor = "Navy" },
	quick_select_match_fg = { Color = "#ffffff" },
}
-- config.highlight_mouse_over_selected_text = true -- Highlight text when hovering

-- Cursor control
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

-- Update right-side status
wezterm.on("update-right-status", function(window, pane)
	local cwd = "unknown"
	local cwd_uri = pane:get_current_working_dir()

	if cwd_uri then
		local parsed_uri = wezterm.uri.parse(cwd_uri)
		if parsed_uri and parsed_uri.path then
			cwd = parsed_uri.path
		end
	end

	local time = wezterm.strftime("%H:%M:%S")
	local status = string.format("CWD: %s | Time: %s", cwd, time)
	window:set_right_status(status)
end)

-- Keybindings
config.keys = {
	{ key = "1", mods = "CTRL", action = wezterm.action.SwitchToWorkspace({ name = "dev" }) },
	{ key = "2", mods = "CTRL", action = wezterm.action.SwitchToWorkspace({ name = "perf" }) },
}

-- Launch and workspace management
wezterm.on("gui-startup", function(cmd)
	local mux = wezterm.mux

	-- Development workspace
	local dev = mux.spawn_window({ workspace = "dev" })
	dev:spawn_tab({
		label = "File manager",
		args = { "yazi" },
		set_environment_variables = { PATH = "/bin:/usr/bin:/opt/homebrew/bin" },
	})
	dev:spawn_tab({
		label = "Fish shell",
		args = { "/opt/homebrew/bin/fish", "-l" },
		set_environment_variables = { PATH = "/bin:/usr/bin:/opt/homebrew/bin" },
	})

	-- Performance workspace
	local perf = mux.spawn_window({ workspace = "perf" })
	perf:spawn_tab({
		label = "System performance",
		args = { "btop" },
		set_environment_variables = { PATH = "/bin:/usr/bin:/opt/homebrew/bin" },
	})
	perf:spawn_tab({
		label = "Fish shell",
		args = { "/opt/homebrew/bin/fish", "-l" },
		set_environment_variables = { PATH = "/bin:/usr/bin:/opt/homebrew/bin" },
	})

	wezterm.log_info("All windows and tabs assigned to workspaces successfully.")
end)

return config
