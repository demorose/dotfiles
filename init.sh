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
if hash git 2>/dev/null; then
    git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
fi
