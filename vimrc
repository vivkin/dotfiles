set nocompatible

if has("unix")
    function! SystemIncludeDirs(cc, flags)
        let output = system(a:cc . ' ' . a:flags . ' -v -E - < /dev/null > /dev/null')
        let start = matchend(output, '> search starts here:\n\s\+')
        let end = match(output, '\nEnd of search list.', start)
        let dirs = substitute(strpart(output, start, end - start), '\s*(framework directory)', '', 'g')
        return substitute(dirs, '\n\s*', ',', 'g')
    endfunction()

    if has("mac")
        autocmd VimEnter * let &path = '.,include,/usr/local/include,' . SystemIncludeDirs('clang', '-x c++ -std=c++11 -stdlib=libc++') . ',,'
    else
        autocmd VimEnter * let &path = '.,include,/usr/local/include,' . SystemIncludeDirs('c++', '-x c++ -std=c++11') . ',,'
    endif
endif

if has("win32")
    let &runtimepath.=',$HOME/.vim'
endif

call plug#begin('~/.vim/plugged')
Plug 'tomasr/molokai'
Plug 'w0ng/vim-hybrid'
Plug 'vivkin/flatland.vim'
Plug 'baskerville/bubblegum'
Plug 'whatyouhide/vim-gotham'
Plug 'nanotech/jellybeans.vim'
Plug 'endel/vim-github-colorscheme'
Plug 'altercation/vim-colors-solarized'
Plug 'rking/ag.vim'
Plug 'vivkin/cpp-vim'
Plug 'kien/ctrlp.vim'
Plug 'bling/vim-airline'
Plug 'tikhomirov/vim-glsl'
Plug 'scrooloose/nerdtree'
Plug 'vivkin/vim-call-cmake'
call plug#end()

set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set cinoptions=:0,l1,g0,N-s,(0
filetype plugin indent on

set cursorline
set number
set showcmd
set laststatus=2
set encoding=utf-8
set listchars=tab:↹␠,trail:·,eol:␤

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
set visualbell t_vb=

set autoread
set autowrite
set noswapfile
set nowritebackup

syntax on
set background=dark
if has("gui_running")
    autocmd GUIEnter * set t_vb=
    set guioptions=c
    set guiheadroom=0
    set clipboard=unnamed
    if has("gui_gtk")
        set guifont=Source\ Code\ Pro\ 12,DejaVu\ Sans\ Mono\ 12,Liberation\ Mono\ 12,Ubuntu\ Mono\ 12
    elseif has("gui_macvim")
        set guifont=Source\ Code\ Pro:h13,DejaVu\ Sans\ Mono:h13,Liberation\ Mono:h13,Ubuntu\ Mono:h13,Menlo:h13
    elseif has("gui_win32")
        set guifont=Source\ Code\ Pro:h12,DejaVu\ Sans\ Mono:h12:cRUSSIAN,Liberation\ Mono:h12:cRUSSIAN,Ubuntu\ Mono:h12:cRUSSIAN,Consolas:h12:cRUSSIAN
    endif
    colorscheme bubblegum
else
    colorscheme solarized
endif

let NERDTreeMinimalUI=1
let g:molokai_original=1
let g:airline#extensions#tabline#enabled=1
let mapleader=','

nmap K i<CR><ESC>
nmap cn :cnext<CR>
nmap cp :cprev<CR>
nmap <C-j> :bnext<CR>
nmap <C-k> :bprevious<CR>
nmap <Tab> <C-w>w
nmap <S-Tab> <C-w>W
nmap <silent> <Leader>n :NERDTreeToggle<CR>
nmap <silent> <Leader>N :NERDTree %<CR>
nmap <silent> <Leader>g :Ag! -S <C-R><C-W><CR>
nmap <silent> <Leader>G :Ag! -w <C-R><C-W><CR>
nmap <silent> <Leader>m :make<CR>:botright cwindow<CR>
nmap <silent> <Leader>c :copen<CR>
nnoremap <CR> :nohlsearch<CR><CR>

autocmd BufReadPost quickfix nnoremap <buffer> <silent> q :cclose<CR>
autocmd BufNewFile,BufReadPost *.h,*.hpp,*.c,*.cc,*.cxx,*.cpp setl formatprg=clang-format
autocmd BufNewFile,BufReadPost *.coffee setl tabstop=2 shiftwidth=2
autocmd BufNewFile,BufReadPost *.md,*.txt setl wrap
autocmd BufNewFile,BufReadPost ?akefile* setl noexpandtab

set exrc
set secure
