"n de défauts bien pratiques (à garder en début de fichier)
set nocompatible

" 256 colors
set t_Co=256

" Coloration syntaxique, indispensable pour ne pas se perdre dans les longs fichiers
syntax on

set background=light

"Détection du type de fichier pour l'indentation
if has("autocmd")
    filetype indent on
endif

" Récupération de la position du curseur entre 2 ouvertures de fichiers
" Parfois ce n'est pas ce qu'on veut ...
autocmd BufReadPost *
            \ if line("'\"") > 0 && line("'\"") <= line("$") |
            \   exe "normal! g`\"" |
            \ endif

" SI c'est pas déjà fait, affiche la position du curseur
set ruler

" Recherche en minuscule -> indépendante de la casse, une majuscule -> stricte
set ignorecase smartcase

" Affiche le nombre de lignes sélectionnées en mode visuel ou la touche/commande qu'on vient de taper en mode commande
set showcmd

" Déplace le curseur au fur et a mesure qu'on tape une recherche, pas toujours pratique, j'ai abandonné
set incsearch

" A utiliser en live, paste désactive l'indentation automatique (entre autre) et nopaste le contraire
set nopaste

" Indiquer le nombre de modification lorsqu'il y en a plus de 0 suite à une commande
set report=0

" Met en évidence TOUS les résultats d'une recherche, A consommer avec modération
set hlsearch

" Laisse les lignes déborder de l'écran si besoin
set nowrap


" Spécial développeurs
"
" Indispensable pour ne pas tout casser avec ce qui va suivre
set preserveindent
" Largeur de l'autoindentation
set shiftwidth=4
" Arrondit la valeur de l'indentation
set shiftround
" Largeur du caractère tab
set tabstop=4
" Largeur de l'indentation de la touche tab
set softtabstop=4
" Remplace les tab par des expaces
set expandtab

" Pour highlighter la ligne courante (pour mieux se repérer) en bleu :
set cursorline
set cursorcolumn

" Pour activer les numéros de lignes dans la marge :
set number

" Utilise shiftwidth à la place de tabstop en début de ligne (et backspace supprime d'un coup si ce sont des espaces)
set smarttab

" On peut passer rapidement du mode paste au mode nopaste avec un raccourcis,
set pastetoggle=<F5>

" Toujours laisser des lignes visibles (içi 3) au dessus/en dessous du curseur quand on
" atteint le début ou la fin de l'écran :
set scrolloff=5

" Afficher en permanence la barre d'état (en plus de la barre de commande) :
set laststatus=2

" Format de la barre d'état (tronquée au début, fichier, flags,  :
set statusline=%<%f%m\ %r\ %h\ %w%=%l,%c\ %p%%

" Permettre l'utilisation de la touche backspace dans tous les cas :
set backspace=2

" Envoyer le curseur sur la ligne suivante/précédente après usage des flèches droite/gauche en bout de ligne :
set whichwrap=<,>,[,]

" Tenter de rester toujours sur la même colonne lors de changements de lignes :
set nostartofline

" Nombre de commandes maximale dans l'historique :
set history=50

" shebang automatique lors de l'ouverture nouveau
" d'un fichier *.py, *.sh (bash), modifier l'entête selon les besoins :
:autocmd BufNewFile *.sh,*.bash 0put =\"#!/bin/bash\<nl># -*- coding: utf-8 -*-\<nl>\<nl>\"|$
:autocmd BufNewFile *.py 0put=\"#!/usr/bin/env python\"|1put=\"# -*- coding: utf-8 -*-\<nl>\<nl>\"|$

" Ouverture de tagbar lors de l'edition d'un .php
:autocmd BufWinEnter *.php :TagbarOpen

" Set an orange cursor in insert mode, and a red cursor otherwise.
if &term =~ "xterm\\|rxvt"
    :silent !echo -ne "\033]12;green\007"
    let &t_SI = "\033]12;orange\007"
    let &t_EI = "\033]12;green\007"
    autocmd VimLeave * :!echo -ne "\033]12;green\007"
endif

highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

"Perso

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" Vundle
Bundle 'gmarik/vundle'

" Interface
Bundle 'bling/vim-airline'
Bundle 'scrooloose/nerdtree'
Bundle 'jistr/vim-nerdtree-tabs'
Bundle 'majutsushi/tagbar'

Bundle 'tpope/vim-surround'
Bundle 'scrooloose/syntastic'

" ColorScheme
Bundle 'demorose/up.vim'
Bundle 'junegunn/seoul256.vim'
Bundle 'nanotech/jellybeans.vim'
Bundle 'morhetz/gruvbox'
Bundle 'altercation/vim-colors-solarized'
Bundle 'modess/vim-phpcolors'
Bundle 'Junza/Spink'

" Git
Bundle 'tpope/vim-fugitive'
Bundle 'airblade/vim-gitgutter'

Bundle 'tobyS/skeletons.vim'
Bundle 'SirVer/ultisnips'
Bundle 'honza/vim-snippets'
Bundle 'DrawIt'

" Javascript
Bundle 'maksimr/vim-jsbeautify'
Bundle 'einars/js-beautify'
Bundle 'Delapouite/vim-javascript-syntax'
Bundle 'pangloss/vim-javascript'

" HTML
Bundle 'othree/html5.vim'
Bundle 'evidens/vim-twig'
Bundle 'tokutake/twig-indent'
Bundle 'groenewege/vim-less'
Bundle 'hail2u/vim-css3-syntax'

" PHP
Bundle 'StanAngeloff/php.vim'
Bundle 'demorose/php-getter-setter.vim'
Bundle 'stephpy/vim-php-cs-fixer'
Bundle 'vim-php/tagbar-phpctags.vim'

set noautoindent
filetype off
filetype indent on
filetype plugin indent on

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
"let g:airline_theme = 'murmur'

colorscheme up

" Open file in new tab by default
set switchbuf+=usetab,newtab

" mapleader
let mapleader=","

" Open NERDTree at startup
let g:nerdtree_tabs_open_on_console_startup=1

" Remove trailing space when saving
" autocmd BufWritePre * :%s/\s\+$//e
nmap <Leader>Cts :%s/\s\+$//e <CR>

"nmap <Leader>Cnc :%s///e <Bar> retab <Bar> %s/\s\+$//e <CR>

" W to write as root
" command! is used to overwrite W if it exists.
command! W :execute ':silent w !sudo tee % > /dev/null' | :edit!

"toggle number
nmap <F2> :set nu!<CR>

"toggle Tree
nmap <F6> :NERDTreeTabsToggle<CR>
nmap <F7> :NERDTreeFind<CR>
nmap <F8> :TagbarToggle<CR>

"search
" Find occurence
map <Leader>Fo :execute "noautocmd vimgrep /\\<" . expand("<cword>") . "\\>/j **/*" . expand("%:e") <Bar> cw<CR>
" Find class
map <Leader>Fc :execute "noautocmd vimgrep /\\<class " . expand("<cword>") . "\\>/j **/*" . expand("%:e") <Bar> cw<CR>
" Find function
map <Leader>Ff :execute "noautocmd vimgrep /\\<function " . expand("<cword>") . "\\>/j **/*" . expand("%:e") <Bar> cw<CR>

" Init vimgrep
map <Leader>Fg :execute "noautocmd vimgrep //j **/*"

map <Leader>ff /function 

noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

"set swap directory
"set directory=~/.vim/swap

"Remove highlight with F3
map <F3> :nohl <CR>

set clipboard=unnamedplus

" Make naughty characters visible...
" (uBB is right double angle, uB7 is middle dot)
exec "set lcs=tab:\uBB\uBB,trail:\uB7,nbsp:~"
augroup VisibleNaughtiness
    autocmd!
    autocmd BufEnter  *       set list
    autocmd BufEnter  *       if !&modifiable
    autocmd BufEnter  *           set nolist
    autocmd BufEnter  *       endif
augroup END

" Toggle naughty characters display
map <Leader>Tnc :set list!<CR>

"This allows for change paste motion cp{motion}
nmap <silent> cp :set opfunc=ChangePaste<CR>g@
function! ChangePaste(type, ...)
    silent exe "normal! `[v`]\"_c"
    silent exe "normal! p"
endfunction

" Highlight column 80 and 120
set colorcolumn=80,120

" Reload configuration
map <Leader>Rc :so $MYVIMRC<CR>

" http://amix.dk/vim/vimrc.html
set lazyredraw
set nobackup
set nowb
set noswapfile

" Ultisnip
let g:UltiSnipsUsePythonVersion = 2
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" Remove diacritical signs from characters in specified range of lines.
" Examples of characters replaced: á -> a, ç -> c, Á -> A, Ç -> C.
" Uses substitute so changes can be confirmed.
function! s:RemoveDiacritics(line1, line2)
    let diacs = 'áâãàçéêíóôõüú'  " lowercase diacritical signs
    let repls = 'aaaaceeiooouu'  " corresponding replacements
    let diacs .= toupper(diacs)
    let repls .= toupper(repls)
    let diaclist = split(diacs, '\zs')
    let repllist = split(repls, '\zs')
    let trans = {}
    for i in range(len(diaclist))
        let trans[diaclist[i]] = repllist[i]
    endfor
    execute a:line1.','.a:line2 . 's/['.diacs.']/\=trans[submatch(0)]/gIce'
endfunction
command! -range=% RemoveDiacritics call s:RemoveDiacritics(<line1>, <line2>)

let g:syntastic_enable_sign=1
let g:syntastic_php_checkers=['php', 'phpcs']
let g:syntastic_php_phpcs_args="--standard=PSR2 -n --report=csv"

function! DoPrettyXML()
  " save the filetype so we can restore it later
  let l:origft = &ft
  set ft=
  " delete the xml header if it exists. This will
  " permit us to surround the document with fake tags
  " without creating invalid xml.
  1s/<?xml .*?>//e
  " insert fake tags around the entire document.
  " This will permit us to pretty-format excerpts of
  " XML that may contain multiple top-level elements.
  0put ='<PrettyXML>'
  $put ='</PrettyXML>'
  silent %!xmllint --format -
  " xmllint will insert an <?xml?> header. it's easy enough to delete
  " if you don't want it.
  " delete the fake tags
  2d
  $d
  " restore the 'normal' indentation, which is one extra level
  " too deep due to the extra tags we wrapped around the document.
  silent %<
  " back to home
  1
  " restore the filetype
  exe "set ft=" . l:origft
endfunction
command! PrettyXML call DoPrettyXML()
