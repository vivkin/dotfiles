if has("win32")
    let &runtimepath.=',$HOME/_vim'
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
Plug 'vim-jp/cpp-vim'
Plug 'kien/ctrlp.vim'
Plug 'bling/vim-airline'
Plug 'tikhomirov/vim-glsl'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'vivkin/vim-call-cmake'
Plug 'gorkunov/smartpairs.vim'
Plug 'kchmck/vim-coffee-script', { 'for': 'coffe' }
call plug#end()

filetype plugin indent on
syntax on
set nocp
set exrc

set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set cinoptions=:0,l1,g0,N-s,(0

set cursorline
set number
set showcmd
set laststatus=2
set listchars=tab:>-,eol:$,trail:-

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

set clipboard=unnamed
set guioptions=mg
set background=dark
if has("gui_running")
    set columns=180 lines=60
    colorscheme gotham
    if has("win32")
        set guifont=Consolas:h11:cRUSSIAN
    else
        set guifont=Menlo
    endif
else
    colorscheme jellybeans
endif

let NERDTreeMinimalUI=1
let g:molokai_original=1
let g:cmake_build_args='-j 9'
let g:airline#extensions#tabline#enabled=1
let mapleader=','

map <F1> :set background=dark<CR>
map <F2> :set background=light<CR>
nmap K i<CR><ESC>
nmap cn :cnext<CR>
nmap cp :cprev<CR>
nmap <C-j> :bnext<CR>
nmap <C-k> :bprevious<CR>
nmap <Tab> <C-w>w
nmap <S-Tab> <C-w>W
nmap <Space> :CtrlP<CR>
nmap <silent> <Leader>d :NERDTreeToggle<CR>
nmap <silent> <Leader>g :Ag! -S <C-R><C-W><CR>
nmap <silent> <Leader>m :make<CR>:botright cwindow<CR>
nmap <silent> <Leader>q :copen<CR>
nnoremap <CR> :nohlsearch<CR><CR>

autocmd BufReadPost quickfix nnoremap <buffer> <silent> q :cclose<CR>
autocmd BufNewFile,BufReadPost *.h,*.hpp,*.cc,*.cxx,*.cpp syn keyword cppType auto
autocmd BufNewFile,BufReadPost *.h,*.hpp,*.c,*.cc,*.cxx,*.cpp setl formatprg=clang-format
autocmd BufNewFile,BufReadPost *.coffee setl tabstop=2 shiftwidth=2
autocmd BufNewFile,BufReadPost *.md,*.txt setl wrap
autocmd BufNewFile,BufReadPost ?akefile* setl noexpandtab
function! SystemIncludeDirs(cc, lang, flags)
    let output = system(a:cc . ' -x ' . a:lang . ' ' . a:flags . ' -v -E - < /dev/null > /dev/null')
    let start = matchend(output, '> search starts here:\n\s\+')
    let end = match(output, '\nEnd of search list.', start)
    let dirs = substitute(strpart(output, start, end - start), '\s*(framework directory)', '', 'g')
    return substitute(dirs, '\n\s*', ',', 'g')
endfunction()
autocmd VimEnter * let &path = '.,include,/usr/local/include,' . SystemIncludeDirs('clang', 'c++', '-std=c++11 -stdlib=libc++') . ',,'
