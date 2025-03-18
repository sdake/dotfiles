--[[
Markdown LSP Configuration
-------------------------
Purpose: Control LSP behavior for markdown files
Features:
- Selective warning suppression
- Technical term handling
- Performance optimization
]]

local M = {}

-- LSP configuration for markdown files
function M.setup()
    local lspconfig = require("lspconfig")

    -- Harper LSP configuration with reduced noise
    lspconfig.harper_ls.setup({
        -- Restrict to markdown files only
        filetypes = { "markdown" },

        -- Core configuration
        settings = {
            ["harper-ls"] = {
                linters = {
                    -- Disable noisy checks
                    spell_check = false,
                    boring_words = false,
                    matcher = false,

                    -- Enable essential formatting checks only
                    spaces = true,
                    unclosed_quotes = true,
                    wrong_quotes = true,

                    -- Explicitly disable technical term interference
                    amazon_names = false,
                    google_names = false,
                    meta_names = false,
                    microsoft_names = false,
                    apple_names = false,
                    azure_names = false,
                },
            },
        },

        -- Enhanced initialization options
        init_options = {
            -- Reduce update frequency
            diagnosticPollInterval = 1000,
            -- Increase hover detail threshold
            hoverDetailThreshold = 1000,
        },

        -- Configure specific capabilities
        capabilities = {
            textDocument = {
                publishDiagnostics = {
                    -- Reduce diagnostic noise
                    relatedInformation = false,
                    -- Increase diagnostic threshold
                    diagnosticDelay = 1000,
                },
            },
        },
    })
end

return M
