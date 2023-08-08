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
set updatetime=300

inoremap {<CR> <CR>{<CR> <BS><CR>}<Up><Tab>
vnoremap <BS> "_
nnoremap <BS> "_
nnoremap <Space>p :put<CR>`]j=`[
nnoremap Y y$
nnoremap x "_x
nnoremap , @@


set pastetoggle=<F2>
set cpoptions+=I

" work around for windows, vim bug
tnoremap <S-space> <space>

" Termdebug grejer
" nnoremap <c-s> :Step<CR>
" nnoremap <c-n> :Over<CR>
" nnoremap <c-f> :Finish<CR>
" nnoremap <c-b> :Break<CR>
" nnoremap <c-x> :Stop<CR>
" nnoremap <c-c> :Continue<CR>
" packadd Termdebug

" Grejer för att göra det bättre med coc
nnoremap gd :call CocAction("jumpDefinition")<CR>
nnoremap gD :call CocAction("jumpDeclaration")<CR>
nnoremap <Space>f :call CocAction("jumpReferences")<CR>
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

"function! s:check_back_space() abort
"      let col = col('.') - 1
"        return !col || getline('.')[col - 1]  =~ '\s'
"    endfunction
"
"    inoremap <silent><expr> <Tab>
"          \ pumvisible() ? "\<C-n>" :
"          \ <SID>check_back_space() ? "\<Tab>" :
"          \ coc#refresh()
"
nnoremap <silent> <S-Tab> :call <SID>SwitchSource()<CR>

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
"inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

"MEGA hack to support diagnostics in latest coc.nvim...
"au CocNvimInit * eval CocAction('diagnosticToggle')
"au CocNvimInit * eval CocAction('diagnosticToggle')

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

autocmd InsertLeave * call <SID>RefreshDiagnostic()

function! s:RefreshDiagnostic() abort
    if(CocAction('ensureDocument'))
        call CocActionAsync('diagnosticRefresh')
    endif
endfunction

function! s:SwitchSource() abort
    let BufferName = bufname()
    let NewBufferName = ""
    if BufferName =~ '.h$'
        let NewBufferName = substitute(BufferName,'.h$','.cpp',"")
    elseif BufferName =~ '.cpp$'
        let NewBufferName = substitute(BufferName,'.cpp$','.h',"")
    else
        return
    endif
    if filereadable(NewBufferName)
        echo NewBufferName
        execute 'edit ' . NewBufferName
    endif
endfunction

command! MBRadio tab term cmd /k mbradio
set mouse=""


nmap <s-f> 5j
nmap <s-b> 5k


colorscheme MBScheme
