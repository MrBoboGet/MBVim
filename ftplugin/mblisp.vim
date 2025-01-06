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

function! DisplayBuffer()
    let term_buf = GetTabTerminal()
    echo "awooga"
    if term_buf != v:null
        call term_sendkeys(term_buf,$"MBLisp -m TML.TMLDisplay {expand("%:p:S") }\<Return>")
        let buf_windows = win_findbuf(term_buf)
        if len(buf_windows) > 0
            call win_gotoid(buf_windows[0])
        endif
    endif
endfunction

nnoremap <buffer> <space>v :call DisplayBuffer()<CR>
