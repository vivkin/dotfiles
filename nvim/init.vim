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
    if !exists("g:runtimepath_changed")
        set runtimepath=$XDG_CONFIG_HOME/nvim,$XDG_DATA_HOME/nvim/site,$VIMRUNTIME,$XDG_DATA_HOME/nvim/site/after,$XDG_CONFIG_HOME/nvim/after
        let g:runtimepath_changed = 1
    endif
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
    set history=10000
    set wildmenu

    runtime! macros/matchit.vim
    runtime! ftplugin/man.vim
endif
" }}}

" setup vim-plug {{{
let s:plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
let g:plug_home = expand('$XDG_DATA_HOME/nvim/site/plugged')

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

if empty(globpath(&rtp, 'autoload/plug.vim')) && s:download('$XDG_DATA_HOME/nvim/site/autoload/plug.vim', s:plug_url)
    autocmd VimEnter * PlugInstall
endif
" }}}

call plug#begin()
" colorschemes
Plug 'freeo/vim-kalisi'
Plug 'morhetz/gruvbox'
Plug 'rakr/vim-two-firewatch'
" plugins
Plug 'justinmk/vim-dirvish'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-jp/vim-cpp'
call plug#end()

augroup filetypes
    autocmd!
    autocmd FileType c,cpp,objc,objcpp setl formatprg=clang-format
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

augroup didyoumean
    autocmd!
    autocmd BufNewFile * call didyoumean#ask()
augroup END

augroup startup
    autocmd!
    autocmd BufReadPost * if line("'\"") >= 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
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

" status line
set laststatus=2
set statusline=\ %f%h%r%m\ %<%=%{&ft!=''?&ft:'no\ ft'}\ \|\ %{&fenc!=''?&fenc:&enc}\ \|\ %{&fileformat}\ %4p%%\ \ %4l:%-4c
set statusline+=%#WarningMsg#%{statusline#whitespace#warning()}%*
"set statusline+=%#Debug#%{join(map(synstack(line('.'),col('.')),'synIDattr(v:val,\"name\")'))}%*

" tab line
set showtabline=2
set tabline=%!bufline#tabline()

set clipboard=unnamed

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
set hidden
set noswapfile
set nowritebackup

set undofile
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), 'p')
endif

set synmaxcol=1024

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
        set guifont=Cousine:h13,Menlo:h13
    endif
endif

set background=dark
colorscheme kalisi

cnoremap <C-n> <DOWN>
cnoremap <C-p> <UP>
cnoremap <CR> <C-\>esubstitute(getcmdline(), '<C-v><C-m>', '\\n', 'g')<CR><CR>

inoremap <C-u> <C-g>u<C-u>

nnoremap <CR> :nohlsearch<CR><CR>
nnoremap <silent> <C-n> :bnext<CR>
nnoremap <silent> <C-p> :bprevious<CR>
nnoremap <silent> <Leader>B :B!<CR>
nnoremap <silent> <Leader>b :B<CR>
nnoremap <silent> <Leader>c :copen<CR>
nnoremap <silent> <Leader>m :make<CR>:botright cwindow<CR>
nnoremap <silent> <Leader>x :bdelete<CR>
nnoremap K i<CR><ESC>
nnoremap Q ZQ

" vim:set fdm=marker fdl=0:
