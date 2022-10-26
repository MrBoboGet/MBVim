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
hi MBString ctermfg=Red
hi MBFunction ctermfg=LightYellow
hi MBIdentifier ctermfg=White

hi Function ctermfg=yellow
hi Type ctermfg=DarkBlue
hi Statement ctermfg=Magenta

hi Visual term=reverse ctermbg=8 guibg=DarkGrey

" vim: sw=2
