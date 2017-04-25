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
let macvim_skip_cmd_opt_movement = 1
let macvim_skip_colorscheme = 1
let skip_defaults_vim = 1
" }}}

" remove all vimrc auto commands {{{
augroup startup
    autocmd!
augroup END
" }}}

" setup vim-plug {{{
let g:plug_home = expand('~/.vim/plugged')
let g:plug_url_format = 'https://github.com/%s'

if empty(globpath(&rtp, 'autoload/plug.vim'))
    let s:plug_filename = expand(has('nvim') ? '~/.local/share/nvim/site/autoload/plug.vim' : '~/.vim/autoload/plug.vim')
    let s:plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

    if !isdirectory(fnamemodify(s:plug_filename, ':h'))
        call mkdir(fnamemodify(s:plug_filename, ':h'), 'p')
    endif

    if (executable('python'))
        execute '!python -c "import urllib;urllib.urlretrieve(\"' . s:plug_url . '\", \"' . s:plug_filename . '\")"'
    elseif (executable('curl'))
        execute '!curl --fail --silent --location --output ' . s:plug_filename . ' --url ' . s:plug_url
    elseif (executable('wget'))
        execute '!wget --quiet --output-document ' . s:plug_filename . ' ' . s:plug_url
    endif

    if v:shell_error == 0 && filereadable(s:plug_filename)
        autocmd startup VimEnter * PlugInstall
    endif
endif
" }}}

" switch between header/source {{{
function! s:alternatefile_open()
    let extension = expand('%:e')

    if match(extension, '\v\cc|cpp|cc|cxx|m|mm') != -1
        let extensions = ['.h', '.hpp', '.hh', '.hxx']
    elseif match(extension, '\v\ch|hpp|hh|hxx') != -1
        let extensions = ['.c', '.cpp', '.cc', '.cxx', '.m', '.mm']
    endif

    if exists('extensions')
        let basename = expand("%:t:r")
        for extension in extensions
            let filename = findfile(basename . extension)
            if filename != ''
                if buflisted(filename)
                    if bufwinnr(filename) != -1
                        silent execute bufwinnr(filename) . 'wincmd w'
                    else
                        silent execute 'buffer ' . bufnr(filename)
                    endif
                else
                    silent execute 'edit ' . filename
                endif
                return 1
            endif
        endfor
    endif

    echohl WarningMsg | echo "No existing alternate available" | echohl None
    return 0
endfunction

command! A call s:alternatefile_open()
" }}}

" show color scheme list {{{
function! s:colorlist_open()
    let l:bufname = '\[Color\ List]'

    if bufwinnr(l:bufname) != -1
        silent execute bufwinnr(l:bufname) . 'wincmd w'
    else
        silent execute '32 vnew' l:bufname

        setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile cursorline
        call setline(1, map(globpath(&rtp, 'colors/*.vim', 0, 1), 'fnamemodify(v:val, ":t:r")'))
        setlocal nomodifiable

        nnoremap <silent> <buffer> q :close<CR>

        autocmd CursorMoved <buffer>
                    \ if exists('g:colors_name') && g:colors_name != getline('.') |
                    \   try | execute 'colorscheme ' . getline('.') | finally | endtry |
                    \ endif
    endif

    if exists('g:colors_name')
        call search('^\<' . g:colors_name . '\>$')
    endif
endfunction

command! Colors call s:colorlist_open()
" }}}

" ask which file to open {{{
function! s:didyoumean_ask()
    let filename = expand("%")
    if filereadable(filename) | return | endif

    let filenames = glob(filename . '*', 1, 1)
    if empty(filenames) | return | endif

    let nr = inputlist(['Did you mean:'] + map(range(len(filenames)), 'v:val + 1 . ". " . filenames[v:val]'))
    if nr >= 1 && nr <= len(filenames)
        silent execute 'bwipeout'
        silent execute 'edit ' . filenames[nr - 1]
        filetype detect
    endif
endfunction

autocmd startup BufNewFile * call s:didyoumean_ask()
" }}}

" add compiler include path {{{
function! s:includepath_add(cc)
    let l:output = system(a:cc . " -x c++ -v -E - < /dev/null 2>&1 | sed -e '1,/#include <...> search starts here:/d;/End of search list./,$d;' -e 's/^\ *//;s/\ *(framework directory)$//'")
    for line in split(l:output)
        silent execute 'set path+=' . line
    endfor
endfunction

command! -nargs=+ -complete=shellcmd IncludePath call s:includepath_add('<args>')
" }}}

" status line {{{
function! _statusline_whitespace_warning()
    if &readonly || !&modifiable || &buftype != ''
        return ''
    endif
    if !exists('b:statusline_warning')
        let l:mixed = search('\v(^\t+ +)|(^ +\t+)', 'nw')
        let l:trailing = search('\v\s$', 'nw')
        let b:statusline_warning = ''
        if l:mixed | let b:statusline_warning .= ' mixed-indent:' . l:mixed . ' ' | endif
        if l:trailing | let b:statusline_warning .= ' trailing-space:' .  l:trailing . ' ' | endif
    endif
    return b:statusline_warning
endfunction

autocmd startup BufWritePost,CursorHold * unlet! b:statusline_warning

command! StatusDebugSyn set statusline+=%#Debug#%{join(map(synstack(line('.'),col('.')),'synIDattr(v:val,\"name\")'))}%*
"}}}

" tab line {{{
let g:buflineoffset = 0

function! s:buflabel(num)
    if empty(bufname(a:num))
        if getbufvar(a:num, '&buftype') == 'quickfix'
            let name = 'Quickfix List'
        else
            let name = 'No Name'
        endif
    else
        let name = pathshorten(fnamemodify(bufname(a:num), ':~:.'))
    endif
    return a:num . ':' . (len(name) ? name : bufname(a:num)) . (getbufvar(a:num, '&mod') ? '+' : '')
endfunction

function! _bufline_tabline()
    let width = &columns
    let active = bufnr('%')

    let center = ''
    if buflisted(active)
        let center = '[' . s:buflabel(active) . ']'
    endif

    let left = ''
    for i in filter(range(1, active - 1), 'buflisted(v:val)')
        let left .= ' ' . s:buflabel(i) . ' '
    endfor

    let right = ''
    for i in filter(range(active + 1, bufnr('$')), 'buflisted(v:val)')
        let right .= ' ' . s:buflabel(i) . ' '
    endfor

    let left_end = strwidth(left)
    if g:buflineoffset > left_end | let g:buflineoffset = left_end | endif
    let right_start = left_end + strwidth(center)
    if g:buflineoffset < right_start - width | let g:buflineoffset = right_start - width | endif

    let left = '%#LineNr#'. strpart(left, g:buflineoffset, left_end - g:buflineoffset)
    let center = '%#TabLineSel#' . center
    let right = '%#LineNr#'. strpart(right, 0, g:buflineoffset + width - right_start)

    return left . center . right
endfunction
" }}}

call plug#begin()
" colorschemes
Plug 'freeo/vim-kalisi'
Plug 'morhetz/gruvbox'
Plug 'owickstrom/vim-colors-paramount'
Plug 'rakr/vim-one'
" plugins
Plug 'justinmk/vim-dirvish'
Plug 'majutsushi/tagbar'
Plug 'pboettch/vim-cmake-syntax'
Plug 'skywind3000/asyncrun.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
call plug#end()

filetype plugin indent on
syntax enable

set autoindent
set autoread
set autoread
set autowrite
set backspace=indent,eol,start
if has("patch-7.4.793")
    set belloff=all
endif
set cinoptions=:0,l1,g0,N-s,(0
set clipboard=unnamed
set complete-=i
set cursorline
set display=lastline
set encoding=utf-8
set expandtab
set formatoptions=tcqj
set gdefault
set hidden
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set lazyredraw
set listchars=tab:↹␠,trail:·,eol:␤
set matchpairs+=<:>
set mouse=a
set nocompatible
set nostartofline
set noswapfile
set nowrap
set nowritebackup
if has("patch-7.4.1027")
    set nrformats=bin,hex
endif
set number
set scrolloff=1
set sessionoptions-=options
set shiftwidth=4
set showcmd
set showtabline=2
set sidescrolloff=8
set smartcase
set smartindent
set smarttab
set statusline=\ %f%h%r%m\ %<%=%{&ft!=''?&ft:'no\ ft'}\ \|\ %{&fenc!=''?&fenc:&enc}\ \|\ %{&fileformat}\ %4p%%\ \ %4l:%-4c
set statusline+=%#WarningMsg#%{_statusline_whitespace_warning()}%*
set synmaxcol=1024
set tabline=%!_bufline_tabline()
set tabpagemax=50
set tabstop=4
set tags=./tags;,tags
set ttyfast
set undodir=~/.vim/undo
set undofile
set viewdir=~/.vim/view
if !has('nvim')
    set viminfo+=n~/.vim/info
    set history=10000
endif
set wildmenu
set wildmode=list:longest,full

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
        set guifont=Cousine:h13,Menlo:h13
    endif
endif

set background=dark
silent! colorscheme kalisi

runtime! macros/matchit.vim
runtime! ftplugin/man.vim
cabbrev man Man

" better grep
if executable('ag')
    let &grepprg='ag --vimgrep $*'
    let &grepformat='%f:%l:%c:%m'
else
    let &grepprg='grep -r -n $* . /dev/null'
    let &grepformat='%f:%l:%m'
endif

command! -bang Buffer ls<bang> | let nr = input('Which one: ') | if nr != '' | execute nr != 0 ? 'buffer ' . nr : 'enew' | endif
command! -complete=file -nargs=* Grep execute 'AsyncRun -program=grep @ ' . (empty(<q-args>) ? expand("<cword>") : <q-args>)
command! -bang -complete=file -nargs=* Make AsyncRun -save=1 -program=make @ <args>

augroup startup
    autocmd BufReadPost * if line("'\"") >= 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
    autocmd BufReadPost */include/c++/* setl ft=cpp
    autocmd CmdwinEnter * nnoremap <buffer> <silent> q :close<CR>
    autocmd FileType * setl formatoptions-=o
    autocmd FileType c,cpp,objc,objcpp setl formatprg=clang-format
    autocmd FileType cmake setl nowrap tabstop=2 shiftwidth=2
    autocmd FileType help,qf nnoremap <buffer> <silent> q :close<CR>
    autocmd FileType make setl noexpandtab
    autocmd FileType markdown setl wrap linebreak
    autocmd FileType qf let &l:statusline = substitute(&g:statusline, "%h", "[%{g:asyncrun_status}]%{exists('w:quickfix_title')?w:quickfix_title:''}", "")
augroup END

cnoremap <C-n> <DOWN>
cnoremap <C-p> <UP>
cnoremap <CR> <C-\>esubstitute(getcmdline(), '<C-v><C-m>', '\\n', 'g')<CR><CR>

inoremap <C-u> <C-g>u<C-u>

nnoremap <BS> :nohlsearch<CR><BS>
nnoremap <CR> :nohlsearch<CR><CR>
nnoremap <Space> :nohlsearch<CR><Space>
nnoremap <silent> <C-n> :bnext<CR>
nnoremap <silent> <C-p> :bprevious<CR>
nnoremap <silent> <Leader>B :B!<CR>
nnoremap <silent> <Leader>b :B<CR>
nnoremap <silent> <Leader>c :copen<CR>
nnoremap <silent> <Leader>m :wall<CR>:Make<CR>:call asyncrun#quickfix_toggle(&lines / 4, 1)<CR>
nnoremap <silent> <Leader>x :bdelete<CR>
nnoremap K i<CR><ESC>
nnoremap Q ZQ

set exrc
set secure

" vim:set fdm=marker fdl=0:
