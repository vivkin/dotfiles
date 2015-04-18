if has("gui_win32")
    set guifont=Consolas:h12:cRUSSIAN
elseif has("gui_gtk")
    set guifont=DejaVu\ Sans\ Mono\ 12,Ubuntu\ Mono\ 12
elseif has("gui_macvim")
    set guifont=Office\ Code\ Pro\ Light:h12,Menlo:h12
endif
set guioptions=c
set guiheadroom=0

if !exists("vimpager")
    set background=dark
    colorscheme base16-harmonic16
endif
set clipboard=unnamed
set lines=512

autocmd GUIEnter * set t_vb=
