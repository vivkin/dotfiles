set nocompatible

call plug#begin('~/.vim/plugged')
Plug 'ajh17/Spacegray.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'baskerville/bubblegum'
Plug 'bling/vim-airline'
Plug 'bruno-/vim-man'
Plug 'gosukiwi/vim-atom-dark'
Plug 'jeetsukumaran/vim-nefertiti'
Plug 'kien/ctrlp.vim'
Plug 'nanotech/jellybeans.vim'
Plug 'rking/ag.vim'
Plug 'scrooloose/nerdtree'
Plug 'tikhomirov/vim-glsl'
Plug 'tomasr/molokai'
Plug 'tommcdo/vim-exchange'
Plug 'tpope/vim-surround'
Plug 'vivkin/cpp-vim'
Plug 'vivkin/flatland.vim'
Plug 'w0ng/vim-hybrid'
call plug#end()

filetype plugin indent on
syntax on

set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set cinoptions=:0,l1,g0,N-s,(0

set cursorline
set number
set showcmd
set laststatus=2
set encoding=utf-8
set listchars=tab:↹␠,trail:·,eol:␤
set matchpairs=(:),{:},[:],<:>

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
set undofile
set undodir=~/.vimundo

let g:airline#extensions#tabline#enabled=1
let NERDTreeMinimalUI=1
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
nmap <silent> <D-r> :make all run<CR>:botright cwindow<CR>
nmap <silent> <Leader>c :copen<CR>
nnoremap <CR> :nohlsearch<CR><CR>

autocmd BufReadPost quickfix nnoremap <buffer> <silent> q :cclose<CR>
autocmd BufNewFile,BufReadPost *.h,*.hpp,*.c,*.cc,*.cxx,*.cpp setl formatprg=clang-format
autocmd BufNewFile,BufReadPost *.coffee setl tabstop=2 shiftwidth=2
autocmd BufNewFile,BufReadPost *.md,*.txt setl wrap
autocmd BufNewFile,BufReadPost ?akefile* setl noexpandtab

if has("gui_running")
    autocmd GUIEnter * set t_vb=

    if has("gui_win32")
        set guifont=Consolas:h12:cRUSSIAN
    elseif has("gui_gtk")
        set guifont=DejaVu\ Sans\ Mono\ 12,Ubuntu\ Mono\ 12
    elseif has("gui_macvim")
        set macmeta
        set guifont=Office\ Code\ Pro:h12,Menlo:h12
    endif
    set guioptions=c
    set guiheadroom=0

    set lines=512
    set columns=160
    set clipboard=unnamed
    set background=dark
    colorscheme nefertiti
    let g:airline_theme='monochrome'
else
    set background=dark
    colorscheme jellybeans
endif

if has("unix")
    function! SystemIncludeDirs(cc, flags)
        let output = system(a:cc . ' ' . a:flags . ' -v -E - < /dev/null > /dev/null')
        let start = matchend(output, '> search starts here:\n\s\+')
        let end = match(output, '\nEnd of search list.', start)
        let dirs = substitute(strpart(output, start, end - start), '\s*(framework directory)', '', 'g')
        return substitute(dirs, '\n\s*', ',', 'g')
    endfunction()

    function! CMake(build_dir, ...)
        if filereadable("CMakeLists.txt")
            let build_dir = fnameescape(a:build_dir)
            execute '!(mkdir -p ' . build_dir . ' && cd ' . build_dir . ' && cmake ' . join(a:000) . ' ' .  getcwd() . ')'
            if v:shell_error == 0
                let &makeprg = 'cmake --build ' . build_dir . ' -- -j ' . substitute(system('getconf _NPROCESSORS_ONLN'), '\n', '', 'g')
            endif
        else
            echoerr 'CMakeLists.txt not found'
        endif
    endfunction

    autocmd VimEnter * let &path = '.,include,/usr/local/include,' . SystemIncludeDirs('c++', '-x c++ -std=c++11') . ',,'
    command CMakeGnu call CMake('build-gnu', '-DCMAKE_C_COMPILER=gcc-5 -DCMAKE_CXX_COMPILER=g++-5 -DCMAKE_BUILD_TYPE=RelWithDebInfo')
    command CMakeClang call CMake('build-clang', '-DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_BUILD_TYPE=RelWithDebInfo')
endif

set exrc
set secure
