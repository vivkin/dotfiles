#!/bin/sh

for file in bash_profile bashrc clang-format editrc inputrc vimrc; do
  if [ -h ~/.$file ]; then
    rm ~/.$file
  elif [ -f ~/.$file ]; then
    mv ~/.$file ~/.$file.old
  fi
  ln -s ~/dotfiles/$file ~/.$file
done

mkdir -p ~/.vimundo

if [ ! -f ~/.vim/autoload/plug.vim ]; then
  mkdir -p ~/.vim/autoload
  curl -fLo ~/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

vim -c PlugUpdate -c qa
