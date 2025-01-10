require("lamby.set")
require("lamby.remap")
require("lamby.lazy_init")
require("lamby.floatingterminal")

-- Gruvbox colorscheme
vim.o.background = "dark"
vim.cmd([[colorscheme gruvbox]])

local augroup = vim.api.nvim_create_augroup
local yank_group = augroup('HighlightYank', {})

local autocmd = vim.api.nvim_create_autocmd
autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

local builtin = require('telescope.builtin')
autocmd('LspAttach', {
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "gd", function() builtin.lsp_definitions() end, opts)
        -- vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-s>", function() vim.lsp.buf.signature_help() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
    end
})
require("luasnip").setup({
    update_events = "TextChangedI"
})
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25