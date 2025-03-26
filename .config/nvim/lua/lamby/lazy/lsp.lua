return {
    "neovim/nvim-lspconfig",
    dependencies = {
        -- Basic functionality
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
    },

    config = function()

        -- Setup LSPs
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "ruff",
                "pyright",
                "lua_ls",
                "zls",
                "ols",
                "ocamllsp",
                "clangd"
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                    }
                end,

                zls = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.zls.setup({
                        root_dir = lspconfig.util.root_pattern(".git", "build.zig", "zls.json"),
                        settings = {
                            zls = {
                                enable_inlay_hints = true,
                                enable_snippets = true,
                                warn_style = true,
                            },
                        },
                    })
                    vim.g.zig_fmt_parse_errors = 0
                    vim.g.zig_fmt_autosave = 0
                end,

                ["ols"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.ols.setup({
                        init_options = {
                            checker_args = "-vet -strict-style"
                        },
                        filetypes = {'odin'},
                        root_dir = lspconfig.util.root_pattern(".git", "ols.json", "*.odin"),
                    })
                end,

                ["ruff"] = function()
                    local lspconfig = require("lspconfig")
                    local on_attach = function(client, bufnr)
                        client.server_capabilities.hoverProvider = false
                    end
                    lspconfig.ruff.setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
                    })
                end,

                ["pyright"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.pyright.setup {
                        capabilities = capabilities,
                        settings = {
                            pyright = {
                                -- Using Ruff's import organizer
                                disableOrganizeImports = true,
                            },
                            python = {
                                analysis = {
                                    -- Ignore all files for analysis to exclusively use Ruff for linting
                                    ignore = { '*' },
                                },
                            },
                        }
                    }
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { 'vim' },
                                }
                            }
                        }
                    }
                end,

                ["ocamllsp"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.ocamllsp.setup {
                    }
                end,
                ["clangd"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.clangd.setup {
                    }
                end

            }
        })
    end
}
