
function s:PushTagStack()
	let pos = getpos(".")
    let pos[0] = bufnr()
	let newtag = [{'tagname' : 'pushed-tag', 'from' : pos}]
	call settagstack(winnr(), {'items' : newtag}, 't')
endfunction

nmap <s-t> :call <SID>PushTagStack()<CR>

function s:Jump(JumpEntry) abort
    exec "buffer " .. a:JumpEntry.bufnr
    call setcursorcharpos(a:JumpEntry.lnum,a:JumpEntry.col)
endfunction
"direction "u" or "d"
function s:MoveFile(InDirection) abort
    let [Jumps,Index] = getjumplist()
    let Direction = -1
    if(a:InDirection == "d")
        let Direction = 1
    endif
    let CurrentBuffer = bufnr()
    let BufferList = []
    let VisitedBuffers = {}
    let i = len(Jumps)-1
    let Position = 0
    while(i >= 0)
        if(!has_key(VisitedBuffers,Jumps[i].bufnr))
            let BufferList += [Jumps[i]]
            let VisitedBuffers[Jumps[i].bufnr] = v:true
            if(Jumps[i].bufnr == CurrentBuffer)
                let Position = len(BufferList)-1
            endif
        endif
        let i -= 1
    endwhile
    let Position =  len(BufferList)-1-Position
    call reverse(BufferList)
    echo  Position
    echo BufferList
    if(Position + Direction >= 0 && Position + Direction < len(BufferList))
        call s:Jump(BufferList[Position+Direction])
    endif
endfunction

nnoremap <space>k :call <SID>MoveFile("u")<CR>
nnoremap <space>j :call <SID>MoveFile("d")<CR>
