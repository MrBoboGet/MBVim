"hacky, but vim script is basically fully concurrent
let s:MBOpFuncString = ""

function! MBExecuteOperator_Normal(Type = '') abort
    if(a:Type == '')
        set opfunc=MBExecuteOperator_Normal
        return 'g@'
    endif
    call s:MBOpFuncString(getpos("'["),getpos("']"))
endfunction
    
function! MBExecuteOperator(FuncName,Mode) abort
    let s:MBOpFuncString = funcref(a:FuncName)
    if a:Mode == "n"
        return MBExecuteOperator_Normal()
    elseif a:Mode == "v"
        call s:MBOpFuncString(getpos("'<"),getpos("'>"))
    else
        return
    endif
endfunction

function! MBCreateOperator(OperatorString,FuncString) abort
    let NString = "nnoremap <expr> " .. a:OperatorString .. ' MBExecuteOperator("' .. a:FuncString .. '","n")'
    let VString = "vnoremap " .. a:OperatorString .. ' :call MBExecuteOperator("' .. a:FuncString .. '","v")<CR>'
    execute NString
    execute VString
endfunction

function! s:Quote(StartPos,EndPos) abort
    call cursor(a:StartPos[1],a:StartPos[2])
    normal i"
    call cursor(a:EndPos[1],a:EndPos[2]+1)
    normal a"
endfunction
function! s:Replace(StartPos,EndPos) abort
    let UsedReg = v:register
    let UsedRegContent = getreg(UsedReg)
    call cursor(a:StartPos[1],a:StartPos[2])
    normal v
    call cursor(a:EndPos[1],a:EndPos[2])
    exec 'normal "' .. UsedReg .. 'p'
    call setreg(UsedReg,UsedRegContent)
endfunction
call MBCreateOperator("Q","s:Quote")
call MBCreateOperator("R","s:Replace")
