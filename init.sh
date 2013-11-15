#!/bin/bash
# -*- coding: utf-8 -*-

rm ~/.bashrc
rm ~/.vimrc
rm ~/.hgrc
rm ~/.Xdefault
ln -s ~/userfiles/bashrc ~/.bashrc
ln -s ~/userfiles/vimrc ~/.vimrc
ln -s ~/userfiles/hgrc ~/.hgrc
ln -s ~/userfiles/Xdefault ~/.Xdefault
ln -s ~/userfiles/vim ~/.vim
source ~/.bashrc
xrdb ~/.Xdefault
