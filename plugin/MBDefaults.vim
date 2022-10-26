filetype plugin indent on    " required

set encoding=utf-8
set nocompatible
se history=200
syntax enable
set expandtab
set tabstop=4
set shiftwidth=4
set hidden
set hlsearch
set backspace=indent,eol,start
hi Visual term=reverse ctermbg=8 guibg=DarkGrey

inoremap {<CR> <CR>{<CR> <BS><CR>}<Up><Tab>
vnoremap <BS> "_d
nnoremap <BS> "_d
nnoremap <Space>p :put<CR>`]j=`[

set pastetoggle=<F2>
colorscheme MBScheme
set cpoptions+=I

hi CocSemClass ctermfg=green
hi CocSemEnum ctermfg=green
hi CocSemNamespace ctermfg=white
hi cConditional ctermfg=Magenta
" work around for windows, vim bug
tnoremap <S-space> <space>

" Termdebug grejer
nnoremap <c-s> :Step<CR>
nnoremap <c-n> :Over<CR>
nnoremap <c-f> :Finish<CR>
nnoremap <c-b> :Break<CR>
nnoremap <c-x> :Stop<CR>
nnoremap <c-c> :Continue<CR>
"packadd Termdebug

" Grejer för att göra det bättre med coc
nnoremap gd :call CocAction("jumpDefinition")<CR>
nnoremap gD :call CocAction("jumpDeclaration")<CR>
"nnoremap <c-j> <Plug>(coc-diagnostic-next-error)
"nnoremap <c-k> <Plug>(coc-diagnostic-next-error)
nnoremap <c-k> :call CocAction('diagnosticPrevious')<cr>
nnoremap <c-j> :call CocAction('diagnosticNext')<cr>

"Sh stuff
au BufRead,BufNewFile *.sh set fileformat=unix 
au BufRead,BufNewFile *.vim set fileformat=unix 

function! SynGroup()
    let l:s = synID(line('.'), col('.'), 1)
        echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
    endfun

nnoremap <Space>s :call SynGroup()<CR>

function! s:check_back_space() abort
      let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~ '\s'
    endfunction

    inoremap <silent><expr> <Tab>
          \ pumvisible() ? "\<C-n>" :
          \ <SID>check_back_space() ? "\<Tab>" :
          \ coc#refresh()

