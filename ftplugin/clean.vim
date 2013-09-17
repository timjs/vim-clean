" Vim plugin for Clean development
" Last Change:  2013 June 25
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

" We are looking for tags in ./Clean System Files/ModuleName/tags
set tags=./**2/tags

" Use tabs
setlocal shiftwidth=2
setlocal tabstop=2
setlocal softtabstop=2
setlocal noexpandtab

let &cpo = s:save_cpo
