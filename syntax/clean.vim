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
let s:TypeConstructorName   = s:TypeName
let s:TypeVariable          = s:LowerCaseId
let s:UniqueTypeVariable    = s:LowerCaseId
let s:ClassName             = s:CommonName
let s:MemberName            = s:CommonName

" Done
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

syn match cleanStrict '!' display contained

let s:ExistentialQuantVariables = 'E\..\{-}:'
let s:CleanExistentialQuantVariables = 'syn match cleanExistentialQuantVariables "' . s:ExistentialQuantVariables . '" display contained contains=cleanTypeVariable nextgroup=cleanConstructor,cleanConstructorName'
exec s:CleanExistentialQuantVariables

let s:UniversalQuantVariables = 'A\..\{-}:'
let s:CleanUniversalQuantVariables = 'syn match cleanUniversalQuantVariables "' . s:UniversalQuantVariables . '" display contained contains=cleanTypeVariable nextgroup=cleanStrict,cleanUnqTypeAttrib,cleanTypeExpresion'
exec s:CleanUniversalQuantVariables

let s:UniqTypeAttrib = '\*\|\.\|' . s:UniqueTypeVariable . ':'
let s:CleanUniqTypeAttrib = 'syn match cleanUniqTypeAttrib "' . s:UniqTypeAttrib . '" contained display skipwhite'
exec s:CleanUniqTypeAttrib

let s:Strict = '!'

let s:CleanFieldName = 'syn match cleanFieldName "\<' . s:FieldName . '\>" contained display skipwhite'
exec s:CleanFieldName

" In progress

let s:Type = '' 
let s:PredefinedType = ''
let s:PredefinedTypeConstructor = ''

let s:TypeExpression = s:TypeVariable . '\|' . s:TypeConstructorName . '\|(' . s:Type . ')\|' . s:PredefinedType . '\|' . s:PredefinedTypeConstructor
let s:CleanTypeExpression = 'syn match cleanTypeExpression "' . s:TypeExpression . '" contained display skipwhite contains=cleanTypeVariable,cleanTypeConstructorName,cleanType,cleanPredefinedType,cleanPredefinedTypeConstructor'
exec s:CleanTypeExpression

let s:BrackType = '\(' . s:UniversalQuantVariables . '\)\?\(' . s:Strict . '\)\?\(' . s:UniqTypeAttrib . '\)\?' . s:TypeExpression
let s:CleanBrackType = 'syn match cleanBrackType "' . s:BrackType . '" contained display skipwhite'
exec s:CleanBrackType



let s:CleanUnqTypeAttrib = 'syn match cleanUnqTypeAttrib "\*\|\.\|' . s:UniqueTypeVariable . ':" display contained'
exec s:CleanUnqTypeAttrib

let s:Constructor = '(\?\s*' . s:ConstructorName . '\s*)\?'
let s:CleanConstructor = 'syn match cleanConstructor "' . s:Constructor . '" display skipwhite contains=cleanConstructorName contained nextgroup=cleanFix,cleanPrec,cleanBrackType'
exec s:CleanConstructor


let s:TypeDefStart = '^\s*::\s*\*\?' . s:TypeName . '\(\s\+' . s:TypeVariable . '\)*\s*\(:=\)\?='
let s:CleanTypeDefStart = 'syn match cleanTypeDefStart "' . s:TypeDefStart . '" display skipwhite contains=cleanUniquenessStar,cleanConstructorName,cleanTypeVariable,cleanTypeDefEqs nextgroup=cleanRecordTypeDef,cleanAlgebraicTypeDef,cleanSynonymTypeDef'
exec s:CleanTypeDefStart

syn match cleanTypeDefEqs "\(:=\)\?=" display contained

"syn match cleanTypeDefStart "^\s*::" display skipwhite nextgroup=cleanTypeDefType

"let s:CleanTypeDefType = 'syn match cleanTypeDefType "\*\?' . s:TypeName . '" display skipwhite contained contains=cleanUniquenessStar,cleanConstructorName nextgroup=cleanTypeDefVars,cleanRecordTypeDef,cleanAlgebraicTypeDef'
"exec s:CleanTypeDefType

syn match cleanUniquenessStar "\*" contained

let s:RecordTypeDefRhs = '\(' . s:ExistentialQuantVariables . '\)\?\(' . s:Strict . '\)\?\s*{.*}'
let s:CleanRecordTypeDefRhs = 'syn match cleanRecordTypeDef "' . s:RecordTypeDefRhs . '" contains=cleanFieldName,cleanType contained fold contains=cleanRecordEntry'
exec s:CleanRecordTypeDefRhs

syn match cleanRecordEntry ",\?" display skipwhite contained nextgroup=cleanTypeDef


"let s:CleanConstructorDef = 'syn match cleanConstructorDef "\(E\..*:\)\?\s*(\?\s*' . s:ConstructorName . '\s*)\?\(\s\+' . s:Fix . '\)\?\(\s\+' . s:Prec . '\)\?" display skipwhite contained contains=cleanExistentialQuantVariables,cleanConstructorName,cleanFix,cleanPrec'
"exec s:CleanConstructorDef


syn keyword cleanTodo TODO FIXME XXX contained

syn region cleanComment start="//.*" end="$" display contains=cleanTodo
syn region cleanComment start="/\*" end="\*/" contains=cleanTodo fold

syn region cleanStringDenotation start=/"/ skip=/\\\\\|\\"/ end=/"/ fold

syn keyword cleanBasicType Int Real Char Bool
syn keyword cleanPredefType World File String

syn match cleanIntegerDenotation "[\~+-]\?\<\(\d\+\|0[0-7]\+\|0x[0-9A-Fa-f]\+\)\>" display
syn match cleanRealDenotation "[\~+-]\?\<\d\+\.\d\+\(E[+-\~]\?\d\+\)\?" display
syn keyword cleanBoolDenotation True False
syn match cleanCharDenototation "'\(\\\\\|\\'\|[^']\)'" display
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


" Done
HiLink cleanFix                        Keyword
HiLink cleanBasicType                  Type
HiLink cleanPredefType                 Type
HiLink cleanComment                    Comment
HiLink cleanTodo                       Todo
HiLink cleanCharDenototation           Character
HiLink cleanCharsDenotation            String
HiLink cleanStringDenotation           String
HiLink cleanIntegerDenotation          Number
HiLink cleanRealDenotation             Float
HiLink cleanBoolDenotation             Boolean
HiLink cleanExistentialQuantVariables  Keyword
HiLink cleanUniversalQuantVariables    Keyword
HiLink cleanTypeDefEqs                 Typedef
HiLink cleanTypeVariable               Identifier
HiLink cleanBrackType                  Special
HiLink cleanUniqTypeAttrib             Special
HiLink cleanRecordTypeDef              Special
HiLink cleanFieldName                  Identifier

" In progress
HiLink cleanTypeDefStart Type
HiLink cleanImplicitImport1  Keyword
HiLink cleanImplicitImport2  Keyword
HiLink cleanExplicitImport  Keyword
HiLink cleanPrec            Number
HiLink cleanModule          Keyword
HiLink cleanModuleName      Keyword
HiLink cleanConditional     Conditional

HiLink cleanLabel           Label
HiLink cleanKeyword         Keyword
HiLink cleanTypeClass       Keyword
HiLink cleanIncludeKeyword  Include
HiLink cleanFFI             Keyword

HiLink cleanModuleSystem    Keyword
HiLink cleanIncludeKeyword  Include

HiLink cleanQualified       Identifier


HiLink cleanDelimiters      Delimiter

HiLink cleanTypeDefStart    Typedef
HiLink cleanTypeDefType     Typedef
HiLink cleanConstructorName Type
HiLink cleanUniquenessStar  Special
HiLink cleanRecordTypeRhs    Keyword

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




