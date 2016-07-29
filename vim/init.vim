" set <Leader> before loading any plugin
let mapleader = ','

" don't load unused plugins {{{
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
" }}}

" skip macvim bindings and colorscheme {{{
if has("gui_macvim")
    let macvim_skip_cmd_opt_movement = 1
    let macvim_skip_colorscheme = 1
endif
" }}}

" defaults from nvim {{{
if !has('nvim')
    set backupdir=$XDG_DATA_HOME/nvim/backup
    set directory=$XDG_DATA_HOME/nvim/swap//
    set runtimepath=$XDG_CONFIG_HOME/nvim,$XDG_DATA_HOME/nvim/site,$VIMRUNTIME,$XDG_DATA_HOME/nvim/site/after,$XDG_CONFIG_HOME/nvim/after
    set undodir=$XDG_DATA_HOME/nvim/undo
    set viewdir=$XDG_DATA_HOME/nvim/view

    filetype plugin indent on
    syntax enable

    set autoindent
    set autoread
    set backspace=indent,eol,start
    set complete-=i
    set display=lastline
    set encoding=utf-8
    set formatoptions=tcqj
    set history=10000
    set hlsearch
    set incsearch
    set langnoremap
    set laststatus=2
    set listchars=tab:>\ ,trail:-,nbsp:+
    set mouse=a
    set nocompatible
    set nrformats=bin,hex
    set sessionoptions-=options
    set smarttab
    set tabpagemax=50
    set tags=./tags;,tags
    set ttyfast
    set viminfo^=!
    set viminfo+=n$XDG_CACHE_HOME/vim/info
    set wildmenu

    runtime! macros/matchit.vim
    runtime! ftplugin/man.vim
endif
" }}}

" setup vim-plug {{{
let s:plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
let g:plug_home = expand('$XDG_DATA_HOME/nvim/site')

function! s:download(filename, url)
    if (executable('curl'))
        silent execute '!curl --fail --silent --location --create-dirs --output ' . a:filename . ' --url ' . a:url
        return v:shell_error == 0
    elseif (executable('wget'))
        silent execute 'mkdir -p ' . fnamemodify(a:filename, ':h') . ' && wget --quiet --output-document ' . a:filename . ' ' . a:url
        return v:shell_error == 0
    else
        echoerr 'curl or wget not found'
        return 0
    endif
endfunction

if empty(globpath(&rtp, 'autoload/plug.vim')) && s:download(g:plug_home . '/autoload/plug.vim', s:plug_url)
    autocmd VimEnter * PlugInstall
endif
" }}}

call plug#begin()
" colorschemes
Plug 'altercation/vim-colors-solarized'
Plug 'chriskempson/base16-vim'
Plug 'crusoexia/vim-monokai'
Plug 'kabbamine/yowish.vim'
Plug 'morhetz/gruvbox'
" plugins
Plug 'justinmk/vim-dirvish'
Plug 'tpope/vim-unimpaired'
Plug 'vivkin/cpp-vim'
call plug#end()

augroup filetypes
    autocmd!
    autocmd FileType c,cpp setl formatprg=clang-format
    autocmd FileType cmake setl nowrap tabstop=2 shiftwidth=2
    autocmd FileType dirvish :sort r /[^\/]$/
    autocmd FileType dirvish :keeppatterns g@\v/\.[^\/]+/?$@d
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

augroup didyoumean
    autocmd!
    autocmd BufNewFile * call didyoumean#ask()
augroup END

command! A call alternatefile#open()
command! -bang B ls<bang> | let nr = input('Which one: ') | if nr != '' | execute nr != 0 ? 'buffer ' . nr : 'enew' | endif
command! Colors call colorlist#open()
command! -nargs=+ IncludePath call includepath#add('<args>')
command! -nargs=* G silent execute 'grep! ' . escape(empty(<q-args>) ? expand("<cword>") : <q-args>, '|') | botright cwindow
command! -nargs=1 -complete=help H enew | setl buftype=help | execute 'help <args>' | setl buflisted

" better grep
if executable('ag')
    let &grepprg='ag --vimgrep $*'
    let &grepformat='%f:%l:%c:%m'
else
    let &grepprg='grep -r -n $* . /dev/null'
    let &grepformat='%f:%l:%m'
endif

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

" tab line
set showtabline=2
set tabline=%!bufline#tabline()

set clipboard=unnamed
set display=uhex
set history=10000

set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set cinoptions=:0,l1,g0,N-s,(0

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
set wildmode=list:longest,full

set autoread
set autowrite
set noswapfile
set nowritebackup

set undofile
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
set synmaxcol=1024
set background=dark
colorscheme gruvbox

cnoremap <C-n> <DOWN>
cnoremap <C-p> <UP>
cnoremap <CR> <C-\>esubstitute(getcmdline(), '<C-v><C-m>', '\\n', 'g')<CR><CR>

nnoremap <CR> :nohlsearch<CR><CR>
nnoremap <D-[> <C-w>W
nnoremap <D-]> <C-w>w
nnoremap <silent> <C-n> :bnext<CR>
nnoremap <silent> <C-p> :bprevious<CR>
nnoremap <silent> <Leader>B :B!<CR>
nnoremap <silent> <Leader>b :B<CR>
nnoremap <silent> <Leader>c :copen<CR>
nnoremap <silent> <Leader>m :make<CR>:botright cwindow<CR>
nnoremap K i<CR><ESC>
nnoremap Q ZQ

" vim:set fdm=marker fdl=0:
