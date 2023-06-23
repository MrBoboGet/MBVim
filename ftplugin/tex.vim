
function! s:GetDollarPositions() abort
    let EndPos = searchpos('\$','Wnz')
    let StartPos = searchpos('\$','Wbn')
    return [StartPos,EndPos]
endfunction
function! SetDollarPosition(PositionType) abort
    let DollarPositions = s:GetDollarPositions()
    "echo DollarPositions[0]
    "echo DollarPositions[1]
     "return
    if((DollarPositions[0][0] == 0 && DollarPositions[0][1] == 0) || (DollarPositions[1][0] == 0 && DollarPositions[1][1] == 0))
        return
    endif
    if(a:PositionType == "i")
        let DollarPositions[0][1] += 1
        let DollarPositions[1][1] -= 1
    endif
    call setcharpos("'<",[0,DollarPositions[0][0],DollarPositions[0][1],0])
    call setcharpos("'>",[0,DollarPositions[1][0],DollarPositions[1][1],0])
    normal gv
endfunction
" TestTest Test $ asdasdsad $
"
" Bruh *vad* $ ase dasd asd asd asd $
vnoremap <buffer> i$ :<C-u>call SetDollarPosition("i")<CR>
vnoremap <buffer> a$ :<C-u>call SetDollarPosition("a")<CR>
onoremap <buffer> i$ :normal vi$<CR>
onoremap <buffer> a$ :normal va$<CR>
