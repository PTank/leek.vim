" Language: LeekScript
" Maintainer: PTank
" Latest Revision: 18:47:06 14/07/2014

if exists("b:current_syntax")
	finish
endif

setlocal iskeyword+=
syn case ignore

" Syntax definitions

syn keyword LeekScriptConditional	if else
syn keyword LeekScriptConditional	while for

syn keyword LeekScriptType var

syn keyword LeekScriptKeyword	break
syn keyword LeekScriptKeyword	continue
syn keyword LeekScriptKeyword	return


syn match LeekScriptFunction	display "function\([.+]\)"

" Number literals
syn match LeekScriptDecNumber display "\<[0-9][0-9_]*\%([iu]\%(8\|16\|32\|64\)\=\)\="
syn match LeekScriptHexNumber display "\<0x[a-fA-F0-9_]\+\%([iu]\%(8\|16\|32\|64\)\=\)\="
syn match LeekScriptOctNumber display "\<0o[0-7_]\+\%([iu]\%(8\|16\|32\|64\)\=\)\="
syn match LeekScriptBinNumber display "\<0b[01_]\+\%([iu]\%(8\|16\|32\|64\)\=\)\="

syn match LeekScriptFloat display "\<[0-9][0-9_]*\.\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\@!"

syn match LeekScriptFloat display "\<[0-9][0-9_]*\%(\.[0-9][0-9_]*\)\%([eE][+-]\=[0-9_]\+\)\=\(f32\|f64\)\="
syn match LeekScriptFloat display "\<[0-9][0-9_]*\%(\.[0-9][0-9_]*\)\=\%([eE][+-]\=[0-9_]\+\)\(f32\|f64\)\="
syn match LeekScriptFloat display "\<[0-9][0-9_]*\%(\.[0-9][0-9_]*\)\=\%([eE][+-]\=[0-9_]\+\)\=\(f32\|f64\)"

syn match LeekScriptOperator	display "\%(+\|-\|/\|*\|=\|\^\|&\||\|!\|>\|<\|%\)=\?"

syn keyword LeekScriptBoolean	true false

" function

syn match   LeekScriptFunction      "\<function\>"
syn region  LeekScriptFunctionFold  start="\<function\>.*[^};]$" end="^\z1}.*$" transparent fold keepend
syn sync match LeekScriptSync       grouphere LeekScriptFunctionFold "\<function\>"
syn sync match LeekScriptSync       grouphere NONE "^}"

setlocal foldmethod=syntax
setlocal foldtext=getline(v:foldstart)


" higlist

let b:current_syntax = "LeekScript"

hi def link LeekScriptKeyword 		Statement
hi def link LeekScriptConditional	Conditional
hi def link LeekScriptType		Type
hi def link LeekScriptOperator		Operator
hi def link LeekScriptBoolean		Boolean
hi def link LeekScriptDecNumber		Number
hi def link LeekScriptHexNumber		Number
hi def link LeekScriptOctNumber		Number
hi def link LeekScriptBinNumber		Number
hi def link LeekScriptFloat		Float
hi def link LeekScriptFunction		Function
