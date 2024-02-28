-- Leader before Lazy
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = " "

-----------------
-- Preferences --
-----------------
-- No folding
vim.o.foldenable = false
vim.o.foldmethod = 'manual'
vim.o.foldlevelstart = 99

-- Set numbers and scrollof
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.signcolumn = 'yes'
vim.wo.scrolloff = 10

-- Access to system clipboard
vim.o.clipboard = 'unnamedplus'

-- Break column
vim.o.colorcolumn = '80'
-- Rust exception
vim.api.nvim_create_autocmd('Filetype', { 
    pattern = 'rust', command = 'set colorcolumn=100' })
vim.o.breakindent = true

-- Unlimited undo
vim.o.undofile = true

-- vim.o.updatetime = 250
-- vim.o.timeout = true
-- vim.o.timeoutlen = 300

-- Decent wildmenu
-- in completion, when there is more than one match,
-- list all matches, and only complete to longest common match
vim.o.wildmode = 'list:longest'
vim.o.completeopt = 'menuone,noselect'
vim.o.termguicolors = true

-- Split in more logical way
vim.o.splitright = true
vim.o.splitbelow = true

-- infinite undo!
-- NOTE: ends up in ~/.local/state/nvim/undo/
vim.o.undofile = true
-- when opening a file with a command (like :e),
-- don't suggest files like there:
vim.o.wildignore = 
    '.hg,.svn,*~,*.png,*.jpg,*.gif,*.min.js,*.swp,*.o,vendor,dist,_site'

-- tabs: go big or go home
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.tabstop = 4
vim.o.expandtab = true

-- case-insensitive search/replace
vim.o.ignorecase = true
-- unless uppercase in search term
vim.o.smartcase = true
-- never ever make my terminal beep
vim.o.vb = true
-- more useful diffs (nvim -d)
--- by ignoring whitespace
-- vim.o.diffopt:append('iwhite')

-- show more hidden characters
-- also, show tabs nicer
vim.o.listchars = 'tab:^ ,nbsp:¬,extends:»,precedes:«,trail:•'

-------------
-- Plugins --
-------------
-- Bootstrap lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
    -- Colorscheme
    'ellisonleao/gruvbox.nvim',
    -- Lualine
    { 
      'nvim-lualine/lualine.nvim',
      opts = {
        icons_enabled = true,
        theme = 'auto',
        component_separator = '|',
        section_separator = '',
      },
    },
    -- LSP
    {
        'neovim/nvim-lspconfig',
 		config = function()
 			-- Setup language servers.
 			local lspconfig = require('lspconfig')
 
 			-- Rust
 			lspconfig.rust_analyzer.setup {
 				-- Server-specific settings. See `:help lspconfig-setup`
 				settings = {
 					["rust-analyzer"] = {
 						cargo = {
 							allFeatures = true,
 						},
 						imports = {
 							group = {
 								enable = true,
 							},
 						},
 						completion = {
 							postfix = {
 								enable = true,
 							},
 						},
                        diagnostics = {
                            enable = true;
                        },
                        inlayHints = {
                            enable = true,
                            showParameterNames = true,
                            parameterHintsPrefix = "<- ",
                            otherHintsPrefix = "=> ",
                        },
 					},
 				},
 			}
 
 			-- Global mappings.
 			-- See `:help vim.diagnostic.*` for documentation on any of the below functions
 			vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
 			vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
 			vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
 			vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
 
 			-- Use LspAttach autocommand to only map the following keys
 			-- after the language server attaches to the current buffer
 			vim.api.nvim_create_autocmd('LspAttach', {
 				group = vim.api.nvim_create_augroup('UserLspConfig', {}),
 				callback = function(ev)
 					-- Enable completion triggered by <c-x><c-o>
 					vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
 
 					-- Buffer local mappings.
 					-- See `:help vim.lsp.*` for documentation on any of the below functions
 					local opts = { buffer = ev.buf }
 					vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
 					vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
 					vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
 					vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
 					vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
 					vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
 					vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
 					vim.keymap.set('n', '<leader>wl', function()
 						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
 					end, opts)
 					--vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
 					vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
 					vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
 					vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
 					vim.keymap.set('n', '<leader>f', function()
 						vim.lsp.buf.format { async = true }
 					end, opts)
 
 					-- local client = vim.lsp.get_client_by_id(ev.data.client_id)
 
 					-- When https://neovim.io/doc/user/lsp.html#lsp-inlay_hint stabilizes
 					-- *and* there's some way to make it only apply to the current line.
 					-- if client.server_capabilities.inlayHintProvider then
 					--     vim.lsp.inlay_hint(ev.buf, true)
 					-- end
 
 					-- None of this semantics tokens business.
 					-- https://www.reddit.com/r/neovim/comments/143efmd/is_it_possible_to_disable_treesitter_completely/
 					-- client.server_capabilities.semanticTokensProvider = nil
 				end,
 			})
 		end
 	},
    -- LSP-based code-completion
	{
		"hrsh7th/nvim-cmp",
		-- load cmp on InsertEnter
		event = "InsertEnter",
		-- these dependencies will only be loaded when cmp loads
		-- dependencies are always lazy-loaded unless specified otherwise
		dependencies = {
			'neovim/nvim-lspconfig',
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
		},
		config = function()
			local cmp = require'cmp'
			cmp.setup({
				snippet = {
					-- REQUIRED by nvim-cmp. get rid of it once we can
					expand = function(args)
						vim.fn["vsnip#anonymous"](args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					['<C-b>'] = cmp.mapping.scroll_docs(-4),
					['<C-f>'] = cmp.mapping.scroll_docs(4),
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-e>'] = cmp.mapping.abort(),
					-- Accept currently selected item.
					-- Set `select` to `false` to only confirm explicitly selected items.
					['<CR>'] = cmp.mapping.confirm({ select = true }),
				}),
				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
				}, {
					{ name = 'path' },
				}),
				experimental = {
					ghost_text = true,
				},
			})

			-- Enable completing paths in :
			cmp.setup.cmdline(':', {
				sources = cmp.config.sources({
					{ name = 'path' }
				})
			})
		end
	},
})

-- Gruvbox colorscheme
vim.o.background = "dark"
vim.cmd 'colorscheme gruvbox'

