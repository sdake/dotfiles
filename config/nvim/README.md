# Development Tool Configuration Reference

Language Servers: https://github.com/neovim/nvim-lspconfig/tree/master/docs/configs.md

This table provides a comprehensive mapping between file types and their associated development
tools.

| Extension                       | Purpose               | Formatter                         | Language Server                 | Linter        |
| ------------------------------- | --------------------- | --------------------------------- | ------------------------------- | ------------- |
| **Python Development**          |
| .py                             | Python source         | ruff (primary), black (secondary) | pyright, ruff_lsp               | ruff          |
| .pyi                            | Python type stubs     | ruff                              | pyright                         | ruff          |
| .ipynb                          | Jupyter notebooks     | jupytext + black                  | pyright                         | nbqa          |
| **Go Development**              |
| .go                             | Go source             | gofumpt, goimports                | gopls                           | golangci-lint |
| .mod                            | Go modules            | gofmt                             | gopls                           | -             |
| **C/C++ Development**           |
| .c, .h                          | C source/headers      | clang-format                      | clangd                          | clang-tidy    |
| .cpp, .hpp                      | C++ source/headers    | clang-format                      | clangd                          | clang-tidy    |
| **Lua Development**             |
| .lua                            | Lua source            | stylua                            | lua_ls                          | luacheck      |
| .rockspec                       | Lua package spec      | stylua                            | lua_ls                          | -             |
| **Shell Scripting**             |
| .sh                             | Shell scripts         | shfmt                             | bashls                          | shellcheck    |
| .bash                           | Bash scripts          | shfmt                             | bashls                          | shellcheck    |
| .zsh                            | Zsh scripts           | shfmt                             | -                               | shellcheck    |
| **Configuration Files**         |
| .yaml, .yml                     | YAML data             | yamlfmt                           | yamlls                          | yamllint      |
| .toml                           | TOML config           | taplo                             | taplo                           | -             |
| .json                           | JSON data             | prettier                          | jsonls                          | jsonlint      |
| .hcl                            | HashiCorp config      | hclfmt                            | -                               | -             |
| .ini, .cfg                      | INI config            | prettier                          | -                               | -             |
| **Documentation**               |
| .md                             | Markdown docs         | prettier                          | marksman                        | markdownlint  |
| .mmd                            | Mermaid diagrams      | prettier                          | diagrams_language_server        | -             |
| **Templates**                   |
| .j2, .jinja2                    | Jinja templates       | djlint                            | -                               | djlint        |
| .html.j2                        | HTML templates        | djlint                            | -                               | djlint        |
| **Web Development**             |
| .html                           | HTML docs             | prettier                          | html                            | htmlhint      |
| .css                            | Stylesheets           | prettier                          | cssls                           | stylelint     |
| .scss                           | Sass stylesheets      | prettier                          | cssls                           | stylelint     |
| **Build Systems**               |
| Makefile                        | Make build rules      | beautysh                          | -                               | checkmake     |
| .mk                             | Make includes         | beautysh                          | -                               | checkmake     |
| GNUmakefile                     | GNU Make specific     | beautysh                          | -                               | checkmake     |
| CMakeLists.txt                  | CMake files           | cmake-format                      | cmake                           | cmakelint     |
| **Container and Orchestration** |
| Dockerfile                      | Container definition  | dockerfile-fmt, prettier          | dockerls                        | hadolint      |
| .dockerfile                     | Alternative Docker    | dockerfile-fmt, prettier          | dockerls                        | hadolint      |
| docker-compose.yml              | Container composition | yamlfmt                           | docker_compose_language_service | yamllint      |
| docker-compose.yaml             | Container composition | yamlfmt                           | docker_compose_language_service | yamllint      |
| **Kubernetes Resources**        |
| .yaml, .yml                     | K8s resources         | yamlfmt                           | yamlls                          | kubeval       |
| kustomization.yaml              | Kustomize config      | yamlfmt                           | yamlls                          | kubeval       |
| Chart.yaml                      | Helm charts           | yamlfmt                           | helm_ls                         | yamllint      |
| values.yaml                     | Helm values           | yamlfmt                           | helm_ls                         | yamllint      |
| .helmignore                     | Helm ignore rules     | prettier                          | -                               | -             |
| **Infrastructure as Code**      |
| .tf                             | Terraform config      | terraform fmt                     | terraform_ls                    | tflint        |
| .tfvars                         | Terraform variables   | terraform fmt                     | terraform_ls                    | tflint        |
| .tfstate                        | Terraform state       | prettier                          | -                               | -             |
| .hcl                            | HCL configuration     | hclfmt                            | -                               | -             |

Tool selection priorities:

1. Speed and reliability of formatting
2. Integration with language servers for real-time feedback
3. Industry standard acceptance and maintenance status

The configuration files in this repository aim to implement these tools through Mason package
management and conform.nvim formatting engine.
