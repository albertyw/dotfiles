augroup filetypes
    " GoFmt
    autocmd BufWritePre <buffer> call go#fmt#Format(-1)

    " GoImports
    autocmd BufWritePre <buffer> call go#fmt#Format(1)
augroup END

" Use tabs, not spaces
setlocal noexpandtab
