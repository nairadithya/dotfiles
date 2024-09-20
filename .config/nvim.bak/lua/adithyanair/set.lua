-- Line Numbers
vim.opt.nu = true
vim.opt.relativenumber = true
-- Colors 
vim.opt.termguicolors = true
-- Incremental search, great for regex stuff
vim.opt.hlsearch = false
vim.opt.incsearch = true
-- Smart indent and search case-insensitive.
vim.opt.smartindent = true
vim.opt.smartcase = true
-- Disable mouse
vim.opt.mouse = ""
-- Conceal Syntax
vim.opt.conceallevel = 2
-- Undo settings
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.nvim/undodir"
vim.opt.undofile = true

