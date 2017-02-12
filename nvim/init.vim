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

" setup vim-plug {{{
if empty(globpath(&rtp, 'autoload/plug.vim'))
    let s:plug_filename = expand('~/.vim/autoload/plug.vim')
    let s:plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

    if !isdirectory(fnamemodify(s:plug_filename, ':h'))
        call mkdir(fnamemodify(s:plug_filename, ':h'), 'p')
    endif

    if (executable('curl'))
        silent execute '!curl --fail --silent --location --output ' . s:plug_filename . ' --url ' . s:plug_url
    elseif (executable('wget'))
        silent execute '!wget --quiet --output-document ' . s:plug_filename . ' ' . s:plug_url
    elseif (executable('python'))
        silent execute '!python -c "import urllib;urllib.urlretrieve(\"' . s:plug_url . '\", \"' . s:plug_filename . '\")'
    endif

    if v:shell_error == 0 && filereadable(s:plug_filename)
        autocmd VimEnter * PlugInstall
    endif
endif

call plug#begin('~/.vim/plugged')
" colorschemes
Plug 'rakr/vim-one'
Plug 'freeo/vim-kalisi'
Plug 'morhetz/gruvbox'
" plugins
Plug 'majutsushi/tagbar'
Plug 'skywind3000/asyncrun.vim'
Plug 'justinmk/vim-dirvish'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
call plug#end()
" }}}

augroup startup
    autocmd!
    autocmd FileType c,cpp,objc,objcpp setl formatprg=clang-format
    autocmd FileType cmake setl nowrap tabstop=2 shiftwidth=2
    autocmd FileType make setl noexpandtab
    autocmd FileType markdown setl wrap linebreak
    autocmd FileType * setl formatoptions-=o
    autocmd BufReadPost */include/c++/* setl ft=cpp
    " always jump to the last known cursor position
    autocmd BufReadPost * if line("'\"") >= 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
    " close command window, help and quick fix by q
    autocmd CmdwinEnter * nnoremap <buffer> <silent> q :close<CR>
    autocmd FileType help,qf nnoremap <buffer> <silent> q :close<CR>
augroup END

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
                if bufwinnr(filename) != -1
                    silent execute bufwinnr(filename) . 'wincmd w'
                elseif bufnr(filename) != -1
                    silent execute 'buffer ' . bufnr(filename)
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

command! -bang B ls<bang> | let nr = input('Which one: ') | if nr != '' | execute nr != 0 ? 'buffer ' . nr : 'enew' | endif
command! -nargs=* G silent execute 'grep! ' . escape(empty(<q-args>) ? expand("<cword>") : <q-args>, '|') | botright cwindow
command! -nargs=1 -complete=help H enew | setl buftype=help | execute 'help <args>' | setl buflisted
command! -bang -nargs=* -complete=file M AsyncRun -program=make @ <args>
" see the difference between the current buffer and the file it was loaded from
command! DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis | wincmd p | diffthis

" better grep
if executable('ag')
    let &grepprg='ag --vimgrep $*'
    let &grepformat='%f:%l:%c:%m'
else
    let &grepprg='grep -r -n $* . /dev/null'
    let &grepformat='%f:%l:%m'
endif

" status line {{{
function! init#statusline_whitespace_warning()
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

function! init#bufline_tabline()
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

filetype plugin indent on
syntax enable

runtime! macros/matchit.vim
runtime! ftplugin/man.vim

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
set history=10000
set hlsearch
set ignorecase
set incsearch
set langnoremap
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
if has("patch-7.4.806")
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
set statusline+=%#WarningMsg#%{init#statusline_whitespace_warning()}%*
set statusline=\ %f%h%r%m\ %<%=%{&ft!=''?&ft:'no\ ft'}\ \|\ %{&fenc!=''?&fenc:&enc}\ \|\ %{&fileformat}\ %4p%%\ \ %4l:%-4c
"set statusline+=%#Debug#%{join(map(synstack(line('.'),col('.')),'synIDattr(v:val,\"name\")'))}%*
set synmaxcol=1024
set tabline=%!init#bufline_tabline()
set tabpagemax=50
set tabstop=4
set tags=./tags;,tags
set ttyfast
set undodir=~/.vim/undo
set undofile
set viewdir=~/.vim/view
if !has('nvim')
    set viminfo=!,'100,<50,s10,h,n~/.vim/info
endif
set wildmenu
set wildmode=list:longest,full

for path in [&undodir, &viewdir]
    if !isdirectory(expand(path))
        call mkdir(expand(path), 'p')
    endif
endfor

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
nnoremap <silent> <Leader>x :bdelete<C>
nnoremap K i<CR><ESC>
nnoremap Q ZQ

" vim:set fdm=marker fdl=0:
