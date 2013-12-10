#!/bin/bash
# -*- coding: utf-8 -*-

pushd `dirname $0` > /dev/null
SCRIPTPATH=`pwd -P`
popd > /dev/null

touch ~/.reminder
mkdir -p ~/.vim/swap
mv ~/.bashrc ~/.bashrc.back
mv ~/.vimrc ~/.vimrc.back
mv ~/.Xdefault ~/.Xdefault.back
ln -s $SCRIPTPATH/bashrc ~/.bashrc
ln -s $SCRIPTPATH/vimrc ~/.vimrc
ln -s $SCRIPTPATH/Xdefault ~/.Xdefault
source ~/.bashrc
if hash xrdb 2>/dev/null; then
    xrdb ~/.Xdefault
fi
if hash curl 2>/dev/null; then

    # Install pathogen

    mkdir -p ~/.vim/autoload ~/.vim/bundle; \
    curl -Sso ~/.vim/autoload/pathogen.vim \
        https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim

    cd ~/.vim/bundle

    # Install nerdtree
    if [ ! -d ./nerdtree ]; then
        git clone https://github.com/scrooloose/nerdtree.git
    fi
    # Install nerdtree-tabs
    if [ ! -d ./vim-nerdtree-tabs ]; then
        git clone https://github.com/jistr/vim-nerdtree-tabs.git
    fi
    # Install vim-javascript
    if [ ! -d ./vim-javascript ]; then
        git clone https://github.com/pangloss/vim-javascript.git
    fi
    # Install vim-javascript-syntax
    if [ ! -d ./vim-javascript-syntax ]; then
        git clone https://github.com/jelera/vim-javascript-syntax.git
    fi
    # Install syntastic
    if [ ! -d ./syntastic ]; then
        git clone https://github.com/scrooloose/syntastic.git
    fi
    # Snipmate
    if [ ! -d ./tlib_vim ]; then
        git clone https://github.com/tomtom/tlib_vim.git
    fi
    if [ ! -d ./vim-addon-mw-utils ]; then
        git clone https://github.com/MarcWeber/vim-addon-mw-utils.git
    fi
    if [ ! -d ./vim-snipmate ]; then
        git clone https://github.com/garbas/vim-snipmate.git
    fi
    if [ ! -d ./vim-snippets ]; then
        git clone https://github.com/honza/vim-snippets.git
    fi
    if [ ! -d ./vim-gitgutter ]; then
        git clone git://github.com/airblade/vim-gitgutter.git
    fi
fi
