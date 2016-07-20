function! alternatefile#open()
    let extension = expand('%:e')

    if match(extension, '\v\cc+[px]*') != -1
        let extlist = ['.h', '.hpp', '.hxx']
    elseif match(extension, '\v\ch+[px]*') != -1
        let extlist = ['.c', '.cpp', '.cxx']
    else
        echohl WarningMsg | echo "No existing alternate available" | echohl None
        return 0
    endif

    let basename = expand("%:t:r")
    for extension in extlist
        let altname = findfile(basename . extension)
        if altname != ''
            if bufwinnr(altname) != -1
                silent execute bufwinnr(altname) . 'wincmd w'
            elseif bufnr(altname) != -1
                silent execute 'buffer ' . bufnr(altname)
            else
                silent execute 'edit ' . altname
            endif
            return 1
        endif
    endfor

    return 0
endfunction
