" Clean syntax file
" Language: Clean
" Maintainer: Jurriën Stutterheim
" Latest Revision: 2013 June 25

if exists("b:clean_syntax")
  finish
endif


let s:LowerCaseChar         = '\l'
let s:UpperCaseChar         = '\u'
let s:SpecialChar           = '\~\|@\|#\|\$\|%\|\^\|?\|!\|+\|-\|\*\|<\|>\|\\\|\/\||\|&\|=\|:'
let s:Digit                 = '\d'
let s:IdChar                = s:LowerCaseChar . '\|' . s:UpperCaseChar . '\|' . s:Digit . '\|_\|`'

let s:LowerCaseId           = s:LowerCaseChar . '\(' . s:IdChar . '\)*'
let s:UpperCaseId           = s:UpperCaseChar . '\(' . s:IdChar . '\)*'
let s:UpperCaseModuleId     = s:UpperCaseChar . '\(' . s:IdChar . '\|\.\)*'
let s:LowerCaseModuleId     = s:LowerCaseChar . '\(' . s:IdChar . '\|\.\)*'
let s:FunnyId               = '\(' . s:SpecialChar . '\)\+'
let s:FunnyModuleId         = '\(' . s:LowerCaseChar . '\|' . s:UpperCaseChar . '\|\.\)*' . s:FunnyId

"Inefficient representation: let s:ModuleName            = '\(' . s:LowerCaseModuleId . '\|' . s:UpperCaseModuleId . '\|' . s:FunnyModuleId . '\)'
let s:ModuleName            = '\(' . s:LowerCaseChar . '\|' . s:UpperCaseChar . '\)\(' . s:LowerCaseChar . '\|' . s:UpperCaseChar . '\|' . s:Digit . '\|' . s:SpecialChar . '\|\.\)*'
let s:CommonName            = '\(' . s:LowerCaseChar . '\|' . s:UpperCaseChar . '\)\(' . s:IdChar . '\)*\|' . s:FunnyId
let s:FunctionName          = s:CommonName
let s:ConstructorName       = '\(' . s:UpperCaseId . '\|' . s:FunnyId . '\)'
let s:SelectorVariable      = s:LowerCaseId
let s:Variable              = s:CommonName
let s:FieldName             = s:LowerCaseId
let s:TypeName              = '\(' . s:UpperCaseId . '\|' . s:FunnyId . '\)'
let s:TypeVariable          = s:LowerCaseId
let s:UniqueTypeVariable    = s:LowerCaseId
let s:ClassName             = s:CommonName
let s:MemberName            = s:CommonName

function! MN()
  echo '\(' . s:TypeVariable . '\)\?\(\s\+' . s:TypeVariable . '\+\)*'
endfunction

syn match cleanSemiColon ";" display contained
syn match cleanComma "," display contained
syn cluster cleanPunctiation contains=cleanSemiColon,cleanComma

let s:Fix = '\<infix[rl]\?\>'
let s:CleanFix = 'syn match cleanFix "' . s:Fix . '" display contained'
exec s:CleanFix

let s:Prec = '\<' . s:Digit . '\>'
let s:CleanPrec = 'syn match cleanPrec "' . s:Prec . '" display contained'
exec s:CleanPrec

let s:CleanTypeVariable = 'syn match cleanTypeVariable "' . s:TypeVariable . '" display contained'
exec s:CleanTypeVariable

let s:CleanConstructorName = 'syn match cleanConstructorName "' . s:ConstructorName . '" display contained'
exec s:CleanConstructorName

"syn match cleanStrict '!' display contained

"let s:CleanUnqTypeAttrib = 'syn match cleanUnqTypeAttrib "\*\|\.\|' . s:UniqueTypeVariable . ':" display contained'
"exec s:CleanUnqTypeAttrib

"syntax cluster cleanBrackType contains=cleanUniversalQuantVariables,cleanStrict,cleanUnqTypeAttrib,cleanTypeExpression
"syntax cluster cleanType contains=@cleanBrackType

"let s:BrackType = ''
"let s:CleanBrackType = 'syn match cleanBrackType "' . s:BrackType . '" contained display skipwhite'
"exec s:CleanBrackType

"let s:Constructor = '(\?\s*' . s:ConstructorName . '\s*)\?'
"let s:CleanConstructor = 'syn match cleanConstructor "' . s:Constructor . '" display skipwhite contains=cleanConstructorName contained nextgroup=cleanFix,cleanPrec,@cleanBrackType'
"exec s:CleanConstructor

syn match cleanExistentialQuantVariables "E\..\{-}:" display contained contains=cleanTypeVariable nextgroup=cleanConstructor,cleanConstructorName
syn match cleanUniversalQuantVariables "A\..\{-}:" display contained contains=cleanTypeVariable nextgroup=cleanStrict,cleanUnqTypeAttrib,cleanTypeExpresion

syn match cleanTypeDefStart "^\s*::" display skipwhite nextgroup=cleanTypeDefType

let s:CleanTypeDefType = 'syn match cleanTypeDefType "\*\?\s*' . s:TypeName . '" display skipwhite contained contains=cleanUniquenessStar,cleanConstructorName nextgroup=cleanTypeVars'
exec s:CleanTypeDefType

syn match cleanUniquenessStar "\*" contained

let s:CleanTypeDefVars = 'syn match cleanTypeVars "\(' . s:TypeVariable . '\)\?\(\s\+\(' . s:TypeVariable . '\)\+\)*" display skipwhite contained nextgroup=cleanAlgebraicTypeDef,cleanRecordTypeDef,cleanSynonymTypeDef'
exec s:CleanTypeDefVars

syn match cleanRecordTypeDef "=" display skipwhite contained nextgroup=cleanRecordRhs
syn region cleanRecordRhs start="{" end="}" contained fold contains=cleanRecordEntry
syn match cleanRecordEntry ",\?" display skipwhite contained nextgroup=cleanTypeDef

"syn match cleanAlgebraicTypeDef "=" display skipwhite contained nextgroup=cleanExistentialQuantVariables,cleanConstructor
"syn match cleanAlgebraicTypeRhs "cleanConstructorDef"


"let s:CleanConstructorDef = 'syn match cleanConstructorDef "\(E\..*:\)\?\s*(\?\s*' . s:ConstructorName . '\s*)\?\(\s\+' . s:Fix . '\)\?\(\s\+' . s:Prec . '\)\?" display skipwhite contained contains=cleanExistentialQuantVariables,cleanConstructorName,cleanFix,cleanPrec'
"exec s:CleanConstructorDef

"syn match cleanRecordTypeDef "=" display skipwhite contained nextgroup=cleanRecordTypeRhs
"syn match cleanSynonymTypeDef ":==" display skipwhite contained nextgroup=cleanSynonymTypeRhs

syn keyword cleanTodo TODO FIXME XXX contained

syn region cleanComment start="//.*" end="$" display contains=cleanTodo
syn region cleanComment start="/\*" end="\*/" contains=cleanTodo fold

syn region cleanStringDenotation start=/"/ skip=/\\\\\|\\"/ end=/"/ fold

syn keyword cleanBasicType Int Real Char Bool
syn keyword cleanPredefType World File String

syn match cleanIntegerDenotation "[\~+-]\?\<\(\d\+\|0[0-7]\+\|0x[0-9A-Fa-f]\+\)\>" display
syn match cleanRealDenotation "[\~+-]\?\<\d\+\.\d\+\(E[+-\~]\?\d\+\)\?" display
syn keyword cleanBoolDenotation True False
syn match cleanCharDenototation "'\(\\\\\|\\'\|[^']\)'" display " TODO Redundant? Seems to be covered by the CharsDenotation
syn match cleanCharsDenotation  "'\(\\\\\|\\'\|[^']\)\+'" display

let s:CleanModuleName = 'syn match cleanModuleName "' . s:ModuleName . '" contained display'
exec s:CleanModuleName

syn match cleanModule "^\s*\(\(definition\|system\|implementation\)\s\+\)\?module" display skipwhite nextgroup=cleanModuleName

let s:ImplicitImport1 = '^\s*import\(\s\+qualified\)\?'
      "\(\s\+' . s:ModuleName . '\)'
      "\(\s\+as\s\+' . s:ModuleName . '\),\?\)\+'
let s:CleanImplicitImport1 = 'syn match cleanImplicitImport1 "' . s:ImplicitImport1 . '" display nextgroup=cleanImplicitImport2'
exec s:CleanImplicitImport1

"let s:ImplicitImport2 = '\(\(\s\+' . s:ModuleName . '\)\(\s\+as\s\+' . s:ModuleName . '\),\?\s*\)\+'
"let s:CleanImplicitImport2 = 'syn match cleanImplicitImport2 "' . s:ImplicitImport2 . '" display'
"contains=cleanModuleName,cleanComma'
"exec s:CleanImplicitImport2

"let s:ExplicitImport = '^\s*from\s\+' . s:ModuleName . '\s\+\(as\s\+' . s:ModuleName . '\s\+\)import'
"let s:CleanExplicitImport = 'syn match cleanExplicitImport "' . s:ExplicitImport . '" display contains=cleanModuleName nextgroup=cleanImportsList'
"exec s:CleanExplicitImport

" OLD SYNTAX
"let s:syntax = 'syn keyword ' . s:group . ' ' . join(s:list)
"exec s:syntax

command -nargs=+ HiLink hi def link <args>

HiLink cleanImplicitImport1  Keyword
HiLink cleanImplicitImport2  Keyword
HiLink cleanExplicitImport  Keyword
HiLink cleanFix             Keyword
HiLink cleanPrec            Number
HiLink cleanModule          Keyword
HiLink cleanModuleName      Keyword
HiLink cleanTodo            Todo
HiLink cleanBasicType       Type
HiLink cleanPredefType      Type
HiLink cleanExistentialQuantVariables Type
HiLink cleanUniversalQuantVariables Type
HiLink cleanTypeVariable    Type
HiLink cleanComment         Comment
HiLink cleanConditional     Conditional

HiLink cleanLabel           Label
HiLink cleanKeyword         Keyword
HiLink cleanTypeClass       Keyword
HiLink cleanIncludeKeyword  Include
HiLink cleanFFI             Keyword

HiLink cleanModuleSystem    Keyword
HiLink cleanIncludeKeyword  Include

HiLink cleanQualified       Identifier

HiLink cleanCharDenototation     Character
HiLink cleanCharsDenotation      String
HiLink cleanStringDenotation     String
HiLink cleanIntegerDenotation    Number
HiLink cleanRealDenotation       Float
HiLink cleanBoolDenotation       Boolean

HiLink cleanDelimiters      Delimiter

HiLink cleanTypeDefStart    Typedef
HiLink cleanTypeDefType     Typedef
HiLink cleanConstructorName Type
HiLink cleanUniquenessStar  Special
HiLink cleanTypeVars        Type
HiLink cleanRecordTypeDef   Operator
HiLink cleanRecordRhs       Keyword

HiLink cleanTypeDef         Typedef
HiLink cleanFuncTypeDef     Type
HiLink cleanFuncDef         Function
HiLink cleanTypeAnnot       Special
HiLink cleanTypeAnnotSimple Special
HiLink cleanDeriving        Keyword

HiLink cleanOperators       Operator

delcommand HiLink

syntax sync fromstart
setlocal foldmethod=syntax

let b:current_syntax = "clean"




