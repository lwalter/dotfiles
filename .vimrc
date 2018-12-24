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
Plugin 'fatih/vim-go'
Plugin 'mattn/emmet-vim'

set number
let mapleader = ","
nnoremap <Tab> :bnext<CR>      
nnoremap <S-Tab> :bprevious<CR>
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
imap ii <Esc>
set encoding=utf-8
set textwidth=0

" Airline settings
let g:airline#extensions#tabline#enabled = 1

" NERDTree settings
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
nmap <F6> :NERDTreeToggle<CR>
let NERDTreeIgnore=['\.pyc$', '\~$', '__pycache__', 'node_modules', '.git'] "ignore files in NERDTree

" vim-go settings
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>
autocmd FileType go nmap <leader>b  <Plug>(go-build)
autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <leader>gd <Plug>(go-def)
set autowrite
let g:go_fmt_autosave = 1
let g:go_fmt_command = "goimports"
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1

" YCM settings
autocmd FileType python,javascript nmap <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>
autocmd FileType python,javascript nmap <leader>gd :YcmCompleter GoToDefinition<CR>
let g:ycm_autoclose_preview_window_after_completion=1

" ctrl+p settings
let g:ctrlp_max_files=10000
let g:ctrlp_max_depth=40
set wildignore+=*/node_modules/*,_site,*/__pycache__/,*/vendor/*,*/tsenv/*,*/venv/*,*/target/*,*/.vim$,\~$,*/.log,*/.aux,*/.cls,*/.aux,*/.bbl,*/.blg,*/.fls,*/.fdb*/,*/.toc,*/.out,*/.glo,*/.log,*/.ist,*/.fdb_latexmk,*sqp,*.pyc,*.zip,*.swp,*.so

" ALE settings
let g:ale_linters = {
\   'python': ['pylint'],
\   'markdown': ['markdownlint'],
\   'javascript': ['eslint'],
\}

let g:ale_fixers = {
\   'python': ['autopep8'],
\   'javascript': ['eslint']
\}

let g:ale_fix_on_save = 1

au BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4 

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


let python_highlight_all = 1
syntax on

call vundle#end()
filetype plugin indent on

set termguicolors
let ayucolor="mirage"
colorscheme ayu
let g:airline_theme='ayu_mirage'

