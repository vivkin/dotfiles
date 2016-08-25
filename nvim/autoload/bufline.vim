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

function! bufline#tabline()
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
