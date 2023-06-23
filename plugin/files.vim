
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
    let i = 0
    let Position = 0
    while(i < len(Jumps))
        if(!has_key(VisitedBuffers,Jumps[i].bufnr))
            let BufferList += [Jumps[i]]
            let VisitedBuffers[Jumps[i].bufnr] = v:true
            if(Jumps[i].bufnr == CurrentBuffer)
                let Position = len(BufferList)-1
            endif
        endif
        let i += 1
    endwhile
    if(Position + Direction > 0 && Position + Direction < len(BufferList))
        call s:Jump(BufferList[Position+Direction])
    endif
endfunction

nnoremap <space>k :call <SID>MoveFile("u")<CR>
nnoremap <space>j :call <SID>MoveFile("d")<CR>
