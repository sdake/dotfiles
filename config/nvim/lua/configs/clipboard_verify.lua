--[[
Clipboard Verification Suite
--------------------------
Purpose: Verify clipboard functionality across different environments
Features:
- Terminal capability detection
- OSC52 support verification
- Clipboard operation validation
]]

local M = {}

-- Verification utilities
function M.verify_clipboard()
    local results = {
        osc52 = false,
        tmux = false,
        system = false,
        neoclip = false
    }
    
    -- Check OSC52 support
    local function check_osc52()
        local test_content = "OSC52 Test String"
        local ok = pcall(vim.fn.setreg, '+', test_content)
        if ok then
            local content = vim.fn.getreg('+')
            return content == test_content
        end
        return false
    end
    
    -- Verify environment
    local env = {
        tmux = vim.env.TMUX ~= nil,
        term = vim.env.TERM,
        ssh = vim.env.SSH_CLIENT ~= nil
    }
    
    -- Run verifications
    results.osc52 = check_osc52()
    results.tmux = env.tmux
    
    -- Check neoclip
    local ok, neoclip = pcall(require, "neoclip")
    results.neoclip = ok
    
    -- Report results
    local report = {
        "Clipboard Verification Results:",
        string.format("- OSC52 Support: %s", results.osc52 and "Yes" or "No"),
        string.format("- TMUX Detection: %s", results.tmux and "Yes" or "No"),
        string.format("- Terminal Type: %s", env.term or "Unknown"),
        string.format("- SSH Session: %s", env.ssh and "Yes" or "No"),
        string.format("- Neoclip Available: %s", results.neoclip and "Yes" or "No")
    }
    
    vim.notify(table.concat(report, "\n"), vim.log.levels.INFO)
    return results
end

-- Verification command setup
function M.setup()
    vim.api.nvim_create_user_command("VerifyClipboard", function()
        M.verify_clipboard()
    end, {})
end

return M
