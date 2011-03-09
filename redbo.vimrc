syntax on
set title
set ruler
set hlsearch
set incsearch
set expandtab
set smartindent
set shiftwidth=2
set tabstop=4
set softtabstop=2

" 4-space tab widths for python (and pyrex)
autocmd FileType py* setlocal shiftwidth=4 tabstop=8 softtabstop=4

" highlight lines over 80 cols, spaces at the end of lines and tab characters
highlight BadStyle ctermbg=darkblue ctermfg=green
match BadStyle "\(\%>80v.\+\|\t\| \+$\)"

" # key toggle comments in python
function! TogglePythonComments()
 if match(getline("."), '^ *#') >= 0
   execute ':s+#++' |
 else
   execute ':s+^+#+' |
 endif
endfunction
autocmd FileType python map # :call TogglePythonComments()<cr>
