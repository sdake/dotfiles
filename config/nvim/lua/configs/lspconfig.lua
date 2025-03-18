require("nvchad.configs.lspconfig").defaults()

local lspconfig = require("lspconfig")

-- autotools, buf, cmake, clang, css, deb, docker, fish, go, helm, html, json, lua,
-- python, rust, toml, typescript, yaml
--

local servers = {
    "autotools_ls",
    "bashls",
    "biome",
    "buf_ls",
    "clangd",
    "cmake",
    "cssls",
    "cssmodules_ls",
    "debputy",
    "docker_compose_language_service",
    "dockerls",
    "dprint",
    "gopls",
    "helm_ls",
    "html",
    "jsonls",
    "lua_ls",
    "pyright",
    "pyright",
    "ruff",
    "rust_analyzer",
    "taplo",
    "ts_ls",
    "vale_ls",
    "yamlls",
}

-- Server initialization
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup({
        on_attach = require("nvchad.configs.lspconfig").on_attach,
        on_init = require("nvchad.configs.lspconfig").on_init,
        capabilities = require("nvchad.configs.lspconfig").capabilities,
    })
end
