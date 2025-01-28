-- Formatters by file type
local formatters_by_ft = {
  bash = { "beautysh" },
  c = { "clang-format" },
  cmake = { "cmake_format" },
  cpp = { "clang-format" },
  css = { "prettier" },
  fish = { "fish_indent" },
  go = { "gofumpt", "goimports" },
  html = { "prettier" },
  javascript = { "prettier" },
  json = { "prettier", "fixjson" },
  lua = { "stylua" },
  markdown = { "prettier", "cbfmt", "markdown-toc" },
  proto = { "buf" },
  python = { "black", "isort" },
  rust = { "rustfmt" },
  toml = { "taplo" },
  typescript = { "prettier" },
  yaml = { "yamlfix" },
}

-- Formatter individual configs
local formatters = {
  stylua = {
    prepend_args = {
      "--column-width",
      "100",
      "--indent-type",
      "Spaces",
      "--indent-width",
      "2",
      "--quote-style",
      "AutoPreferDouble",
      "--call-parentheses",
      "Always",
    },
  },
  prettier = {
    prepend_args = {
      "--print-width",
      "100",
      "--prose-wrap",
      "always",
      "--tab-width",
      "2",
    },
  },
  cbfmt = {
    prepend_args = {
      "--best-effort",
    },
  },
  ["markdown-toc"] = {
    prepend_args = {
      "--bullets='-'",
      "--max-depth=4",
    },
  },
}

return {
  formatters = formatters,
  formatters_by_ft = formatters_by_ft,
}
