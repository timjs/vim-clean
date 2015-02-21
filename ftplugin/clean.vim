" Vim plugin for Clean development
" Last Change:  2015 Feb. 21
" Maintainer:   Jurriën Stutterheim <j.stutterheim@cs.ru.nl>
" License:      This file is placed in the public domain.

if exists("g:loaded_clean")
  finish
endif
let g:loaded_clean = 1

let s:save_cpo = &cpo
set cpo&vim

function! SwitchCleanModule()
  let filenm = expand("%:r")
  if expand("%:e") == "icl"
    let newfn = filenm . "." . "dcl"
  else
    let newfn = filenm . "." . "icl"
  endif
  execute ("edit " . newfn)
endfunction

map <leader>m :call SwitchCleanModule()<CR>

command CpmMake !cpm make

set tags+=./Clean\\\ System\\\ Files/**/tags

let &cpo = s:save_cpo
