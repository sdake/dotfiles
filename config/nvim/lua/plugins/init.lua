--[[
NvChad 3.0 Plugin Configuration
------------------------------
Architecture:
- Core framework dependencies
- Development tools
- UI enhancements
- Clipboard management
]]

return {
    -- Core Framework Dependencies
    {
        "nvim-lua/plenary.nvim",
        lazy = false,
        priority = 1000,
    },
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
    },

    -- NvChad Core Components
    {
        "nvchad/ui",
        lazy = false,
        priority = 1000,
        config = function()
            require("nvchad")
        end,
    },
    {
        "nvchad/base46",
        lazy = true,
        priority = 900,
        build = function()
            require("base46").load_all_highlights()
        end,
    },
    {
        "nvchad/volt",
        lazy = false,
        priority = 900,
    },

    -- Development Tools
    {
        "stevearc/conform.nvim",
        event = { "BufReadPre", "BufNewFile" },
        cmd = { "ConformInfo" },
        opts = function()
            return require("configs.conform")
        end,
    },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("configs.lspconfig")
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = {
                "vim",
                "lua",
                "vimdoc",
                "html",
                "css",
            },
        },
    },

    -- Clipboard Management
    {
        "AckslD/nvim-neoclip.lua",
        event = "VeryLazy",
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "kkharji/sqlite.lua",
        },
        config = function()
            local neoclip_config = require("configs.neoclip")
            require("neoclip").setup(neoclip_config.setup)
            require("telescope").load_extension("neoclip")
        end,
    },
}
