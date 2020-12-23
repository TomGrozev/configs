""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 
"  ____  ____  __    ____  ____  _  _  ____  ____  ___  _  _  ____  __  __ 
" ( ___)(_  _)(  )  ( ___)(_  _)( \/ )(  _ \( ___)/ __)( \/ )(_  _)(  \/  )
"  )__)  _)(_  )(__  )__)   )(   \  /  )___/ )__) \__ \ \  /  _)(_  )    ( 
" (__)  (____)(____)(____) (__)  (__) (__)  (____)(___/()\/  (____)(_/\/\_)
" 
" 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 
" Version : 0.0.1
" License : MIT
" Author  : Tom Grozev — @TomGrozev
" URL     : https://github.com/TomGrozev/dotfiles
" 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" This file is almost entirely based off of from https://github.com/amix/vimrc
" 
" Sections:
" 1. General settings
" 
" 
" 
" 
" 
" 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""
"
" Python section
"
""""""""""""""""""""""""""""""
let python_highlight_all = 1
au FileType python syn keyword pythonDecorator True None False self

au BufNewFile,BufRead *.jinja set syntax=htmljinja
au BufNewFile,BufRead *.mako set ft=mako

au FileType python map <buffer> F :set foldmethod=indent<cr>

au FileType python inoremap <buffer> $r return 
au FileType python inoremap <buffer> $i import 
au FileType python inoremap <buffer> $p print 
au FileType python inoremap <buffer> $f # --- <esc>a
au FileType python map <buffer> <leader>1 /class 
au FileType python map <buffer> <leader>2 /def 
au FileType python map <buffer> <leader>C ?class 
au FileType python map <buffer> <leader>D ?def 


""""""""""""""""""""""""""""""
"
" JavaScript section
"
"""""""""""""""""""""""""""""""
au FileType javascript call JavaScriptFold()
au FileType javascript setl fen
au FileType javascript setl nocindent

au FileType javascript imap <C-t> $log();<esc>hi
au FileType javascript imap <C-a> alert();<esc>hi

au FileType javascript inoremap <buffer> $r return 
au FileType javascript inoremap <buffer> $f // --- PH<esc>FP2xi

function! JavaScriptFold() 
    setl foldmethod=syntax
    setl foldlevelstart=1
    syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend

    function! FoldText()
        return substitute(getline(v:foldstart), '{.*', '{...}', '')
    endfunction
    setl foldtext=FoldText()
endfunction



""""""""""""""""""""""""""""""
"
" Shell section
"
""""""""""""""""""""""""""""""
if exists('$TMUX') 
    if has('nvim')
        set termguicolors
    else
        set term=screen-256color 
    endif
endif


""""""""""""""""""""""""""""""
"
" JSON section
"
""""""""""""""""""""""""""""""
au! BufRead,BufNewFile *.json set filetype=json


augroup json_autocmd
  autocmd!
  autocmd FileType json set autoindent
  autocmd FileType json set formatoptions=tcq2l
  autocmd FileType json set textwidth=78 shiftwidth=2
  autocmd FileType json set softtabstop=2 tabstop=8
  autocmd FileType json set expandtab
  autocmd FileType json set foldmethod=syntax
augroup END


""""""""""""""""""""""""""""""
" 
" Markdown
"
""""""""""""""""""""""""""""""
let vim_markdown_folding_disabled = 1
