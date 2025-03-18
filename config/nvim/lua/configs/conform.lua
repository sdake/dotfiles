local M = {}

-- Formatter configurations with standardized settings
M.formatters = {
    -- Lua formatting
    stylua = {
        prepend_args = {
            "--column-width",
            "100",
            "--indent-type",
            "Spaces",
            "--indent-width",
            "4",
            "--quote-style",
            "AutoPreferDouble",
            "--call-parentheses",
            "Always",
        },
    },

    -- Web and documentation formatting
    prettier = {
        prepend_args = {
            "--print-width",
            "100",
            "--prose-wrap",
            "always",
            "--tab-width",
            "4",
        },
    },

    -- Markdown TOC generation
    ["markdown-toc"] = {
        prepend_args = {
            "--bullets='-'",
            "--max-depth=4",
        },
    },
}

-- Comprehensive formatter mappings by file type
M.formatters_by_ft = {
    -- Shell and system
    bash = { "beautysh" },
    fish = { "fish_indent" },

    -- C/C++ ecosystem
    c = { "clang-format" },
    cpp = { "clang-format" },
    cmake = { "cmake_format" },

    -- Web development
    css = { "prettier" },
    html = { "prettier" },
    javascript = { "prettier" },
    typescript = { "prettier" },

    -- Configuration formats
    json = { "prettier", "fixjson" },
    yaml = { "yamlfix" },
    toml = { "taplo" },

    -- Container and service definitions
    dockerfile = { "lsp" },
    proto = { "buf" },

    -- Programming languages
    go = { "gofumpt", "goimports" },
    lua = { "stylua" },
    python = { "black", "isort" },
    rust = { "rustfmt" },

    -- Documentation
    markdown = {
        "prettier",
        "markdown-toc",
    },
}

-- Diagnostic setup for troubleshooting
M.setup = {
    -- Enable detailed logging for debugging
    log_level = vim.log.levels.INFO,

    -- Format behavior configuration
    format_on_save = {
        timeout_ms = 3000,
        lsp_fallback = true,
    },

    -- Error notification configuration
    notify_on_error = true,
}

return M
