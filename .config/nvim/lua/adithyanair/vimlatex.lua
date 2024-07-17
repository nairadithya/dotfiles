vim.api.nvim_create_autocmd({"BufReadPre"}, {
	pattern = {"*.tex"},
	desc = "Calls inskcape-figures watcher every time a .tex file is opened.",
	callback = function()
	end,
})

vim.keymap.set('i','<C-f>','<Esc>0v$:!inkscape-figures create `cat` ./figures/;<CR>:w<CR>""')
