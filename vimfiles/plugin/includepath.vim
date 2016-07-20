if exists("g:loaded_includepath")
    finish
endif
let g:loaded_includepath = 1

command! -nargs=+ IncludePath call includepath#add('<args>')
