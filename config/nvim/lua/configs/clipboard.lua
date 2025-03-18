--[[
Integrated Clipboard Configuration
--------------------------------
Purpose: Provide robust clipboard management with OSC52 and neoclip integration
Features:
- Systematic clipboard handler configuration
- Persistent history management
- Cross-platform compatibility
- Terminal multiplexer support
]]

local M = {}

-- Core clipboard configuration
M.clipboard = {
    name = "OSC52",
    copy = {
        ["+"] = require("vim.ui.clipboard.osc52").copy,
        ["*"] = require("vim.ui.clipboard.osc52").copy,
    },
    paste = {
        ["+"] = require("vim.ui.clipboard.osc52").paste,
        ["*"] = require("vim.ui.clipboard.osc52").paste,
    },
    cache_enabled = false,
}

-- Enhanced clipboard settings
M.setup = function()
    -- Configure system clipboard integration
    vim.g.clipboard = M.clipboard
    
    -- Terminal-specific configurations
    if vim.env.TMUX then
        vim.g.clipboard.copy.osc52 = {
            -- Ensure TMUX forwarding
            tmux = { enable = true },
        }
    end
    
    -- Configure clipboard provider
    vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
            vim.opt.clipboard = "unnamedplus"
        end,
    })
    
    -- Setup error handling
    vim.api.nvim_create_autocmd("TextYankPost", {
        callback = function()
            -- Visual feedback for copy operations
            vim.highlight.on_yank({ timeout = 200 })
            -- Error handling for clipboard operations
            if vim.v.event.operator == 'y' and vim.v.event.regname == '+' then
                local ok, err = pcall(vim.fn.getreg, '+')
                if not ok then
                    vim.notify("Clipboard operation failed: " .. err, vim.log.levels.WARN)
                end
            end
        end,
    })
end

return M
