" Vim plugin for Clean development
" Last Change:  2015 Feb. 21
" Maintainer:   Jurriën Stutterheim <j.stutterheim@cs.ru.nl>
" License:      This file is placed in the public domain.

let file_ext  = expand("%:e")
let file_name = expand("%:r")

if file_ext == "icl" || file_ext == "dcl"
  exec "set tags+=" . getcwd() . "/Clean\\\\\\\ System\\\\\\\ Files/ctags/" . file_name . "_tags;"
endif

if exists("g:loaded_clean")
  finish
endif
let g:loaded_clean = 1

let s:save_cpo = &cpo
set cpo&vim

function! SwitchCleanModule()
  if expand("%:e") == "icl"
    let newfn = file_name . "." . "dcl"
  else
    let newfn = file_name . "." . "icl"
  endif
  execute ("edit " . newfn)
endfunction

map <leader>m :call SwitchCleanModule()<CR>

command CpmMake !cpm make

let &cpo = s:save_cpo
