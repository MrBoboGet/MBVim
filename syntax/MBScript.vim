if exists("b:current_syntax")
    finish
endif

"123 print test_variabel_123
syn keyword	mbsStatement break return continue function
syn keyword mbsBuiltins print list
syn keyword mbsFlow while for if
syn match mbsNumber '\d\+'
syn region mbsString start=+"+  skip=+\\"+  end=+"+
syn match mbsIdentifier '[[:alpha:]]\+\([[:alnum:]_]*\)'
syn match mbsFunctionCall '[[:alpha:]]\+\([[:alnum:]_]*\)\ze([^)]*)'

let b:current_syntax = "mbs"

hi def link mbsNumber MBNumber
hi def link mbsStatement MBStatement 
hi def link mbsFlow MBStatement
hi def link mbsString MBString
hi def link mbsIdentifier MBIdentifier
hi def link mbsBuiltins MBFunction
hi def link mbsFunctionCall MBFunction
