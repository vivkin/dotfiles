set nocompatible

" disable macvim useless stuff
if has("gui_macvim")
    let macvim_skip_colorscheme = 1
    let macvim_skip_cmd_opt_movement = 1
endif

let mapleader=','

let g:buffergator_autoexpand_on_split=0
let g:buffergator_suppress_keymaps=1
let g:ag_prg='ag --vimgrep --ignore tags'

call plug#begin('~/.vim/plugged')
Plug 'vivkin/flatland.vim'
Plug 'EinfachToll/DidYouMean'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'flazz/vim-colorschemes'
Plug 'jeetsukumaran/vim-buffergator'
Plug 'jeetsukumaran/vim-filebeagle'
Plug 'junegunn/gv.vim'
Plug 'mbbill/undotree'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'rking/ag.vim'
Plug 'rust-lang/rust.vim'
Plug 'tikhomirov/vim-glsl'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-unimpaired'
Plug 'vim-scripts/a.vim'
Plug 'vivkin/cpp-vim'
call plug#end()

runtime ftplugin/man.vim
runtime macros/matchit.vim

function! ColorsList()
    let name = fnameescape('[Color List]')
    let wn = bufwinnr(name)
    if wn == -1
        silent! execute '32 vnew' name
        call setline(1, map(globpath(&rtp, 'colors/*.vim', 0, 1), 'fnamemodify(v:val, ":t:r")'))
        setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nomodifiable nonumber nowrap
        nnoremap <silent> <buffer> q :close<CR>
        nnoremap <silent> <buffer> o :execute 'colorscheme ' . getline('.')<CR>
    else
        silent! execute wn . 'wincmd w'
    endif
    if exists('g:colors_name')
        silent! execute '/' . g:colors_name
    endif
endfunction
command! Colors call ColorsList()

function! CompilerIncludePath(cc)
    let output = system(a:cc . ' -v -E - < /dev/null > /dev/null')
    let dirs = matchstr(output, '\v\> search starts here:\n\s*\zs(\n|.)*\n\zeEnd of search list')
    return substitute(dirs, '\v(\s*\(framework directory\))?\n\s*', ',', 'g')
endfunction
command! -nargs=+ IncludePath let &path.=CompilerIncludePath('<args>')
command! PathGNU IncludePath gcc-5 -x c++ -std=c++14
command! PathClang IncludePath clang -x c++ -std=c++14

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
command! CMakeGNU call CMake('build-gnu', '-DCMAKE_C_COMPILER=gcc-5 -DCMAKE_CXX_COMPILER=g++-5 -DCMAKE_BUILD_TYPE=RelWithDebInfo')
command! CMakeClang call CMake('build-clang', '-DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_BUILD_TYPE=RelWithDebInfo')

filetype plugin indent on

augroup filetypes
    autocmd!
    autocmd FileType * setl formatoptions-=r
    autocmd FileType help,qf nnoremap <buffer> <silent> q :close<CR>
    autocmd FileType c,cpp setl formatprg=clang-format
    autocmd FileType cmake setl nowrap tabstop=2 shiftwidth=2
    autocmd FileType make setl noexpandtab
    autocmd FileType markdown setl wrap linebreak
augroup END

" map russian for normal mode
set langmap=ЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ;QWERTYUIOP{}ASDFGHJKL:\"ZXCVBNM<>,йцукенгшщзхъфывапролджэячсмитьбю;qwertyuiop[]asdfghjkl\\\;'zxcvbnm\\\,.
set langnoremap

" status line
set laststatus=2
set statusline=\ %f%h%r%m\ %<%=%{&ft!=''?&ft:'no\ ft'}\ \|\ %{&fenc!=''?&fenc:&enc}\ \|\ %{&fileformat}\ %4p%%\ \ %4l:%-4c

set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set cinoptions=:0,l1,g0,N-s,(0

set ttyfast
set lazyredraw
set cursorline
set number
set noshowcmd
set encoding=utf-8
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
set wildmode=longest,full
set visualbell t_vb=

set autoread
set autowrite
set noswapfile
set nowritebackup
set undofile
set undodir=~/.vimundo
set history=10000

nmap K i<CR><ESC>
nmap cn :cnext<CR>
nmap cp :cprev<CR>
nmap <C-j> :bnext<CR>
nmap <C-k> :bprevious<CR>
nmap <Tab> <C-w>w
nmap <S-Tab> <C-w>W
nmap <silent> <Leader>b :BuffergatorToggle<CR>
nmap <silent> <Leader>B :BuffergatorTabsToggle<CR>
nmap <silent> <Leader>g :Ag! -S <C-R><C-W><CR>
nmap <silent> <Leader>G :Ag! -w <C-R><C-W><CR>
nmap <silent> <Leader>m :make<CR>:botright cwindow<CR>
nmap <silent> <D-r> :make all run<CR>:botright cwindow<CR>
nmap <silent> <Leader>c :copen<CR>
nnoremap <CR> :nohlsearch<CR><CR>

syntax on
set synmaxcol=1024

if has("gui_running")
    autocmd GUIEnter * set t_vb=

    if has("gui_win32")
        set guifont=Consolas:h12:cRUSSIAN
    elseif has("gui_gtk")
        set guifont=DejaVu\ Sans\ Mono\ 12,Ubuntu\ Mono\ 12
    elseif has("gui_macvim")
        set linespace=1
        set guifont=Office\ Code\ Pro:h13,Menlo:h13
    endif
    set guioptions=c
    set guiheadroom=0

    set columns=160
    set clipboard=unnamed
    set background=light
    colorscheme solarized
else
    set t_Co=256
    set background=dark
    colorscheme jellybeans
endif

set exrc
set secure
