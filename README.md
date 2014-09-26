dotfiles
========

```sh
ln -s ~/dotfiles/bash_profile ~/.bash_profile
ln -s ~/dotfiles/clang-format ~/.clang-format
ln -s ~/dotfiles/editrc ~/.editrc
ln -s ~/dotfiles/inputrc ~/.inputrc
ln -s ~/dotfiles/vimrc ~/.vimrc
mkdir -p ~/.vim/autoload
curl -fLo ~/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```
