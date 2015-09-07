" Vim compiler file
" Compiler:     Clean Project Manager
" Maintainer:   Tim Steenvoorden <tim.steenvoorden@gmail.com>
" Last Change:  7 Sep 2014

" Initialize Compiler File: {{{1
" =========================

if exists('b:current_compiler')
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

" Setups: {{{1
" =======

let b:clean_project_file = glob('*.prj') "FIXME may return multiple files

let &l:makeprg = 'cpm project ' . b:clean_project_file . ' build'

setlocal isfname-=,
let &l:errorformat  = '%EError [%f\,%l\,%s]: %m' " Compiler error
let &l:errorformat .= ',%EParse error [%f\,%l;%c\,%s]: %m' " Parse error
let &l:errorformat .= ',%-G%.%#' " Ignore rest

" Finalize Compiler File: {{{1
" =======================

let b:current_compiler = 'cpm'

let &cpo = s:cpo_save
unlet s:cpo_save

" vim: ts=2 sw=2 fdm=marker
