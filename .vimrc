set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'ayu-theme/ayu-vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'scrooloose/nerdtree'
Plugin 'vim-scripts/indentpython.vim'
Plugin 'w0rp/ale'
Plugin 'Valloric/YouCompleteMe'

autocmd vimenter * NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

set number
let mapleader = ","
nnoremap <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <leader>gd :YcmCompleter GoToDefinition<CR>

let g:ctrlp_max_files=10000
let g:ctrlp_max_depth=40
set wildignore+=*/node_modules/*,_site,*/__pycache__/,*/vendor/*,*/tsenv/*,*/venv/*,*/target/*,*/.vim$,\~$,*/.log,*/.aux,*/.cls,*/.aux,*/.bbl,*/.blg,*/.fls,*/.fdb*/,*/.toc,*/.out,*/.glo,*/.log,*/.ist,*/.fdb_latexmk,*sqp,*.pyc,*.zip,*.swp,*.so


let g:ale_linters = {
\   'python': ['flake8'],
\   'markdown': ['markdownlint'],
\   'javascript': ['eslint'],
\}

let g:ale_fixers = {
\   'python': ['autopep8'],
\   'javascript': ['eslint']
\}

let g:ale_fix_on_save = 1

let g:ycm_autoclose_preview_window_after_completion=1

noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

imap ii <Esc>
let NERDTreeIgnore=['\.pyc$', '\~$', '__pycache__', 'node_modules', '.git'] "ignore files in NERDTree

set textwidth=0
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix

au BufNewFile,BufRead *.json
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix

au BufNewFile,BufRead *.md
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix

au BufNewFile,BufRead *.html,*.js
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix

set encoding=utf-8

let python_highlight_all = 1
syntax on

call vundle#end()
filetype plugin indent on

set termguicolors
let ayucolor="mirage"
colorscheme ayu
let g:airline_theme='ayu_mirage'

