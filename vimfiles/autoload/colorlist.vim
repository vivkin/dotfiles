function! colorlist#open()
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
