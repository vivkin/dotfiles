dotfiles
========

```sh
ln -s ~/dotfiles/bash_profile ~/.bash_profile
ln -s ~/dotfiles/clang-format ~/.clang-format
ln -s ~/dotfiles/editrc ~/.editrc
ln -s ~/dotfiles/inputrc ~/.inputrc
ln -s ~/dotfiles/vimrc ~/.vimrc
```

vimplugs
========
```
mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

cd ~/.vim/bundle
git clone https://github.com/rking/ag.vim
git clone https://github.com/baskerville/bubblegum
git clone https://github.com/vim-jp/cpp-vim
git clone https://github.com/kien/ctrlp.vim
git clone https://github.com/vivkin/flatland.vim
git clone https://github.com/nanotech/jellybeans.vim.git
git clone https://github.com/tomasr/molokai
git clone https://github.com/scrooloose/nerdtree.git
git clone https://github.com/bling/vim-airline
git clone https://github.com/vivkin/vim-call-cmake.git
git clone https://github.com/kchmck/vim-coffee-script.git
git clone https://github.com/altercation/vim-colors-solarized
git clone https://github.com/endel/vim-github-colorscheme.git
git clone https://github.com/tikhomirov/vim-glsl
git clone https://github.com/w0ng/vim-hybrid
```
