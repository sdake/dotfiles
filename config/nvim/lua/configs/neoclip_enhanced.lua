--[[
Enhanced Neoclip Configuration
-----------------------------
Purpose: Provide persistent clipboard history with Telescope integration
Features:
- SQLite-based persistence
- Telescope keybindings
- Continuous synchronization
- Error recovery mechanisms
]]

local M = {}

-- Core neoclip configuration
M.setup = {
    enable_persistent_history = true,
    continuous_sync = true,
    db_path = vim.fn.expand("~/.config/nvim/neoclip.sqlite3"),

    -- Telescope integration
    keys = {
        telescope = {
            i = {
                paste = "<CR>",
                paste_behind = "<C-p>",
                replay = "<C-q>",
                delete = "<C-d>",
                custom = {},
            },
        },
    },

    -- Enhanced functionality
    on_paste = {
        -- Set yanked text to unnamed register
        set_reg = true,
        -- Maintain cursor position
        move_cursor = false,
    },

    -- History management
    history = 1000,

    -- Error recovery
    on_select = {
        -- Validate clipboard content before paste
        validate = function(content)
            if #content > 100000 then
                vim.notify("Clipboard content exceeds size limit", vim.log.levels.WARN)
                return false
            end
            return true
        end,
    },

    -- Database configuration
    db_config = {
        -- Automatic pruning
        max_entries = 1000,
        -- Compression for large entries
        compress = true,
    },
}

-- Setup function with error handling
function M.init()
    local ok, neoclip = pcall(require, "neoclip")
    if not ok then
        vim.notify("Failed to load neoclip", vim.log.levels.ERROR)
        return
    end

    -- Initialize with error handling
    ok, err = pcall(neoclip.setup, M.setup)
    if not ok then
        vim.notify("Failed to setup neoclip: " .. err, vim.log.levels.ERROR)
        return
    end

    -- Setup telescope integration
    if pcall(require, "telescope") then
        require("telescope").load_extension("neoclip")
    end
end

return M
