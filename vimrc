set nocompatible

filetype plugin indent on

call plug#begin('~/.vim/plugged')
Plug 'NLKNguyen/papercolor-theme'
Plug 'altercation/vim-colors-solarized'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'jeetsukumaran/vim-buffergator'
Plug 'mbbill/undotree'
Plug 'mhartington/oceanic-next'
Plug 'nanotech/jellybeans.vim'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'rking/ag.vim'
Plug 'rust-lang/rust.vim'
Plug 'scrooloose/nerdtree'
Plug 'tikhomirov/vim-glsl'
Plug 'tomasr/molokai'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-unimpaired'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-scripts/a.vim'
Plug 'vivkin/cpp-vim'
Plug 'vivkin/flatland.vim'
Plug 'w0ng/vim-hybrid'
call plug#end()

set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set cinoptions=:0,l1,g0,N-s,(0

set ttyfast
set cursorline
set number
set noshowcmd
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
set wildmode=longest,full
set visualbell t_vb=

set autoread
set autowrite
set noswapfile
set nowritebackup
set undofile
set undodir=~/.vimundo
set history=150

let g:airline_extensions = ['whitespace', 'tabline', 'branch']
let g:airline_powerline_fonts=1
let g:buffergator_autoexpand_on_split=0
let g:buffergator_suppress_keymaps=1
let g:ag_prg='ag --vimgrep --ignore tags'
let NERDTreeMinimalUI=1
let mapleader=','

nmap K i<CR><ESC>
nmap cn :cnext<CR>
nmap cp :cprev<CR>
nmap <C-j> :bnext<CR>
nmap <C-k> :bprevious<CR>
nmap <Tab> <C-w>w
nmap <S-Tab> <C-w>W
nmap <silent> <Leader>b :BuffergatorToggle<CR>
nmap <silent> <Leader>B :BuffergatorTabsToggle<CR>
nmap <silent> <Leader>n :NERDTreeToggle<CR>
nmap <silent> <Leader>N :NERDTree %<CR>
nmap <silent> <Leader>g :Ag! -S <C-R><C-W><CR>
nmap <silent> <Leader>G :Ag! -w <C-R><C-W><CR>
nmap <silent> <Leader>m :make<CR>:botright cwindow<CR>
nmap <silent> <D-r> :make all run<CR>:botright cwindow<CR>
nmap <silent> <Leader>c :copen<CR>
nnoremap <CR> :nohlsearch<CR><CR>
noremap \ ,

autocmd BufReadPost quickfix nnoremap <buffer> <silent> q :cclose<CR>
autocmd BufNewFile,BufReadPost *.h,*.hpp,*.c,*.cc,*.cxx,*.cpp setl formatprg=clang-format
autocmd BufNewFile,BufReadPost *.coffee setl tabstop=2 shiftwidth=2
"autocmd BufNewFile,BufReadPost *.md,*.txt setl wrap linebreak
autocmd FileType markdown setl wrap linebreak
"autocmd BufNewFile,BufReadPost CMakeLists.txt set nowrap
autocmd FileType cmake setl nowrap tabstop=2 shiftwidth=2
"autocmd BufNewFile,BufReadPost ?akefile* setl noexpandtab
autocmd FileType make setl noexpandtab

syntax on
if has("gui_running")
    autocmd GUIEnter * set t_vb=

    if has("gui_win32")
        set guifont=Consolas:h12:cRUSSIAN
    elseif has("gui_gtk")
        set guifont=DejaVu\ Sans\ Mono\ 12,Ubuntu\ Mono\ 12
    elseif has("gui_macvim")
        set macmeta
        set guifont=Office\ Code\ Pro:h13,Menlo:h13
    endif
    set guioptions=c
    set guiheadroom=0

    set columns=160
    set clipboard=unnamed
    set background=light
    colorscheme solarized
    "let g:airline_theme='flatlandia'
else
    set t_Co=256
    set background=dark
    colorscheme jellybeans
endif

if has("unix")
    function! SystemIncludeDirs(cc)
        let output = system(a:cc . ' -v -E - < /dev/null > /dev/null')
        let dirs = matchstr(output, '\v\> search starts here:\n\s*\zs(\n|.)*\n\zeEnd of search list')
        return substitute(dirs, '\v(\s*\(framework directory\))?\n\s*', ',', 'g')
    endfunction()
    autocmd VimEnter * let &path .= '/usr/local/include,' . SystemIncludeDirs('c++ -x c++ -std=c++11')

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
    command CMakeGnu call CMake('build-gnu', '-DCMAKE_C_COMPILER=gcc-5 -DCMAKE_CXX_COMPILER=g++-5 -DCMAKE_BUILD_TYPE=RelWithDebInfo')
    command CMakeClang call CMake('build-clang', '-DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_BUILD_TYPE=RelWithDebInfo')
endif

set exrc
set secure

runtime ftplugin/man.vim
runtime macros/matchit.vim
