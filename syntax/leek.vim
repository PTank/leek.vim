" Language: LeekScript
" Maintainer: PTank
" Latest Revision: 18:47:06 14/07/2014

if exists("b:current_syntax")
	finish
endif

setlocal iskeyword+=
syn case ignore

" Syntax definitions

syn keyword LeekScriptTodo contained TODO FIXME XXX NB NOTE
" Conditional
syn keyword LeekScriptConditional	if else
syn keyword LeekScriptConditional	while for do
" Type
syn keyword LeekScriptType var
syn keyword LeekScriptType global

" Builtin
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

" Operator
syn match LeekScriptOperator	display "\%(+\|-\|/\|*\|=\|\^\|&\||\|!\|>\|<\|%\)=\?"

" Boolean
syn keyword LeekScriptBoolean	true false

" function
syn keyword   LeekScriptFunction      function

" Comment
syn region LeekScriptCommentLine start="//" end="$" contains=LeekScriptTodo,@Spell
syn region LeekScriptCommentLineDoc start="//\%(//\@!\|!\)" end="$" contains=LeekScriptTodo,@Spell
syn region LeekScriptCommentBlock matchgroup=LeekScriptCommentBlock start="/\*\%(!\|\*[*/]\@!\)\@!" end="\*/" contains=LeekScriptTodo,LeekScriptCommentBlockNest,@Spell
syn region LeekScriptCommentBlockDoc matchgroup=LeekScriptCommentBlockDoc start="/\*\%(!\|\*[*/]\@!\)" end="\*/" contains=LeekScriptTodo,LeekScriptCommentBlockDocNest,@Spell
syn region LeekScriptCommentBlockNest matchgroup=LeekScriptCommentBlock start="/\*" end="\*/" contains=LeekScriptTodo,LeekScriptCommentBlockNest,@Spell contained transparent
syn region LeekScriptCommentBlockDocNest matchgroup=LeekScriptCommentBlockDoc start="/\*" end="\*/" contains=LeekScriptTodo,LeekScriptCommentBlockDocNest,@Spell contained transparent

" String
syn match LeekScriptEscapeError display contained /\\./
syn match LeekScriptEscape display contained /\\\([nrt0\\'"]\|x\x\{2}\)/
syn match LeekScriptEscapeUnicode display contained /\\\(u\x\{4}\|U\x\{8}\)/
syn match LeekScriptStringContinuation display contained /\\\n\s*/
syn region LeekScriptString start=+b"+ skip=+\\\\\|\\"+ end=+"+ contains=LeekScriptEscape,LeekScriptEscapeError,LeekScriptStringContinuation
syn region LeekScriptString start=+"+ skip=+\\\\\|\\"+ end=+"+ contains=LeekScriptEscape,LeekScriptEscapeUnicode,LeekScriptEscapeError,LeekScriptStringContinuation,@Spell
syn region LeekScriptString start='b\?r\z(#*\)"' end='"\z1' contains=@Spell
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
hi def link LeekScriptCommentLine	Comment
hi def link LeekScriptCommentLineDoc	SpecialComment
hi def link LeekScriptCommentBlock	LeekScriptCommentLine
hi def link LeekScriptCommentBlockDoc	LeekScriptCommentLineDoc
hi def link LeekScriptEscape		Special
hi def link LeekScriptEscapeUnicode	LeekScriptEscape
hi def link LeekScriptEscapeError	Error
hi def link LeekScriptStringContinuation Special
hi def link LeekScriptString		String
