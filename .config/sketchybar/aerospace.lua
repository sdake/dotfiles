-- Require the sketchybar module
local sbar = require("sketchybar")
for k, v in pairs(sbar) do
	print(k, v)
end

-- Function to set up aerospace-related configuration
local function setup_aerospace()
	-- Add the aerospace_workspace_change event
	sbar.add_event("aerospace_workspace_change")

	-- Fetch workspace IDs and configure SketchyBar items
	sbar.exec("aerospace list-workspaces --all", function(result, exit_code)
		workspaces = result
	end)

	for sid in workspaces:gmatch("%S+") do
		sbar.add_item("space." .. sid, "left")
		sbar.subscribe_item("space." .. sid, { "aerospace_workspace_change" })
		sbar.set_item("space." .. sid, {
			background_color = "0x44ffffff",
			background_corner_radius = 5,
			background_height = 20,
			background_drawing = "off",
			label = sid,
			click_script = "aerospace workspace " .. sid,
			script = os.getenv("CONFIG_DIR") .. "/plugins/aerospace.sh " .. sid,
		})
	end
end

-- Return the function so it can be called in init.lua
return setup_aerospace
