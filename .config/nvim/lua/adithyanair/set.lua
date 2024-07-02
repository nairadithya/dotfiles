-- Line Numbers
vim.opt.nu = true
vim.opt.relativenumber = true
-- Colors 
vim.opt.termguicolors = true
-- Incremental search, great for regex stuff
vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.smartindent = true
-- Disable mouse
vim.opt.mouse = ""
-- Remove mode
vim.opt.showmode = false
-- Remove highlight after search
vim.opt.hlsearch = true
-- Conceal Syntax
vim.opt.conceallevel = 2
-- Highlight upon yanking text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
-- Undo settings
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.nvim/undodir"
vim.opt.undofile = true
