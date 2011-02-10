" Run in vim-mode instead of strict vi-mode.
set nocompatible

" Keep files opened in hidden buffers even if they aren't visible.
set hidden


" Expand tabs into spaces.
set expandtab

" Shift 4 spaces when using shift commands.
set shiftwidth=4

" Actual tab characters are shown as 4 spaces.
set tabstop=4

" Keep indentation from line to line.
set autoindent

" Increase indentation after open-braces and match close-brace indentation to
" their open-brace indentations.
set smartindent

" Don't increase indent after any special words (for, while, do, etc.).
set cinwords=

" Disable smartindent's unindentation of lines starting with #
inoremap # X#

" Tries to match tabbing with the shiftwidth.
set smarttab


" Allows backspace to work in all situations
set backspace=indent,eol,start

" Don't treat the first non-blank character as the start of the line, treat
" column 0 as the start of the line.
set nostartofline


" Ignore case for searches.
set ignorecase

" Makes mixed-case searches be case-sensitive, but leaves lower-case searches
" case-insensitive.
set smartcase

" Automatically jump to where the search matches as it is being typed.
set incsearch

" Highlight searches by default.
set hlsearch


" Turns on syntax highlighting.
syn enable

" Briefly jumps to matching brackets when the closing bracket is typed.
set showmatch

" Try to keep 2 extra lines of context at the top and bottom of the screen.
set scrolloff=2

" Show the line number, column number, and percentage within file on stat line.
set ruler

" Status line setup.
set statusline=%<%f\ [%{&ff}]\ %m%=[%b\ %B]\ \ %l,%c%V\ %P

" Show commands and selection area size
set showcmd


" Don't add two spaces when joining lines with punctuation.
set nojoinspaces


" Tell vim we have a 16-color terminal.
set t_Co=16

" Updates the title of compatible term programs.
set title

" Turns off any audible or visible bell.
set visualbell t_vb=

" Turn on mouse mode.
set mouse=a
set ttymouse=xterm2

" e = gui tabs, g = menu items greyable, m = menu bar, r = right scrollbar
set guioptions=egmr

" Modified, file name, full file path
set guitablabel=%M\ %t\ %F

" Maps \cd to change the current directory to the same directory as the file
" in the current buffer.
map <Leader>cd :cd %:p:h<CR>

" Maps \b to list the current buffers.
map <Leader>b :ls<CR>:b<Space>

" Maps \p to toggling paste and nopaste modes.
nnoremap <Leader>p :set invpaste paste?<CR>
imap <Leader>p <C-O><Leader>p
set pastetoggle=<Leader>p
