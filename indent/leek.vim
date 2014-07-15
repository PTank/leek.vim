
if exists("b:did_indent")
	finish
endif
let b:did_indent = 1

setlocal cindent
setlocal cinoptions=L0,(0,Ws,JN,j1
setlocal cinkeys=0{,0},!^F,o,O,0[,0]
" Don't think cinwords will actually do anything at all... never mind
setlocal cinwords=for,if,else,while,function

" Some preliminary settings
setlocal nolisp	" Make sure lisp indenting doesn't supersede us
setlocal autoindent	" indentexpr isn't much help otherwise
" Also do indentkeys, otherwise # gets shoved to column 0 :-/
setlocal indentkeys=0{,0},!^F,o,O,0[,0]

setlocal indentexpr=GetLeekIndent(v:lnum)

" Only define the function once.
if exists("*GetLeekIndent")
	finish
endif

" Come here when loading the script the first time.

function! s:get_line_trimmed(lnum)
	" Get the line and remove a trailing comment.
	" Use syntax highlighting attributes when possible.
	" NOTE: this is not accurate; /* */ or a line continuation could trick it
	let line = getline(a:lnum)
	let line_len = strlen(line)
	if has('syntax_items')
		" If the last character in the line is a comment, do a binary search for
		" the start of the comment. synID() is slow, a linear search would take
		" too long on a long line.
		if synIDattr(synID(a:lnum, line_len, 1), "name") =~ 'Comment\|Todo'
			let min = 1
			let max = line_len
			while min < max
				let col = (min + max) / 2
				if synIDattr(synID(a:lnum, col, 1), "name") =~ 'Comment\|Todo'
					let max = col
				else
					let min = col + 1
				endif
			endwhile
			let line = strpart(line, 0, min - 1)
		endif
		return substitute(line, "\s*$", "", "")
	else
		" Sorry, this is not complete, nor fully correct (e.g. string "//").
		" Such is life.
		return substitute(line, "\s*//.*$", "", "")
	endif
endfunction

function! s:is_string_comment(lnum, col)
	if has('syntax_items')
		for id in synstack(a:lnum, a:col)
			let synname = synIDattr(id, "name")
			if synname == "LeekScriptString" || synname =~ "^LeekScriptComment"
				return 1
			endif
		endfor
	else
		" without syntax, let's not even try
		return 0
	endif
endfunction

function GetLeekIndent(lnum)

	" Starting assumption: cindent (called at the end) will do it right
	" normally. We just want to fix up a few cases.

	let line = getline(a:lnum)

	if has('syntax_items')
		let synname = synIDattr(synID(a:lnum, 1, 1), "name")
		if synname == "LeekScriptString"
			" If the start of the line is in a string, don't change the indent
			return -1
		elseif synname =~ '\(Comment\|Todo\)'
					\ && line !~ '^\s*/\*' " not /* opening line
			if synname =~ "CommentML" " multi-line
				if line !~ '^\s*\*' && getline(a:lnum - 1) =~ '^\s*/\*'
					" This is (hopefully) the line after a /*, and it has no
					" leader, so the correct indentation is that of the
					" previous line.
					return GetLeekIndent(a:lnum - 1)
				endif
			endif

			return cindent(a:lnum)
		endif
	endif



	let prevlinenum = prevnonblank(a:lnum - 1)
	let prevline = s:get_line_trimmed(prevlinenum)
	while prevlinenum > 1 && prevline !~ '[^[:blank:]]'
		let prevlinenum = prevnonblank(prevlinenum - 1)
		let prevline = s:get_line_trimmed(prevlinenum)
	endwhile
	if prevline[len(prevline) - 1] == ","
				\ && s:get_line_trimmed(a:lnum) !~ '^\s*[\[\]{}]'
				\ && prevline !~ '^\s*fn\s'
				\ && prevline !~ '([^()]\+,$'

		return GetLeekIndent(a:lnum - 1)
	endif



	call cursor(a:lnum, 1)
	if searchpair('{\|(', '', '}\|)', 'nbW',
				\ 's:is_string_comment(line("."), col("."))') == 0
		if searchpair('\[', '', '\]', 'nbW',
					\ 's:is_string_comment(line("."), col("."))') == 0
			" Global scope, should be zero
			return 0
		else
			" At the module scope, inside square brackets only
			"if getline(a:lnum)[0] == ']' || search('\[', '', '\]', 'nW') == a:lnum
			if line =~ "^\\s*]"
				" It's the closing line, dedent it
				return 0
			else
				return &shiftwidth
			endif
		endif
	endif

	" Fall back on cindent, which does it mostly right
	return cindent(a:lnum)
endfunction
