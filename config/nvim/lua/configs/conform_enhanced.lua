--[[
Enhanced Conform Configuration
-----------------------------
Purpose: Provide robust formatter definitions with comprehensive error handling
Features:
- Explicit formatter configurations
- LSP integration framework
- Systematic error handling
- Formatter availability verification
]]

local M = {}

-- Formatter command verification utilities
local function verify_command(cmd)
    if type(cmd) ~= "string" then return false end
    local handle = io.popen("which " .. cmd .. " 2>/dev/null")
    if not handle then return false end
    local result = handle:read("*a")
    handle:close()
    return result ~= ""
end

-- Formatter definitions with explicit configurations
M.formatters = {
    -- Rust formatting
    rustfmt = {
        command = "rustfmt",
        args = { "--edition", "2021" },
        -- Verify rustfmt installation
        condition = function()
            return verify_command("rustfmt")
        end,
    },
    
    -- LSP-based formatting
    lsp = {
        -- Explicit LSP configuration
        command = "nvim",
        args = {
            "--headless",
            "--noplugin",
            "-c", "lua vim.lsp.buf.format()",
        },
    },
    
    -- Retain existing formatter configurations
    stylua = {
        prepend_args = {
            "--column-width", "100",
            "--indent-type", "Spaces",
            "--indent-width", "4",
            "--quote-style", "AutoPreferDouble",
            "--call-parentheses", "Always",
        },
    },
    
    prettier = {
        prepend_args = {
            "--print-width", "100",
            "--prose-wrap", "always",
            "--tab-width", "4",
        },
    },
}

-- Enhanced formatter mapping with fallback mechanisms
M.formatters_by_ft = {
    -- Systems and Shell
    bash = { "beautysh" },
    fish = { "fish_indent" },
    
    -- C/C++ ecosystem
    c = { "clang-format" },
    cpp = { "clang-format" },
    cmake = { "cmake_format" },
    
    -- Web technologies
    css = { "prettier" },
    html = { "prettier" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    
    -- Configuration formats
    json = { "prettier", "fixjson" },
    yaml = { "yamlfix" },
    toml = { "taplo" },
    
    -- Service definitions
    dockerfile = { "lsp" },
    proto = { "buf" },
    
    -- Programming languages
    go = { "gofumpt", "goimports" },
    lua = { "stylua" },
    python = { "black", "isort" },
    rust = { "rustfmt" },
    
    -- Documentation
    markdown = { "prettier", "cbfmt", "markdown-toc" },
}

-- Configuration verification and setup
function M.setup()
    local conform = require("conform")
    
    -- Initialize with enhanced error handling
    conform.setup({
        formatters = M.formatters,
        formatters_by_ft = M.formatters_by_ft,
        
        -- Error handling configuration
        format_on_save = {
            timeout_ms = 3000,
            lsp_fallback = true,
        },
        
        -- Logging configuration
        log_level = vim.log.levels.INFO,
        
        -- Formatter verification hooks
        notify_on_error = true,
    })
    
    -- Verify critical formatters
    for name, config in pairs(M.formatters) do
        if config.command and not verify_command(config.command) then
            vim.notify(
                string.format("Formatter '%s' not found in PATH", name),
                vim.log.levels.WARN
            )
        end
    end
end

return M
