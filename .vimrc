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
Plugin 'Raimondi/delimitMate'
Plugin 'joshdick/onedark.vim'
Plugin 'tomasiser/vim-code-dark'

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

set directory^=$HOME/.vim/tmp//

" Airline settings
let g:airline#extensions#tabline#enabled = 1

" NERDTree settings
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
nmap <F6> :NERDTreeToggle<CR>
let NERDTreeIgnore=['\.pyc$', '\~$', '__pycache__', 'node_modules', '.git'] "ignore files in NERDTree

au FileType *.md let b:delimitMate_quotes = "\" ' "
au FileType *.md let b:delimitMate_nesting_quotes = ['`']
au FileType python let b:delimitMate_nesting_quotes = ['"']

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
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'

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
\   'python': ['flake8', 'mypy'],
\   'markdown': ['markdownlint'],
\   'javascript': ['eslint'],
\}

let g:ale_fixers = {
\   'python': ['black'],
\   'javascript': ['eslint']
\}

"let g:ale_python_pylint_options = '--load-plugins pylint_django'
let g:ale_python_black_options = '--line-length 80'
let g:ale_python_black_auto_pipenv = 1
let g:ale_python_mypy_auto_pipenv = 1
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

au BufNewFile,BufRead *.json,*.yml,*.yaml,*.tf
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix

au BufNewFile,BufRead .gitlab-ci.yml
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix

au BufNewFile,BufRead *.md,*.yaml,*yml
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix

au BufNewFile,BufRead *.html
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix

au BufNewFile,BufRead *.js
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix

call vundle#end()
let python_highlight_all = 1
syntax on

setlocal spell spelllang=en_us

set termguicolors
set t_8f=[38;2;%lu;%lu;%lum
set t_8b=[48;2;%lu;%lu;%lum

"colorscheme codedark
"let g:airline_theme='codedark'


colorscheme onedark
let g:airline_theme='onedark'

"set background=dark
"let ayucolor="mirage"
"colorscheme ayu
"let g:airline_theme='ayu_mirage'
filetype plugin indent on
