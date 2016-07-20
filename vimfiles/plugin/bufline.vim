if exists("g:loaded_bufline")
    finish
endif
let g:loaded_bufline = 1

let s:buflineoffset = 0

function! Abufline(first, last)
    let l:s = ''
    let l:n = a:first
    while l:n <= a:last
        if buflisted(l:n) && getbufvar(l:n, '&buftype') != 'quickfix'
            let l:fn = fnamemodify(bufname(l:n), ':t')
            if !strlen(l:fn)
                let l:fn = '*'
            endif
            if getbufvar(l:n, '&mod')
                let l:fn .= '+'
            endif
            let l:s .= ' ' . l:n . ':' . l:fn . ' '
        endif
        let l:n = l:n + 1
    endwhile
    return l:s
endfunction

function! bufline#render()
    let l:width = &columns - 20
    let l:active = bufnr('%')
    let l:strings = [
                \ Abufline(1, l:active - 1),
                \ Abufline(l:active, l:active),
                \ Abufline(l:active + 1, bufnr('$'))]

    let l:left = strwidth(l:strings[0])
    let l:right = l:left + strwidth(l:strings[1])

    if l:left < s:buflineoffset
        let s:buflineoffset = l:left
    endif
    if l:right > s:buflineoffset + l:width
        let s:buflineoffset = l:right - l:width
    endif

    echohl LineNr | echon "\r" strpart(l:strings[0], s:buflineoffset)
    echohl CursorLineNr	| echon "[" strpart(l:strings[1], 1, l:right - l:left - 2) "]"
    echohl LineNr | echon strpart(l:strings[2], 0, s:buflineoffset + l:width - l:right)
    echohl None
endfunction

augroup bufline
    autocmd!
    autocmd BufEnter * call bufline#render()
augroup END
