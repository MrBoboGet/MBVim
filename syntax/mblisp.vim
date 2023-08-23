"if exists("b:current_syntax")
"    finish
"endif

"123 print test_variabel_123
syn match mblNumber '\d\+'
syn region mblString start=+"+  end=+"+ skip=+\\+  
syn match mblBool 'true\|false'
syn match mblBool 'null'

let b:current_syntax = "mblisp"

hi def link mblNumber MBNumber
hi def link mblBool MBBool 
hi def link mblString MBString
