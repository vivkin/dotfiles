function! includepath#add(cc)
    let l:output = system(a:cc . " -x c++ -v -E - < /dev/null 2>&1 | sed -e '1,/#include <...> search starts here:/d;/End of search list./,$d;' -e 's/^\ *//;s/\ *(framework directory)$//'")
    for line in split(l:output)
        silent execute 'set path+=' . line
    endfor
endfunction
