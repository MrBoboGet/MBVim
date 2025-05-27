nmap <c-s> <plug>VimspectorStepInto
nmap <c-n> <plug>VimspectorStepOver
nmap <c-f> <plug>VimspectorStepOut
nmap <c-b> <plug>VimspectorToggleBreakpoint
nmap <c-c> <plug>VimspectorContinue


let s:launchConfigGetters = {}

function! CppLaunchSettings(path)
    let dir = fnamemodify(a:path,":h")
    let path = substitute(simplify(resolve(a:path)),"\\","/","g")
    while getftype(dir .. "/MBSourceInfo.json") == ""
        let newDir = fnamemodify(dir,":h")
        if newDir == dir
            throw "No MBSourceInfo.json in parent directories"
        endif
    endwhile
    let sourceInfo = readfile(dir .. "/MBSourceInfo.json")->reduce({a,b -> a .. b})->json_decode()
    let targets = sourceInfo["Targets"]
    let programName = ""
    for key in keys(targets)
        let target = targets[key]
        if target["TargetType"] != "Executable"
            continue
        endif
        for source in target["Sources"]
            let absolutePath = substitute(simplify(resolve(fnamemodify(dir .. source,":p"))),"\\","/","g")
            echo absolutePath
            echo path
            if absolutePath == path
                let programName = target["OutputName"]
                if windowsversion() != ""
                    let programName = programName .. ".exe"
                    break
                endif
            endif
        endfor
        if programName == ""
            break
        endif
    endfor
    if programName == ""
        throw "No target in the source info includes the source file"
    endif
    let programPath = dir .. "/MBPM_Builds/Debug/".. programName
    return #{
        \         request: "launch",
        \         cwd: ".",
        \         stopOnEntry: v:true,
        \         externalConsole: v:true,
        \         debugOptions: [],
        \         program: programPath,
        \         args: []
        \      }
endfunction

function! RegisterLaunchSettingsGetter(fileType,Func)
    let s:launchConfigGetters[a:fileType] = a:Func
endfunction

call RegisterLaunchSettingsGetter("cpp",funcref("CppLaunchSettings"))

function! s:getLangConfig()
    let CurrentLang = &filetype
    let ConfigGetter = ""
    let launchConfig = #{}
    if has_key(s:launchConfigGetters,CurrentLang)
        let ConfigGetter = s:launchConfigGetters[CurrentLang]
        let launchConfig = ConfigGetter(expand("%:p"))
        echo launchConfig
    endif
    if CurrentLang == "mblisp"
        return #{
        \    Launch: 
        \    #{
        \      adapter: 
        \       #{
        \            command: "mblisp C:/Users/emanu/Desktop/Program/C++/MBLisp/Applications/DAP/index.lisp"
        \       },
        \      filetypes: [ "mblisp"],
        \      configuration: 
        \      #{
        \      adapter: 
        \       #{
        \            command: "mblisp C:/Users/emanu/Desktop/Program/C++/MBLisp/Applications/DAP/index.lisp"
        \       },
        \        request: "launch",
        \        args: [],
        \        path: expand("%")
        \      }
        \}
        \}
    elseif CurrentLang == "python"
        return #{
        \    Launch: 
        \    #{
        \      adapter: 
        \       #{
        \            command: "debugpy"
        \       },
        \      filetypes: [ "python"],
        \      configuration:  
        \      #{
        \         name: "Python: Launch",
        \         type: "python",
        \         request: "launch",
        \         cwd: ".",
        \         python: "python",
        \         stopOnEntry: v:true,
        \         console: "externalTerminal",
        \         debugOptions: [],
        \         program: expand("%"),
        \         args: []
        \      }
        \}
        \}
    elseif CurrentLang == "cpp"
        return #{
        \    Launch: 
        \    #{
        \      adapter: 
        \       #{
        \            command: "lldb-dap.exe"
        \       },
        \      filetypes: [ "cpp"],
        \      configuration:  launchConfig
        \}
        \}
    endif
    return #{}
endfunction

function! s:startDebug()
    set signcolumn=yes
    "VimspectorMkSession 
    "call vimspector#ClearBreakpoints()
    "VimspectorLoadSession  
    if getftype(".vimspector") == ""
        call vimspector#LaunchWithConfigurations(s:getLangConfig())
    else
        call vimspector#Launch()
    endif
endfunction

function! s:stopDebug()
    set signcolumn=auto
    call vimspector#Stop()
endfunction

nmap <space>d :call <SID>startDebug()<CR>
nmap <space>D :VimspectorReset<CR>
nmap <c-x> :call <SID>stopDebug()<CR>
nmap E viwE
vmap E <plug>VimspectorBalloonEval
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


tmap <BS> <char-0x7f>


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
