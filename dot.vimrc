" Assume we're running with a black on white screen.
set background=light

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

" Don't add two spaces when joining lines with punctuation.
set nojoinspaces

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

" Makes long lines not break mid-word
" set linebreak

" Underline a line at or past 80 characters.
" :hi LineTooLong cterm=underline
" :au BufWinEnter * let w:m2=matchadd('LineTooLong', '\%>80v.\+', -1)

" Status line setup.
set ruler
set laststatus=2
set statusline=%<%f\ %{&ff}%R%M%=%l:%c\ %p%%


" Show commands and selection area size
set showcmd

" Tell vim we have a 16-color terminal.
set t_Co=16

" Updates the title of compatible term programs.
set title
set titlestring=%f

" Turns off any audible or visible bell.
set visualbell t_vb=
autocmd GUIEnter * set vb t_vb=
set noeb
set novb

" Turn on mouse mode.
set mouse=

" Font for GUI versions.
set guifont=Consolas:h14

" e = gui tabs, g = menu items greyable, m = menu bar, r = right scrollbar
set guioptions=egm

" Modified, file name, full file path
set guitablabel=%M\ %t\ %F

" Nicer file name tab-completion.
set wildmenu

" Let bash aliases, etc. work.
let $BASH_ENV = "~/.gholtbashrc"


" Maps \b to list the current buffers. Then you can type a buffer number, or a
" partial buffer name and hit tab, then enter to switch to it.
map <Leader>b :ls<CR>:b<Space>

" Maps \cd to change the current directory to the same directory as the file
" in the current buffer.
map <Leader>cd :cd %:p:h<CR>

" Python: Maps \l to run (lint) flake8 on the current file.
" function! GHolt_lint()
"     set lazyredraw
"     cclose
"     let l:grepformat_orig=&grepformat
"     let l:grepprg_orig=&grepprg
"     let &grepformat="%f:%l:%c: %m\,%f:%l: %m"
"     let &grepprg="flake8"
"     silent grep %
"     let &grepformat=l:grepformat_orig
"     let &grepprg=l:grepprg_orig
"     cwindow
"     set nolazyredraw
"     redraw!
"     if getqflist() == []
"         echo "flake8 clean"
"     endif
" endfunction
" map <Leader>l :call GHolt_lint()<CR>

" Python: Maps \L to run (lint) flake8 from the current working directory.
" function! GHolt_lintcwd()
"     set lazyredraw
"     cclose
"     let l:grepformat_orig=&grepformat
"     let l:grepprg_orig=&grepprg
"     let &grepformat="%f:%l:%c: %m\,%f:%l: %m"
"     let &grepprg="flake8"
"     silent grep .
"     let &grepformat=l:grepformat_orig
"     let &grepprg=l:grepprg_orig
"     cwindow
"     set nolazyredraw
"     redraw!
"     if getqflist() == []
"         echo "flake8 clean"
"     endif
" endfunction
" map <Leader>L :call GHolt_lintcwd()<CR>

" Golang: Maps \g to run: go install
function! GHolt_gobuild()
    set lazyredraw
    cclose
    let l:grepformat_orig=&grepformat
    let l:grepprg_orig=&grepprg
    let &grepformat="%-G#\ %.%#,%A%f:%l:%c:\ %m,%A%f:%l:\ %m,%C%*\\s%m,%-G%.%#"
    let &grepprg="go install ./..."
    silent grep
    let &grepformat=l:grepformat_orig
    let &grepprg=l:grepprg_orig
    cwindow
    set nolazyredraw
    redraw!
    if getqflist() == []
        echo "go install returned clean"
    endif
endfunction
map <Leader>g :call GHolt_gobuild()<CR>

" Golang: Maps \G to run: gogo (which is go fmt, vet, test, install)
function! GHolt_gobuildfull()
    set lazyredraw
    cclose
    let l:grepformat_orig=&grepformat
    let l:grepprg_orig=&grepprg
    let &grepformat="%-G#\ %.%#,%A%f:%l:%c:\ %m,%A%f:%l:\ %m,%C%*\\s%m,%-G%.%#"
    let &grepprg="gogo"
    silent grep
    let &grepformat=l:grepformat_orig
    let &grepprg=l:grepprg_orig
    cwindow
    set nolazyredraw
    redraw!
    if getqflist() == []
        echo "go build, vet, test, install returned clean"
    endif
endfunction
map <Leader>G :call GHolt_gobuildfull()<CR>

" Golang:: Maps \l to run golint.
function! GHolt_golint()
    set lazyredraw
    cclose
    let l:grepformat_orig=&grepformat
    let l:grepprg_orig=&grepprg
    let &grepformat="%f:%l:%c: %m"
    let &grepprg="golint ./..."
    silent grep
    let &grepformat=l:grepformat_orig
    let &grepprg=l:grepprg_orig
    cwindow
    set nolazyredraw
    redraw!
    if getqflist() == []
        echo "golint clean"
    endif
endfunction
map <Leader>l :call GHolt_golint()<CR>

" Maps \p to toggling paste and nopaste modes. This lets you turn off
" auto-indenting, etc. while pasting in a big block of text.
nnoremap <Leader>p :set invpaste paste?<CR>

" Maps \s to toggle spellcheck mode.
nnoremap <Leader>s :set invspell spell?<CR>

" Maps \w to toggle textwidth between 72 and 0.
function! GHolt_tw()
    if &tw == 0
        set tw=72
        echo "tw=72"
    else
        set tw=0
        echo "tw=0"
    endif
endfunction
nnoremap <Leader>w :call GHolt_tw()<CR>

" Gets folding set up but turned off by default.
" zi = toggle on/off
" za = toggle fold under cursor, one level
" zA = toggle fold under cursor, all levels
" zC = close fold under cursor -- visual select area to close folds within
" Probably easier ways to do things, but the above is what I've become used to.
set foldmethod=syntax
set nofoldenable

" " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " " "
" General Tips
"
" Replace double blank lines with single blank lines
"   :%s/\n\{3,}/\r\r/e
" To list spelling alternatives
"   z=
" Look for long lines
"   :match Error /\%>80v/
