set termguicolors
hi clear Normal
set bg&

" Remove all existing highlighting and set the defaults.
hi clear

" Load the syntax highlighting defaults, if it's enabled.
if exists("syntax_on")
  syntax reset
endif

let colors_name = "MBScheme"

hi MBStatement ctermfg=Magenta
hi MBNumber ctermfg=Blue
hi MBString ctermfg=Red guifg=#ff0000
hi MBFunction ctermfg=LightYellow guifg=#ffff00
hi MBIdentifier ctermfg=White 

hi Function ctermfg=yellow guifg=#ffff00
hi Type ctermfg=DarkBlue guifg=#0000ff
hi Statement ctermfg=Magenta guifg=#b4009e
hi Constant guifg=#b4009e 
hi String ctermfg=Red guifg=#ff0000


hi PreProc guifg=#0037da

hi CocSemClass guifg=#00ff00
hi CocSemNamespace  ctermfg=white guifg=white
hi CocErrorHighlight guibg=#770000
hi CocSemMacro guifg=#a600c3
hi CocSemBoolean guifg=#0000FF


hi clear cConditional 
hi link cConditional Statement
hi clear CocSemEnum
hi link CocSemEnum CocSemClass

hi Visual term=reverse ctermbg=8 guibg=DarkGrey
highlight PMenu ctermbg=Black guibg=#000000
hi Normal ctermbg=Black guibg=#000000
" vim: sw=2
