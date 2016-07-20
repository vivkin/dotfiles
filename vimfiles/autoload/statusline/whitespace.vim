if exists("g:loaded_statusline_whitespace")
    finish
endif
let g:loaded_statusline_whitespace = 1

function! statusline#whitespace#warning()
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

augroup statusline#whitespace
    autocmd!
    autocmd BufWritePost,CursorHold * unlet! b:statusline_warning
augroup END
