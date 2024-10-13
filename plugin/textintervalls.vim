"asd asd asd asd 

let g:RegisteredIntervalls = {}

function! s:EvalInputtedIntervalls()
    let Input = getcharstr()
    return g:RegisteredIntervalls[Input]()
endfunction


"search test ( asdad asd asd asd d)
"
function! g:ParentIntervalls()
    let OriginalPos = getpos(".")
    normal f(
    let L = getpos(".")
    normal lg)
    let R = getpos(".")
    let ReturnValue = [ [ [L[1],L[2]], [L[1],L[2]]],  [ [R[1],R[2]], [R[1],R[2]]] ]
    call setpos(".",OriginalPos) 
    return ReturnValue
endfunction

function! s:PositionLess(Lhs,Rhs) abort
    if(a:Lhs[0] <= a:Rhs[0])
        return v:true
    elseif (a:Lhs[0] == a:Rhs[0] && a:Lhs[1] <= a:Rhs[1])
        return v:true
    endif
    return v:false
endfunction

function! g:IntervallLess(Lhs,Rhs) abort
    return s:PositionLess(a:Lhs[0],a:Rhs[0])
endfunction

"assumes that Lhs < Rhs
function! s:IntervallOverlaps(Lhs,Rhs) abort
    return s:PositionLess(a:Rhs[0],a:Lhs[1]) && s:PositionLess(a:Lhs[0],a:Rhs[0])
endfunction

function! s:CombineIntervalls(Lhs,Rhs) abort
    let ReturnValue = []
    let LhsIt = 0
    let RhsIt = 0
    while(LhsIt < len(a:Lhs) && RhsIt < len(a:Rhs))
        let CurrentLhs = a:Lhs[LhsIt]
        let CurrentRhs = a:Rhs[RhsIt]
        if(g:IntervallLess(CurrentLhs,CurrentRhs))
            if(s:IntervallOverlaps(CurrentLhs,CurrentRhs))
                let ReturnValue += [ [CurrentLhs[0],CurrentRhs[1]] ]
                let LhsIt += 1
                let RhsIt += 1
            else
                let ReturnValue += [ CurrentLhs ]
                let LhsIt += 1
            endif
        elseif(g:IntervallLess(CurrentRhs,CurrentLhs))
            if(s:IntervallOverlaps(CurrentRhs,CurrentLhs))
                let ReturnValue += [ [CurrentRhs[0],CurrentLhs[1]] ]
                let LhsIt += 1
                let RhsIt += 1
            else
                let ReturnValue += [ CurrentRhs ]
                let RhsIt += 1
            endif
        endif
    endwhile
    while(LhsIt < len(a:Lhs))
        let ReturnValue += [ a:Lhs[LhsIt] ]
        let LhsIt += 1
    endwhile
    while(RhsIt < len(a:Rhs))
        let ReturnValue += [ a:Rhs[RhsIt] ]
        let RhsIt += 1
    endwhile
    return ReturnValue
endfunction
"asdad = asdsad asdsadasd(".")
function! g:GetFuncIntervall() abort
    let OriginalPos = getpos(".")
    let ParenthesisIntervall = g:ParentIntervalls()
    normal! f(
    let FuncEnd = getpos(".")
    normal! B
    let FuncStart = getpos(".")
    let FuncNameIntervall = [  [FuncStart[1],FuncStart[2]],[FuncEnd[1],FuncEnd[2]]]
    let ReturnValue = s:CombineIntervalls( [FuncNameIntervall],ParenthesisIntervall)
    call setpos(".",OriginalPos)
    return ReturnValue
endfunction


let g:RegisteredIntervalls["("] = function("g:ParentIntervalls")
let g:RegisteredIntervalls["f"] = function("g:GetFuncIntervall")

"Intervalls are assumed to never overlap, and be sorted
function! s:RemoveIntervallHandler() abort
    let Intervalls = s:EvalInputtedIntervalls()
    let i = 0
    let CurrentLineOffset = 0
    let CurrentCharacterOffset = 0
    let PrevLineNum = -1
    while i < len(Intervalls)
        let CurrentIntervall = Intervalls[i]
        if CurrentIntervall[0][0] == PrevLineNum
            let CurrentIntervall[0][1] -= CurrentCharacterOffset
            if(CurrentIntervall[1][0] == PrevLineNum)
                let CurrentIntervall[1][1] -= CurrentCharacterOffset
            endif
        else 
            let CurrentCharacterOffset = 0
        endif
        let CurrentLineNum = CurrentIntervall[1][0]
        let CurrentIntervall[0][0] += CurrentLineOffset
        let CurrentIntervall[1][0] += CurrentLineOffset

        call SetVisualSelection(CurrentIntervall)
        normal x

        let CurrentLineOffset += CurrentIntervall[1][0] - CurrentIntervall[0][0]
        if(CurrentLineOffset > 0)
            let CurrentCharacterOffset += CurrentIntervall[1][1]
        else 
            let CurrentCharacterOffset += (CurrentIntervall[1][1]-CurrentIntervall[0][1])+1
        endif

        let PrevLineNum = CurrentLineNum
        let i += 1
    endwhile
endfunction

nnoremap s :call <SID>RemoveIntervallHandler()<CR>
"let g:RegisteredIntervalls["test"] = function(expand('<SID>') .. "TestFunc")
"
"" asdasd sad s d ( asd asd ad  asd asda das)
