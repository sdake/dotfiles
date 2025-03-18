local M = {}

-- Diagnostic function to verify formatter availability
function M.check_formatters()
    local conform = require("conform")
    local formatters = conform.list_formatters()
    local available = {}
    local unavailable = {}

    for _, formatter in ipairs(formatters) do
        if formatter.available then
            table.insert(available, formatter.name)
        else
            table.insert(unavailable, {
                name = formatter.name,
                error = formatter.error or "Unknown error",
            })
        end
    end

    -- Print results
    print("\nAvailable formatters:")
    for _, name in ipairs(available) do
        print("✓ " .. name)
    end

    print("\nUnavailable formatters:")
    for _, formatter in ipairs(unavailable) do
        print("✗ " .. formatter.name .. ": " .. formatter.error)
    end
end

-- Setup diagnostic event listeners
function M.setup()
    vim.api.nvim_create_autocmd("User", {
        pattern = "ConformFormatPre",
        callback = function(args)
            local bufname = vim.fn.bufname(args.buf)
            vim.notify("Formatting triggered for: " .. bufname, vim.log.levels.INFO)
        end,
    })
end

return M
