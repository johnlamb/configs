-----------------
-- Preferences --
-----------------
-- No folding
vim.o.foldenable = true
vim.o.foldmethod = 'expr'
vim.o.foldexpr = "v:lua.vim.lsp.foldexpr()"
vim.o.foldlevelstart = 99


-- Set numbers and scrollof
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = 'yes'
vim.o.scrolloff = 10

-- Access to system clipboard
vim.o.clipboard = 'unnamedplus'

-- Break column
vim.o.colorcolumn = '80'

-- Unlimited undo
vim.o.undofile = true

vim.o.updatetime = 50
-- vim.o.timeout = true
-- vim.o.timeoutlen = 300

-- Decent wildmenu
-- in completion, when there is more than one match,
-- list all matches, and only complete to longest common match
vim.o.wildmode = 'list:longest'
vim.o.completeopt = 'menuone,preview'
vim.o.termguicolors = true

-- Split in more logical way
vim.o.splitright = true
vim.o.splitbelow = true

-- infinite undo!
-- NOTE: ends up in ~/.local/state/nvim/undo/
vim.o.undofile = true
-- when opening a file with a command (like :e),
-- don't suggest files like there:
vim.o.wildignore = '.hg,.svn,*~,*.png,*.jpg,*.gif,*.min.js,*.swp,*.o,vendor,dist,_site'

-- tabs
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

-- show more hidden characters
-- also, show tabs nicer
vim.o.listchars = 'tab:^ ,nbsp:¬,extends:»,precedes:«,trail:•'
