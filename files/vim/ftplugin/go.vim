" GoFmt
autocmd BufWritePre <buffer> call go#fmt#Format(-1)

" GoImports
autocmd BufWritePre <buffer> call go#fmt#Format(1)

" Use tabs, not spaces
setlocal noexpandtab
