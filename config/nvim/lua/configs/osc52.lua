local M = {}

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

return M
