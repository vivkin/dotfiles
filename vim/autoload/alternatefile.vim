function! alternatefile#open()
    let extension = expand('%:e')

    if match(extension, '\v\cc+[px]*') != -1
        let extensions = ['.h', '.hpp', '.hxx']
    elseif match(extension, '\v\ch+[px]*') != -1
        let extensions = ['.c', '.cpp', '.cxx']
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
