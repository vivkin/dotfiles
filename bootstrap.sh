#!/bin/sh

mkdir -p ~/dotfiles/backup
for file in bashrc clang-format editrc inputrc vimrc gitconfig; do
  if [ ~/.$file -ot ~/dotfiles/$file ]; then
      cp ~/.$file ~/dotfiles/backup/$file-$(date +%Y%m%d-%H%M%S)
  fi
  ln -si ~/dotfiles/$file ~/.$file
done
