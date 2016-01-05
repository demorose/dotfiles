#!/bin/bash
# -*- coding: utf-8 -*-

pushd `dirname $0` > /dev/null
SCRIPTPATH=`pwd -P`
popd > /dev/null

echo "install bashrc? [y/N]" && read approv
if [ $approv = 'Y' ] || [ $approv = 'y' ]; then
    mv ~/.bashrc ~/.bashrc.back
    ln -s $SCRIPTPATH/bashrc ~/.bashrc
    touch ~/.local_bashrc
    touch ~/.reminder
    source ~/.bashrc
else
    echo "skiping bashrc...."
fi

echo "install vimrc and vundle? [y/N]" && read approv
if [ $approv = 'Y' ] || [ $approv = 'y' ]; then
    mv ~/.vimrc ~/.vimrc.back
    mkdir -p ~/.vim/swap
    ln -s $SCRIPTPATH/vimrc ~/.vimrc
    mv ~/.vim/skeletons ~/.vim/skeletons.back
    ln -s $SCRIPTPATH/vim/skeletons ~/.vim/skeletons
    if hash git 2>/dev/null; then
        git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
    fi
else
    echo "skiping vimrc...."
fi

echo "install Xdefault? [y/N]" && read approv
if [ $approv = 'Y' ] || [ $approv = 'y' ]; then
    mv ~/.Xdefault ~/.Xdefault.back
    ln -s $SCRIPTPATH/Xdefault ~/.Xdefault
    if hash xrdb 2>/dev/null; then
        xrdb ~/.Xdefault
    fi
else
    echo "skiping Xdefault...."
fi

echo "install inputrc? [y/N]" && read approv
if [ $approv = 'Y' ] || [ $approv = 'y' ]; then
    mv ~/.inputrc ~/.inputrc.back
    ln -s $SCRIPTPATH/inputrc ~/.inputrc
else
    echo "skiping inputrc...."
fi

echo "install screenrc? [y/N]" && read approv
if [ $approv = 'Y' ] || [ $approv = 'y' ]; then
    mv ~/.screenrc ~/.screenrc.back
    ln -s $SCRIPTPATH/screenrc ~/.screenrc
else
    echo "skiping screenrc"
fi
