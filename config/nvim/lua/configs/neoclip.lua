--[[
Neoclip Configuration
--------------------
Purpose: Configure persistent clipboard management
Architecture:
- SQLite-based persistence
- Telescope integration
- Clipboard synchronization
]]

local M = {}

-- Core configuration
M.setup = {
    -- Persistence configuration
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

    -- Performance optimization
    on_paste = {
        set_reg = true,
        move_cursor = false,
    },

    -- History management
    history = 1000,

    -- Database configuration
    db_config = {
        max_entries = 1000,
        compress = true,
    },
}

return M
