
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 
"  ____  __    __  __  ___  ____  _  _  ___  _  _  ____  __  __ 
" (  _ \(  )  (  )(  )/ __)(_  _)( \( )/ __)( \/ )(_  _)(  \/  )
"  )___/ )(__  )(__)(( (_-. _)(_  )  ( \__ \ \  /  _)(_  )    ( 
" (__)  (____)(______)\___/(____)(_)\_)(___/()\/  (____)(_/\/\_)
" 
" 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 
" Version : 0.0.1
" License : MIT
" Author  : Tom Grozev — @TomGrozev
" URL     : https://github.com/TomGrozev/dotfiles
" 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 
" Sections:
" 1. Pathogen plugins
" 2. Nerd Tree
" 3. Git Gutter
" 4. Ale (Syntax)
" 5. Lightline
" 6. CTRL-P
" 7. YankStack
" 8. BufExplorer
" 9. TagBar
" 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" 1. Pathogen plugins
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:vim_runtime = expand('<sfile>:p:h')."/.."
call pathogen#infect(s:vim_runtime.'/plugins/{}')
call pathogen#helptags()

" Load colour scheme
colorscheme nord


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" 2. Nerd Tree
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:NERDTreeWinPos = "left"
let NERDTreeShowHidden=0
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
let g:NERDTreeWinSize=35
" Start NERDTree automatically
autocmd VimEnter * NERDTree | wincmd p
" Mirror NERDTree on each new tab
autocmd BufWinEnter * silent NERDTreeMirror
" Exit if NERDTree is last window
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif
map <leader>nn :NERDTreeToggle<cr>
map <leader>nb :NERDTreeFromBookmark<Space>
map <leader>nf :NERDTreeFind<cr>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" 3. Git Gutter
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:gitgutter_enabled=0
nnoremap <silent> <leader>d :GitGutterToggle<cr>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" 4. Ale (Syntax)
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TODO: More config here
let g:ale_linters = {
\   'javascript': ['jshint'],
\   'python': ['flake8'],
\   'go': ['go', 'golint', 'errcheck'],
\   'elixir': ['elixir-ls']
\}

let g:ale_fixers = {
\   'elixir': ['mix_format'],
\}

noremap <Leader>ad :ALEGoToDefinition<CR>
nnoremap <leader>af :ALEFix<cr>
noremap <Leader>ar :ALEFindReferences<CR>

"Move between linting errors
nnoremap ]r :ALENextWrap<CR>
nnoremap [r :ALEPreviousWrap<CR>

" Disabling highlighting
let g:ale_set_highlights = 0

" Only run linting when saving the file
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0

let g:ale_completion_enabled = 1
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
highlight ALEErrorSign ctermbg=NONE ctermfg=red
highlight ALEWarningSign ctermbg=NONE ctermfg=yellow
let g:ale_linters_explicit = 1
let g:ale_lint_on_save = 1
let g:ale_fix_on_save = 1

" Elixir Language server location
let g:ale_elixir_elixir_ls_release='~/.local/share/elixir-ls/release'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" 5. Lightline (status bar)
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:lightline = {
      \ 'colorscheme': 'nord',
      \ 'active': {
      \   'left': [ ['mode', 'paste'],
      \             ['fugitive', 'readonly', 'filename', 'modified'] ],
      \   'right': [ [ 'lineinfo' ], ['percent'] ]
      \ },
      \ 'component': {
      \   'readonly': '%{&filetype=="help"?"":&readonly?"🔒":""}',
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
      \   'fugitive': '%{exists("*FugitiveHead")?FugitiveHead():""}'
      \ },
      \ 'component_visible_condition': {
      \   'readonly': '(&filetype!="help"&& &readonly)',
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
      \   'fugitive': '(exists("*FugitiveHead") && ""!=FugitiveHead())'
      \ },
      \ 'separator': { 'left': ' ', 'right': ' ' },
      \ 'subseparator': { 'left': ' ', 'right': ' ' }
      \ }


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" 6. CTRL-P
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ctrlp_working_path_mode = 0

" Quickly find and open a file in the current working directory
let g:ctrlp_map = '<C-f>'
map <leader>j :CtrlP<cr>

" Quickly find and open a buffer
map <leader>b :CtrlPBuffer<cr>

" Quickly find and open a recently opened file
map <leader>f :CtrlPMRU<CR>

let g:ctrlp_max_height = 20
let g:ctrlp_custom_ignore = 'node_modules\|^\.DS_Store\|^\.git'


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" 7. YankStack
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:yankstack_yank_keys = ['y', 'd']

nmap <C-p> <Plug>yankstack_substitute_older_paste
nmap <C-n> <Plug>yankstack_substitute_newer_paste


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" 8. Bufexplorer
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:bufExplorerDefaultHelp=0
let g:bufExplorerShowRelativePath=1
let g:bufExplorerFindActive=1
let g:bufExplorerSortBy='name'
map <leader>o :BufExplorer<cr>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" 9. TagBar
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <leader>tt :TagbarToggle<CR>
