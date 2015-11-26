" PathSep returns the appropriate OS specific path separator.
function! go#util#PathSep()
	if go#util#IsWin()
		return '\'
	endif
	return '/'
endfunction

" PathListSep returns the appropriate OS specific path list separator.
function! go#util#PathListSep()
	if go#util#IsWin()
		return ";"
	endif
	return ":"
endfunction

" LineEnding returns the correct line ending, based on the current fileformat
function! go#util#LineEnding()
	if &fileformat == 'dos'
		return "\r\n"
	elseif &fileformat == 'mac'
		return "\r"
	endif

	return "\n"
endfunction

" IsWin returns 1 if current OS is Windows or 0 otherwise
function! go#util#IsWin()
	let win = ['win16', 'win32', 'win64', 'win95']
	for w in win
		if (has(w))
			return 1
		endif
	endfor

	return 0
endfunction

" StripPath strips the path's last character if it's a path separator.
" example: '/foo/bar/'  -> '/foo/bar'
function! go#util#StripPathSep(path)
	let last_char = strlen(a:path) - 1
	if a:path[last_char] == go#util#PathSep()
		return strpart(a:path, 0, last_char)
	endif

	return a:path
endfunction

" Shelljoin returns a shell-safe string representation of arglist. The
" {special} argument of shellescape() may optionally be passed.
function! go#util#Shelljoin(arglist, ...)
	if a:0
		return join(map(copy(a:arglist), 'shellescape(v:val, ' . a:1 . ')'), ' ')
	else
		return join(map(copy(a:arglist), 'shellescape(v:val)'), ' ')
	endif
endfunction


" Cwindow opens the quickfix window with the given height up to 10 lines
" maximum. Otherwise g:go_quickfix_height is used. If no or zero height is
" given it closes the window
function! go#util#Cwindow(...)
    " we don't use cwindow to close the quickfix window as we need also the
    " ability to resize the window. So, we are going to use copen and cclose
    " for a better user experience. If the number of errors in a current
    " quickfix list increases/decreases, cwindow will not resize when a new
    " updated height is passed. copen in the other hand resizes the screen.
    if !a:0 || a:1 == 0
        cclose
        return
    endif

    let height = get(g:, "go_quickfix_height", 0)
    if height == 0
        " prevent creating a large quickfix height for a large set of numbers
        if a:1 > 10
            let height = 10
        else
            let height = a:1
        endif
    endif

    exe 'copen '. height
endfunction

" vim:ts=4:sw=4:et
