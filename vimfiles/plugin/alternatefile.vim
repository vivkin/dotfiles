if exists("g:loaded_alternatefile")
    finish
endif
let g:loaded_alternatefile = 1

command! A call alternatefile#open()
