-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.mason = {
    pkgs = {
        --    "fish-language-server",
    },
}

M.base46 = {
    theme = "rosepinedawn",

    -- hl_override = {
    -- 	Comment = { italic = true },
    -- 	["@comment"] = { italic = true },
    -- },
}

-- M.nvdash = { load_on_startup = true }
-- M.ui = {
--       tabufline = {
--          lazyload = false
--      }
--}
--local osc52 = require("configs.osc52")

-- Initialize terminal-aware clipboard
local terminal_clip = require("configs.terminal_clipboard")
vim.g.clipboard = terminal_clip.clipboard

-- Setup verification tools
require("configs.clipboard_verify").setup()

M.setup = function()
    vim.api.nvim_set_var("clipboard", osc52.clipboard)
end

return M
