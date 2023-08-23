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
    normal f)
    let R = getpos(".")
    let ReturnValue = [ [ [L[1],L[2]], [L[1],L[2]]],  [ [R[1],R[2]], [R[1],R[2]]] ]
    call setpos(".",OriginalPos) 
    return ReturnValue
endfunction


let g:RegisteredIntervalls["("] = function("g:ParentIntervalls")

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
