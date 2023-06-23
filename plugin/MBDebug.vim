nmap <c-s> <plug>VimspectorStepInto
nmap <c-n> <plug>VimspectorStepOver
nmap <c-f> <plug>VimspectorStepOut
nmap <c-b> <plug>VimspectorToggleBreakpoint
nmap <c-c> <plug>VimspectorContinue

function! s:startDebug()
    set signcolumn=yes
    "VimspectorMkSession 
    "call vimspector#ClearBreakpoints()
    "VimspectorLoadSession  
    call vimspector#Launch()
endfunction

function! s:stopDebug()
    set signcolumn=auto
    call vimspector#Stop()
endfunction

nmap <space>d :call <SID>startDebug()<CR>
nmap <space>D :VimspectorReset<CR>
nmap <c-x> :call <SID>stopDebug()<CR>
nmap E <plug>VimspectorBalloonEval
nmap <c-u> <plug>VimspectorUpFrame
nmap <c-d> <plug>VimspectorDownFrame



function s:ToggleCurrentService()
    let Services = CocAction('services')
    let ServiceToToggle = ""
    let CurrentFiletype = &filetype
    for Service in Services
        if ServiceToToggle != ""
            break
        endif
        for Filetype in Service.languageIds
            if(Filetype == CurrentFiletype)
                let ServiceToToggle =  Service.id
                break
            endif
        endfor
    endfor
    if(ServiceToToggle != "")
        call CocAction('toggleService',ServiceToToggle)
    endif
endfunction
command! MBToggleService call <SID>ToggleCurrentService()

highlight PMenu ctermbg=Green 

function s:FixedExePath(ExeToCheck)
    let Paths = []
    if(has("win32"))
        let Paths = split($PATH,";")
    else
        let Paths = split($PATH,":")
    endif

    for Path in Paths
        let Path = Path .. "/"
        if(getfsize(Path .. a:ExeToCheck) != -1)
            return Path .. a:ExeToCheck
        elseif(getfsize(Path .. a:ExeToCheck .. ".exe") != -1)
            return Path .. a:ExeToCheck
        endif
    endfor
    return("")

endfunction


function s:DebugProcess(...) abort
    let ExtraArguments = a:000
    let ProgramPath = s:FixedExePath(ExtraArguments[0])
    if(ProgramPath == "")
        echo "No executable with name '" .. ExtraArguments[0] .. "' found"
        return
    endif
    let ProgramArguments = ExtraArguments[1:a:0]
    call vimspector#LaunchWithConfigurations(#{
                \    Launch: 
                \    #{
                \      adapter: "vscode-cpptools",
                \      filetypes: [ "cpp", "c", "objc", "rust" ], 
                \      configuration: 
                \      #{
                \        request: "launch",
                \        program: ProgramPath,
                \        args: ProgramArguments,
                \        cwd: getcwd(),
                \        environment: [],
                \        stopOnEntry: v:true,
                \        stopAtEntry: v:true,
                \        externalConsole: v:false,
                \        MIMode: "gdb",
                \        setupCommands: [
                \          #{
                \            description: "Enable pretty-printing for gdb",
                \            text: "-enable-pretty-printing",
                \            ignoreFailures: v:true
                \          },
                \          #{
                \              description: "bruh",
                \              text: "-exec break main",
                \              ignoreFailures: v:true
                \          },
                \          #{
                \            description: "Break abort",
                \            text: "-exec break abort",
                \            ignoreFailures: v:true
                \          },
                \          #{
                \            description: "Break terminate",
                \            text: "-exec break terminate",
                \            ignoreFailures: v:true
                \          }
                \        ]
                \      }
                \}
                \})
endfunction
function s:AttachProcess(Program,PID) abort
    let ProgramPath = s:FixedExePath(a:Program)
    if(ProgramPath == "")
        echo "No executable with name '" .. ExtraArguments[0] .. "' found"
        return
    endif
    call vimspector#LaunchWithConfigurations(#{
                \    attach: 
                \    #{
                \      adapter: "vscode-cpptools",
                \      filetypes: [ "cpp", "c", "objc", "rust" ], 
                \      configuration: 
                \      #{
                \        request: "attach",
                \        program: ProgramPath,
                \        stopOnEntry: v:true,
                \        stopAtEntry: v:true,
                \        processId: a:PID,
                \        externalConsole: v:false,
                \        MIMode: "gdb",
                \        setupCommands: [
                \          #{
                \            description: "Enable pretty-printing for gdb",
                \            text: "-enable-pretty-printing",
                \            ignoreFailures: v:true
                \          },
                \          #{
                \              description: "bruh",
                \              text: "-exec break main",
                \              ignoreFailures: v:true
                \          },
                \          #{
                \            description: "Break abort",
                \            text: "-exec break abort",
                \            ignoreFailures: v:true
                \          },
                \          #{
                \            description: "Break terminate",
                \            text: "-exec break terminate",
                \            ignoreFailures: v:true
                \          }
                \        ]
                \      }
                \}
                \})
endfunction

command! -nargs=+ MBDebug call <SID>DebugProcess(<f-args>)
command! -nargs=+ MBAttach call <SID>AttachProcess(<f-args>)
