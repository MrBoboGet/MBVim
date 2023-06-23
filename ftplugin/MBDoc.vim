if exists("b:MBDoc_ftplugin")
    finish
endif
let b:MBDoc_ftplugin=1

function! s:MBReference_Create(StartPos,EndPos) abort
    "let StartPos = getpos("'[")
    "let EndPos = getpos("']")
    "echo EndPos
    "return
    call cursor(a:EndPos[1],a:EndPos[2])
    normal a](
    let NewEndPos = getcurpos()
    call cursor(a:StartPos[1],a:StartPos[2])
    normal i@[
    call cursor(NewEndPos[1],NewEndPos[2]+2)
endfunction

function! MBReference_Normal(Type = '') abort
    if a:Type == ''
        set opfunc=MBReference_Normal
        return 'g@'
    endif
    call s:MBReference_Create(getpos("'["),getpos("']"))
endfunction

function! s:MBReference_Visual() abort
    call s:MBReference_Create(getpos("'<"),getpos("'>"))
endfunction

nnoremap <buffer><expr> gr MBReference_Normal()
vnoremap <buffer> gr :call <SID>MBReference_Visual()<CR>
