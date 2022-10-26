if exists("b:current_syntax")
    finish
endif

"123 print test_variabel_123
syn match mbdDirective '^[[:space:]]*%.*'
syn match mbdFormat '^[[:space:]]*\(_#\|#\|#_\|/_\|/#\).*'
"syn match mbdReference '@[^[:space:][:punct:]]+\|\([^\]]+\)\?([^)]'
syn match mbdReference '@\([^[:space:][:punct:]]+\|\(\[[^\]]*\]\)\?(.*)\)'
syn region mbdCodeblock start=+^[[:space:]]*```+ end=+^[[:space:]]*```+

"syn region mbdSubformat start=+^\s*_#+ end=+^\s*/#+ contains=mbdSubformat,mbdTopformat
"syn region mbdTopformat start=+^\s*#_+ end=+^\s*/_+ contains=mbdSubformat,mbdTopformat

let b:current_syntax = "mbd"

hi mbdDirective ctermfg=Magenta
hi mbdFormat ctermfg=Green
hi mbdCodeblock ctermfg=Red
hi mbdReference ctermfg=Blue

"hi mbdSubformat ctermfg=
"hi mbdTopformat ctermfg=Green
