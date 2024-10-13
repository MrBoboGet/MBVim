set iskeyword+=-
set autoindent
"assumes that GetNestingDepth is defined...
function! LispIndent() abort
    let line = getline(v:lnum - 1)
    let lineLength = line->len()
    let nestDepth = GetNestingDepth("(",")",[v:lnum - 1,0],[v:lnum - 1,lineLength])
    if lineLength > 0 && line[lineLength-1] == ")"
        let nestDepth -= 1
    endif
    if (nestDepth == 0)
        return -1
    else
        return indent(v:lnum)+4
    endif
endfunction
setl indentexpr=LispIndent()
