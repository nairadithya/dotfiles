vim.opt.filetype = "on"
vim.opt.syntax = "enable"
vim.g.vimtex_view_method = 'zathura'
vim.g.maplocalleader = ","
vim.cmd[[let g:vimtex_compiler_latexmk = {
        \ 'aux_dir' : '.aux/',
        \ 'out_dir' : '',
        \ 'callback' : 1,
        \ 'continuous' : 1,
        \ 'executable' : 'latexmk',
        \ 'hooks' : [],
        \ 'options' : [
        \   '-pdf',
        \   '-shell-escape',
        \   '-verbose',
        \   '-file-line-error',
        \   '-synctex=1',
        \   '-interaction=nonstopmode',
        \ ],
        \}]]

