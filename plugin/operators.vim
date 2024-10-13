"hacky, but vim script is basically fully concurrent
let s:MBOpFuncString = ""

function! MBExecuteOperator_Normal(Type = '') abort
    if(a:Type == '')
        set opfunc=MBExecuteOperator_Normal
        return 'g@'
    endif
    call s:MBOpFuncString(getpos("'["),getpos("']"))
endfunction
    
function! MBExecuteOperator(FuncName,Mode) abort range
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

function! s:Source(StartPos,EndPos) abort
    let Lines = getline(a:StartPos[1],a:EndPos[1])
    let TotalText = ""
    if(Lines->len() > 1)
        let Lines[0] = Lines[0]->strpart(a:StartPos[2]-1)
        let Lines[-1] = Lines[-1]->strpart(0,a:EndPos[2])
    else
        let Lines[0] = Lines[0]->strpart(a:StartPos[2]-1,a:EndPos[2]-a:StartPos[2]+1)
    endif
    if v:true
        for Line in Lines
            let TotalText ..= Line .. "\n"
        endfor
    endif
    "Find the terminal in the current window
    let Windows = map(tabpagenr()->gettabinfo()[0].windows,{i,x -> getwininfo(x)[0] })
    for Window in Windows
        if(Window.terminal)
            let Buf = Window.bufnr
            call term_sendkeys(Buf,TotalText)
            break
        endif
    endfor
endfunction

call MBCreateOperator("Q","s:Quote")
call MBCreateOperator("R","s:Replace")
call MBCreateOperator("S","s:Source")
