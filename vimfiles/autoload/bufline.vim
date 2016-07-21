let s:buflineoffset = 0

function! bufline#generate(first, last)
    let l:s = ''
    let l:n = a:first
    while l:n <= a:last
        if buflisted(l:n) && getbufvar(l:n, '&buftype') != 'quickfix'
            let l:fn = l:n . ':' . fnamemodify(bufname(l:n), ':t')
            if bufname(l:n) == ''
                let l:fn .= '*'
            endif
            if getbufvar(l:n, '&mod')
                let l:fn .= '+'
            endif
            if bufnr('%') == l:n
                let l:s .= '[' . l:fn . ']'
            else
                let l:s .= ' ' . l:fn . ' '
            endif
        endif
        let l:n = l:n + 1
    endwhile
    return l:s
endfunction

function! bufline#render()
    let l:active = bufnr('%')
    let l:strings = [
                \ bufline#generate(1, l:active - 1),
                \ bufline#generate(l:active, l:active),
                \ bufline#generate(l:active + 1, bufnr('$'))]

    let l:width = &columns - 12
    let l:left = strwidth(l:strings[0])
    let l:right = l:left + strwidth(l:strings[1])

    if s:buflineoffset > l:left
        let s:buflineoffset = l:left
    endif
    if s:buflineoffset + l:width < l:right
        let s:buflineoffset = l:right - l:width
    endif

    echohl LineNr | echon "\r" strpart(l:strings[0], s:buflineoffset)
    echohl CursorLineNr | echon l:strings[1]
    echohl LineNr | echon strpart(l:strings[2], 0, s:buflineoffset + l:width - l:right)
    echohl None
endfunction
