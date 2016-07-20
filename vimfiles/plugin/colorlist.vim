if exists("g:loaded_colorlist")
    finish
endif
let g:loaded_colorlist = 1

command! ColorListShow call colorlist#show()
