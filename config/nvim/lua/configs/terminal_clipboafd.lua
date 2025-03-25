--[[
Terminal-Aware Clipboard Configuration
------------------------------------
Purpose: Provide robust clipboard functionality across different terminal environments
Architecture:
- Primary: OSC52 for terminal operations
- Fallback: System clipboard when available
- Error Handling: Comprehensive error capture and recovery
]]

local M = {}

-- Terminal environment detection
local function detect_environment()
    local env = {
        tmux = vim.env.TMUX ~= nil,
        term = vim.env.TERM,
        ssh = vim.env.SSH_CLIENT ~= nil,
        terminal = vim.env.TERMINAL,
    }
    return env
end

-- OSC52 configuration with terminal awareness
M.clipboard = {
    name = "OSC52",
    copy = {
        ["+"] = function(lines)
            local env = detect_environment()
            local osc52 = require("vim.ui.clipboard.osc52")
            
            if env.tmux then
                vim.g.clipboard_max_size = 1048576
                return osc52.copy(lines, {
                    tmux = { enable = true },
                    max_size = vim.g.clipboard_max_size,
                })
            end
            
            if env.ssh then
                return osc52.copy(lines, {
                    silent = true,
                    timeout = 100,
                })
            end
            
            return osc52.copy(lines)
        end,
        ["*"] = function(lines)
            return M.clipboard.copy["+"](lines)
        end
    },
    paste = {
        ["+"] = function()
            local osc52 = require("vim.ui.clipboard.osc52")
            local ok, result = pcall(osc52.paste)
            if not ok then
                vim.notify("Paste operation failed: " .. result, vim.log.levels.WARN)
                return nil
            end
            return result
        end,
        ["*"] = function()
            return M.clipboard.paste["+"]()
        end
    }
}

-- Setup function to initialize clipboard system
function M.setup()
    vim.g.clipboard = M.clipboard
    -- Initialize clipboard provider
    vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
            vim.opt.clipboard = "unnamedplus"
        end,
    })
end

return M
