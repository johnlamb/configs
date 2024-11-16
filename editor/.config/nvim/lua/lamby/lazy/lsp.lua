return {
    "neovim/nvim-lspconfig",
    dependencies = {
        -- Basic functionality
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        {
            "hrsh7th/nvim-cmp",
            event = { "InsertEnter", "CmdlineEnter" },
        },

        -- For snipping
        {
            "L3MON4D3/LuaSnip",
            update_events = 'TextChanged,TextChangedI',
            "saadparwaiz1/cmp_luasnip",
        }
    },

    config = function()
        local luasnip = require("luasnip")
        local cmp_autopairs = require('nvim-autopairs.completion.cmp')
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "ruff",
                "pyright",
                "lua_ls",
                "zls"
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
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
                                    globals = {'vim'},
                                }
                            }
                        }
                    }
                end
            }
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            completion = { completeopt = 'menuone,noinsert,preview'},
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),

                ['<CR>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        if luasnip.expandable() then
                            luasnip.expand()
                        else
                            cmp.confirm({
                                select = true,
                            })
                        end
                    else
                        fallback()
                    end
                end),

                ["<Tab>"] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                    cmp.select_next_item()
                  elseif luasnip.locally_jumpable(1) then
                    luasnip.jump(1)
                  else
                    fallback()
                  end
                end, { "i", "s" }),

                ["<S-Tab>"] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                    cmp.select_prev_item()
                  elseif luasnip.locally_jumpable(-1) then
                    luasnip.jump(-1)
                  else
                    fallback()
                  end
                end, { "i", "s" }),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'buffer' },
            })
        })
        cmp.event:on(
          'confirm_done',
          cmp_autopairs.on_confirm_done()
        )

        -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
       cmp.setup.cmdline({ '/', '?' }, {
         mapping = cmp.mapping.preset.cmdline(),
         sources = {
           { name = 'buffer' }
         }
       })

       -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
       cmp.setup.cmdline(':', {
         mapping = cmp.mapping.preset.cmdline(),
         sources = cmp.config.sources({
           { name = 'path' }
         }, {
           { name = 'cmdline' }
         }),
         matching = { disallow_symbol_nonprefix_matching = false }
       })
        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}
