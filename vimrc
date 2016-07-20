set runtimepath^=$HOME/dotfiles/vimfiles

" don't set macvim bindings and colorscheme
if has("gui_macvim")
    let macvim_skip_cmd_opt_movement = 1
    let macvim_skip_colorscheme = 1
endif

" set <Leader> before loading plugins
let mapleader=','

" don't load unused plugins
let g:loaded_2html_plugin = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_gzip = 1
let g:loaded_logipat = 1
let g:loaded_netrwPlugin = 1
let g:loaded_rrhelper = 1
let g:loaded_spellfile_plugin = 1
let g:loaded_tarPlugin = 1
let g:loaded_vimballPlugin = 1
let g:loaded_zipPlugin = 1

" man pages and %
runtime ftplugin/man.vim
runtime macros/matchit.vim

" install vim-plug
if !isdirectory(expand('~/.vim/plugged'))
    execute '!curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.vim/plugged')
" colorschemes
Plug 'robertmeta/nofrils'
Plug 'altercation/vim-colors-solarized'
Plug 'chriskempson/vim-tomorrow-theme'
Plug 'crusoexia/vim-monokai'
Plug 'jonathanfilip/vim-lucius'
Plug 'kabbamine/yowish.vim'
Plug 'kristijanhusak/vim-hybrid-material'
Plug 'mhinz/vim-janah'
Plug 'morhetz/gruvbox'
Plug 'nanotech/jellybeans.vim'
Plug 'vivkin/flatland.vim'
" plugins
Plug 'EinfachToll/DidYouMean'
Plug 'ajh17/VimCompletesMe'
Plug 'jeetsukumaran/vim-filebeagle'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'rking/ag.vim'
Plug 'tikhomirov/vim-glsl'
Plug 'tpope/vim-unimpaired'
Plug 'vivkin/cpp-vim'
call plug#end()

filetype plugin indent on

augroup filetypes
    autocmd!
    autocmd FileType c,cpp setl formatprg=clang-format
    autocmd FileType cmake setl nowrap tabstop=2 shiftwidth=2
    autocmd FileType make setl noexpandtab
    autocmd FileType markdown setl wrap linebreak
    autocmd FileType * setl formatoptions-=o
    autocmd BufReadPost */include/c++/* setf cpp
augroup END

augroup mappings
    autocmd!
    autocmd CmdwinEnter * nnoremap <buffer> <silent> q :close<CR>
    autocmd FileType help,qf nnoremap <buffer> <silent> q :close<CR>
augroup END

" disable annoying bells and flashes
set belloff=all

" map russian for normal mode
language C
set encoding=utf-8
set langmap=ЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ;QWERTYUIOP{}ASDFGHJKL:\"ZXCVBNM<>,йцукенгшщзхъфывапролджэячсмитьбю;qwertyuiop[]asdfghjkl\\\;'zxcvbnm\\\,.
set langnoremap

" status line
set laststatus=2
set statusline=\ %f%h%r%m\ %<%=%{&ft!=''?&ft:'no\ ft'}\ \|\ %{&fenc!=''?&fenc:&enc}\ \|\ %{&fileformat}\ %4p%%\ \ %4l:%-4c
set statusline+=%#WarningMsg#%{statusline#whitespace#warning()}%*

set clipboard=unnamed
set display=uhex
set history=10000

set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set cinoptions=:0,l1,g0,N-s,(0

set ttyfast
set lazyredraw
set cursorline
set number
set showcmd
set listchars=tab:↹␠,trail:·,eol:␤
set matchpairs+=<:>

set nowrap
set nostartofline
set scrolloff=1
set sidescrolloff=8

set gdefault
set hlsearch
set incsearch
set ignorecase
set smartcase

set wildmenu
set wildmode=longest,list,full

set autoread
set autowrite
set noswapfile
set nowritebackup

set undofile
set undodir=~/.vim/undo

if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), 'p')
endif

if has("gui_running")
    set columns=160
    set lines=48

    set guiheadroom=0
    set guioptions=c

    if has("gui_win32")
        set guifont=Consolas:h12:cRUSSIAN
    elseif has("gui_gtk")
        set guifont=DejaVu\ Sans\ Mono\ 12,Ubuntu\ Mono\ 12
    elseif has("gui_macvim")
        set guifont=Cousine:h14,Office\ Code\ Pro:h13,Menlo:h13
    endif
endif

syntax on
set t_Co=256
set synmaxcol=1024
set background=light
colorscheme solarized

cnoremap <C-n> <DOWN>
cnoremap <C-p> <UP>
cnoremap <CR> <C-\>esubstitute(getcmdline(), '<C-v><C-m>', '\\n', 'g')<CR><CR>

nnoremap <CR> :nohlsearch<CR><CR>
nnoremap <D-[> <C-w>W
nnoremap <D-]> <C-w>w
nnoremap <silent> <C-n> :bnext<CR>
nnoremap <silent> <C-p> :bprevious<CR>
nnoremap <silent> <D-r> :make all run<CR>:botright cwindow<CR>
nnoremap <silent> <Leader>B :B!<CR>
nnoremap <silent> <Leader>b :B<CR>
nnoremap <silent> <Leader>c :copen<CR>
nnoremap <silent> <Leader>G :Ag! -w <C-R><C-W><CR>
nnoremap <silent> <Leader>g :Ag! -S <C-R><C-W><CR>
nnoremap <silent> <Leader>m :make<CR>:botright cwindow<CR>
nnoremap K i<CR><ESC>
nnoremap Q :q!<CR>
nnoremap X :bdelete<CR>
