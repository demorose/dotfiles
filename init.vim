" Leader key to space
let mapleader=" "

set nowrap

" During search, if no maj, then case insensitive
set ignorecase smartcase

set preserveindent
set shiftwidth=4
set shiftround
set tabstop=4
set softtabstop=4
set expandtab
set smarttab


set pastetoggle=<Leader>P

" No mouse at all
set mouse=

" Do not use arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

"This allows for change paste motion cp{motion}
nmap <silent> cp :set opfunc=ChangePaste<CR>g@
function! ChangePaste(type, ...)
    silent exe "normal! `[v`]\"_c"
    silent exe "normal! p"
endfunction

"Escape terminal mode easily
:tnoremap <Esc> <C-\><C-n>

call plug#begin()
    Plug 'tpope/vim-surround'
    Plug 'benekastah/neomake', has('nvim') ? {} : { 'on': [] }

    Plug 'kien/ctrlp.vim'

    Plug 'bling/vim-airline'

    Plug 'tpope/vim-fugitive'
    Plug 'airblade/vim-gitgutter'

    Plug 'demorose/up.vim'

    Plug 'mattn/emmet-vim'
call plug#end()

" Copy and paste from system clipboard
set clipboard=unnamedplus

colorscheme up

" Number related
set relativenumber
autocmd InsertEnter * :set number
autocmd InsertEnter * :set relativenumber!
autocmd InsertLeave * :set number
autocmd InsertLeave * :set relativenumber!

" Highlight column 80 and 120
set colorcolumn=80,120

" Highlight cursor column and line
set cursorline
set cursorcolumn

" Airline configuration
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" Remove trailing space
nmap <Leader>Cts :%s/\s\+$//e <CR>

nmap <Leader>E :Vexplore <CR>

"search
" Find occurence
map <Leader>Fo :execute "noautocmd vimgrep /\\<" . expand("<cword>") . "\\>/j **/*" . expand("%:e") <Bar> cw<CR>
" Find class
map <Leader>Fc :execute "noautocmd vimgrep /\\<class " . expand("<cword>") . "\\>/j **/*" . expand("%:e") <Bar> cw<CR>
" Find function
map <Leader>Ff :execute "noautocmd vimgrep /\\<function " . expand("<cword>") . "\\>/j **/*" . expand("%:e") <Bar> cw<CR>
" Init vimgrep
map <Leader>Fg :execute "noautocmd vimgrep //j **/*"
" Find function in file
map <Leader>ff /function 

" W to write as root
" command! is used to overwrite W if it exists.
command! W :execute ':silent w !sudo tee % > /dev/null' | :edit!

let g:netrw_liststyle=3

" emmet-vim related
let g:user_emmet_mode='a'

" Neomake php
let g:neomake_php_phpcs_args_standard = 'PSR2'
