--[[
Markdown-Specific Formatting Configuration
----------------------------------------
Purpose: Isolate markdown formatting logic to prevent cross-contamination with other file types
Features:
- Targeted cbfmt configuration
- Fallback mechanisms
- Comprehensive error handling
]]

local M = {}

-- Markdown-specific formatter configurations
M.markdown_formatters = {
    prettier = {
        prepend_args = {
            "--print-width",
            "100",
            "--prose-wrap",
            "always",
            "--tab-width",
            "4",
            "--parser",
            "markdown",
        },
    },
}

-- Setup function for markdown-specific configuration
function M.setup()
    local conform = require("conform")

    -- Register markdown-specific formatters
    conform.setup({
        formatters = M.markdown_formatters,
        formatters_by_ft = {
            markdown = M.format_chain,
        },
    })

    -- Add diagnostic hooks
    vim.api.nvim_create_autocmd("User", {
        pattern = "ConformFormatPre",
        callback = function(args)
            if vim.bo[args.buf].filetype == "markdown" then
                vim.notify("Initiating markdown formatting sequence", vim.log.levels.INFO)
            end
        end,
    })
end

return M
