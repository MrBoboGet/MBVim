"test ( asd asd ads { asdasd (asdasd ) asd } )

"if exists("s:mb_motions")
"    finish
"endif
"let s:mb_motions = 1

"<c-o> behaves inco
function! s:PasteReturn() abort
    let RegisterValue = nr2char(getchar())
    let ReturnValue = '"' .. RegisterValue
    "echo col(".")
    if col(".") + 1 != col("$")
        let ReturnValue ..= "p"
    else
        let ReturnValue ..= "P"
    endif
    return ReturnValue
endfunction

function! ListLess(LeftList,RightList) abort
    let ReturnValue = v:false
    let i = 0
    while(i < len(a:LeftList))
        if(a:LeftList[i] < a:RightList[i])
            let ReturnValue = v:true
            break
        elseif(a:LeftList[i] > a:RightList[i])
            let ReturnValue = v:false
            break
        endif
        let i += 1
    endwhile
    return(ReturnValue)
endfunction

function! GetPatternCount(Pattern,BeginPos,EndPos) abort
    let OriginalCursorPosition = getpos(".")
    call setpos(".",[0,a:BeginPos[0],a:BeginPos[1],0])
    let ReturnValue = 0
    let SearchFlags = 'W'
    if(ListLess(a:EndPos,a:BeginPos))
        let SearchFlags .= 'b'
    endif
    while(v:true)
        let Result = search(a:Pattern,SearchFlags)
        if(Result)
            if(ListLess(a:EndPos,a:BeginPos))
                let Result = ListLess(a:EndPos,getpos(".")[1:2])
            else
                let Result = ListLess(getpos(".")[1:2],a:EndPos)
            endif
            if(!Result)
                break
            endif
        else
            break
        endif
        let ReturnValue += 1
    endwhile
    call setpos(".",OriginalCursorPosition)
    return ReturnValue

endfunction

function! GetNestingDepth(StartPattern,EndPattern,BeginPos,EndPos) abort
    let StartCount = GetPatternCount(a:StartPattern,a:BeginPos,a:EndPos)
    let EndCount = GetPatternCount(a:EndPattern,a:BeginPos,a:EndPos)
    return StartCount-EndCount
endfunction

function! SetVisualSelection(PositionList) abort
    if(ListLess(a:PositionList[0],getpos("'<")[1:2]))
        call setpos("'<",[0,a:PositionList[0][0],a:PositionList[0][1],0])
        call setpos("'>",[0,a:PositionList[1][0],a:PositionList[1][1],0])
    else
        call setpos("'>",[0,a:PositionList[1][0],a:PositionList[1][1],0])
        call setpos("'<",[0,a:PositionList[0][0],a:PositionList[0][1],0])
    endif
    normal gv
endfunction

function! ShrinkSelection(PositionList,ShrinkSize = 1) abort
    let ReturnValue = copy(a:PositionList)
    let ReturnValue[0][1] += a:ShrinkSize
    let ReturnValue[1][1] -= a:ShrinkSize
    return ReturnValue
endfunction


" asdjkasjkldajkls (asdad,asdasdas,(asdsadasd,asdasda),adasd(asdasd,asdasd))
"assumes that cursor is at the position to examine
function! GetArgumentPosition(Inner="i")
    let ReturnValue = []
    eval ReturnValue->add(searchpos('(\|,',"Wcbn"))
    eval ReturnValue->add(searchpos(')\|,',"Wcn",0,0, {-> GetNestingDepth("(",")",getpos(".")[1:2],ReturnValue[0]) != 0 } ))
    if(a:Inner == "i")
        let ReturnValue[0][1] += 1
        let ReturnValue[1][1] -= 1
    elseif (a:Inner == "a")
        let LLine = getline(ReturnValue[0][0])
        let RLine = getline(ReturnValue[1][0])
        let LChar = LLine[ReturnValue[0][1]-1]
        let RChar = RLine[ReturnValue[1][1]-1]
        if(LChar == RChar && LChar == ",")
            let ReturnValue[0][1] += 1
        endif
        if(LChar == '(')
            let ReturnValue[0][1] += 1
        endif
        if(RChar == ")")
            let ReturnValue[1][1] -= 1
        endif
    endif
    return(ReturnValue)
endfunction

"asdasdasd  (asdasd,asdad,asdasd(asdasd,(asdasd,adasd)))
"assdasda dsa()
function! MakeTextObject(ObjectName,FunctionString) abort
    exec "vnoremap " .. a:ObjectName .. " :<c-u>call SetVisualSelection(" .. a:FunctionString .. ")<CR>"
    exec "onoremap " .. a:ObjectName .. " :<c-u>call SetVisualSelection(" .. a:FunctionString .. ")<CR>"
endfunction

function! MakeInnerOuter(ObjectName,FunctionString) abort
    call MakeTextObject("a" .. a:ObjectName,a:FunctionString .. '("a")')
    call MakeTextObject("i" .. a:ObjectName,a:FunctionString .. '("i")')
endfunction

"test(123123,"assdasd",asdsasdasds)
" $asdasdasdasd$



vnoremap _ ^og_
onoremap _ <Cmd>normal! v^og_<CR>

call MakeInnerOuter("a","GetArgumentPosition")

inoremap <silent><expr> <C-v> "<c-o>" .. <SID>PasteReturn()

inoremap <c-e> <end>
inoremap <c-a> <Home>
inoremap <c-k> <Up>
inoremap <c-j> <Down>

nnoremap g) ])
nnoremap g( [(
nnoremap g{ [{
nnoremap g} ]}

vnoremap g) ])
onoremap g) :normal g)<CR>
onoremap ag) :normal vg)<CR>

vnoremap g( [(
onoremap g( :normal g(l<CR>
onoremap ag( :normal vg(<CR>

vnoremap g} ]}
onoremap g} :normal g}<CR>
nnoremap ag} :normal vg}<CR>

vnoremap g{ [{
onoremap g{ :normal g{l<CR>
onoremap ag{ :normal vg{<CR>
