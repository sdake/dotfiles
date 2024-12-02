local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- General configuration
config.default_prog = { "/opt/homebrew/bin/fish", "-l" }
config.color_scheme = "rose-pine"
config.font = wezterm.font("MonoLisa", { weight = "Black" })
config.font_size = 20
config.enable_tab_bar = true
config.window_decorations = "RESIZE"
config.window_close_confirmation = "NeverPrompt"
config.max_fps = 144
config.scrollback_lines = 10000
config.adjust_window_size_when_changing_font_size = false
config.native_macos_fullscreen_mode = true
config.automatically_reload_config = true

-- Window padding
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- Cursor control
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

-- Safely handle update-right-status event
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
		args = { "yazi" },
		set_environment_variables = { PATH = "/bin:/usr/bin:/opt/homebrew/bin" },
	})
	dev:spawn_tab({
		args = { "/opt/homebrew/bin/fish", "-l" },
		set_environment_variables = { PATH = "/bin:/usr/bin:/opt/homebrew/bin" },
	})

	-- Performance workspace
	local perf = mux.spawn_window({ workspace = "perf" })
	perf:spawn_tab({
		args = { "btop" },
		set_environment_variables = { PATH = "/bin:/usr/bin:/opt/homebrew/bin" },
	})
	perf:spawn_tab({
		args = { "/opt/homebrew/bin/fish", "-l" },
		set_environment_variables = { PATH = "/bin:/usr/bin:/opt/homebrew/bin" },
	})

	wezterm.log_info("All windows and tabs assigned to workspaces successfully.")
end)

return config
