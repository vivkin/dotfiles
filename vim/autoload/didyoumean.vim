function! didyoumean#ask()
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
