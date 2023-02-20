" Vim color file
" albertyw
" Created by @albertyw with ThemeCreator (https://github.com/mswift42/themecreator)

hi clear

if exists("syntax on")
syntax reset
endif

set t_Co=256
let g:colors_name = "albertyw"

" Define reusable colorvariables.
let s:bg="#000000"
let s:fg="#6af554"
let s:fg2="#62e14d"
let s:fg3="#59ce47"
let s:fg4="#51ba40"
let s:bg2="#141414"
let s:bg3="#292929"
let s:bg4="#3d3d3d"
let s:keyword="#fefa28"
let s:builtin="#fefa28"
let s:const= "#64e5fb"
let s:comment="#8ef9fd"
let s:func="#64e5fb"
let s:str="#f07ef8"
let s:type="#fefa28"
let s:var="#64e5fb"
let s:warning="#ff0000"
let s:warning2="#ff8800"

set cursorline
hi CursorLine cterm=NONE ctermbg=DarkBlue
