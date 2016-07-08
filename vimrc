set nocompatible

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

function! GetBufferLine()
    redir => buffers_output
    silent buffers
    redir END
    let bufline = ''
    for line in split(buffers_output, '\n')
        let info = matchlist(line, '\v(\d+)\s*(....)\s*\"([^\"]*)\"\s+\w+\s+(\d+)')
        let name = fnamemodify(info[3], ':t')
        if info[2][3] == '+'
            let name .= '+'
        endif
        if info[2][0] == '%'
            let g:activebufnr = info[1] + 0
            let name = '[' . name . ']'
        elseif info[2][0] == '#'
            let name = '^' . name
        endif
        let bufline .= ' ' . name . ' '
    endfor
    return bufline
endfunction

function! s:RefreshStatus()
    for nr in range(1, winnr('$'))
        call setwinvar(nr, '&statusline', (nr == winnr() && buflisted(winbufnr(nr)) ? g:buftabline : s:statuslineleft) . s:statuslineright)
    endfor
endfunction

let g:buftabline = GetBufferLine()
let s:statuslineleft = ' %f%h%r%m'
let s:statuslineright = ' %<%=%{&ft!=""?&ft:"no ft"} | %{&fenc!=""?&fenc:&enc} | %{&fileformat} %4p%%  %4l:%-4c'
let &statusline = s:statuslineleft . s:statuslineright

augroup status
    autocmd!
    autocmd BufWinEnter,VimEnter,WinEnter * call <SID>RefreshStatus()
    autocmd BufDelete,BufEnter,BufNew,BufWritePost,InsertLeave,VimEnter * let g:buftabline = GetBufferLine()
augroup END

function! ColorsList()
    let colorslist_name = '\[Color\ List]'
    if bufwinnr(colorslist_name) != -1
        silent execute bufwinnr(colorslist_name) . 'wincmd w'
    else
        silent execute '32 vnew' colorslist_name
        call setline(1, map(globpath(&rtp, 'colors/*.vim', 0, 1), 'fnamemodify(v:val, ":t:r")'))
        setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nomodifiable nonumber nowrap
        nnoremap <silent> <buffer> q :close<CR>
        autocmd CursorMoved <buffer> try | syntax sync fromstart | execute  'colorscheme ' . getline('.') | finally | endtry
    endif
    if exists('g:colors_name')
        call search('^\<' . g:colors_name . '\>$')
    endif
endfunction
command! Colors call ColorsList()

function! CompilerIncludePath(cc)
    let output = system(a:cc . ' -v -E - < /dev/null > /dev/null')
    let dirs = matchstr(output, '\v\> search starts here:\n\s*\zs(\n|.)*\n\zeEnd of search list')
    return substitute(dirs, '\v(\s*\(framework directory\))?\n\s*', ',', 'g')
endfunction
command! -nargs=+ IncludePath let &path.=CompilerIncludePath('<args>')
command! PathGNU IncludePath gcc-6 -x c++ -std=c++14
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

function! AlternateFile()
    if match(expand('%:e'), '\v\cc+[px]*') != -1
        setl suffixesadd=.h,.hpp,.hxx
        execute 'find %:t:r'
    elseif match(expand('%:e'), '\v\ch+[px]*') != -1
        setl suffixesadd=.c,.cc,.cpp,.cxx,.m,.mm
        execute 'find %:t:r'
    else
        echohl WarningMsg | echo "No existing alternate available" | echohl None
    endif
endfunction
command! A call AlternateFile()

command! -bang B ls<bang> | let nr = input('Which one: ') | if nr != '' | execute nr != 0 ? 'buffer ' . nr : 'enew' | endif

filetype plugin indent on
augroup filetypes
    autocmd!
    autocmd FileType help,qf nnoremap <buffer> <silent> q :close<CR>
    autocmd FileType c,cpp setl formatprg=clang-format
    autocmd FileType cmake setl nowrap tabstop=2 shiftwidth=2
    autocmd FileType make setl noexpandtab
    autocmd FileType markdown setl wrap linebreak
    autocmd FileType * setl formatoptions-=o
    autocmd BufReadPost */include/c++/* setf cpp
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
"set statusline=\ %f%h%r%m\ \|\ %{s:bufline}\ %<%=%{&ft!=''?&ft:'no\ ft'}\ \|\ %{&fenc!=''?&fenc:&enc}\ \|\ %{&fileformat}\ %4p%%\ \ %4l:%-4c

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
set wildmode=longest,full

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
        let macvim_skip_colorscheme = 1
        let macvim_skip_cmd_opt_movement = 1
    endif
endif

syntax on
set t_Co=256
set synmaxcol=1024
set background=dark
if has("gui_running") | colorscheme toothpaste | else | colorscheme gruvbox | endif

cnoremap <C-n> <DOWN>
cnoremap <C-p> <UP>
cnoremap <CR> <C-\>esubstitute(getcmdline(), '<C-v><C-m>', '\\n', 'g')<CR><CR>

nnoremap <C-n> :bnext<CR>
nnoremap <C-p> :bprevious<CR>
nnoremap <CR> :nohlsearch<CR><CR>
nnoremap <D-[> <C-w>W
nnoremap <D-]> <C-w>w
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
