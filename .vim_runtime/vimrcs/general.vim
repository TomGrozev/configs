""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 
"   ___  ____  _  _  ____  ____    __    __    _  _  ____  __  __ 
"  / __)( ___)( \( )( ___)(  _ \  /__\  (  )  ( \/ )(_  _)(  \/  )
" ( (_-. )__)  )  (  )__)  )   / /(__)\  )(__  \  /  _)(_  )    ( 
"  \___/(____)(_)\_)(____)(_)\_)(__)(__)(____)()\/  (____)(_/\/\_)
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
" 1. General settings
" 2. User Interface
" 3. Colour scheme and fonts
" 4. Files and backups
" 5. Text managements
" 6. Searching
" 7. Tab management
" 8. Window management
" 9. Buffer management
" 10. Editor mappings
" 11. Spell checking
" 12. Misc
" 13. Command mappings
" 14. Helper functions
" 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" 1. General settings
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets number of lines to keep in memory
set history=1000

" Set leader timeout
set timeoutlen=1000 ttimeoutlen=100

" Set update time
set updatetime=500

" Ex is not used
nnoremap Q <NOP>

" Open help in a vertical window
cnoreabbrev help vert help

" Map leader key for additional combinations
let mapleader = ','
let g:mapleader = ','

" Faster exiting
imap jk <Esc>

" Fast saving
nmap <leader>w :w!<cr>

" :W is sudo save
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" 2. User interface
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 7 lines above and below the cursor push the view
set so=7

" Always show mode
set showmode

" Always show command key pressed
set showcmd

" Ensure lang is set to english
let $LANG='en'
set langmenu=en

" Reset menus
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

" Enable the wildmenu command suggestions
set wildmenu

" Ingore compiled files in wildmenu
set wildignore=*.o,*~,*.pyc,*/.git/*

" Show current position
set ruler

" Set command line height
set cmdheight=1

" Hide abandoned buffers
set hid

" Fix backspace behaviour (allow backspace to move to other lines)
set backspace=indent,eol,start

" Allow wrapping to other lines
set whichwrap+=<,>,h,l

" Ignore case on search by default and case smart
set ignorecase
set smartcase

" Highlight all search results
set hlsearch

" Incremental search highlighting
set incsearch

" Prevent redraw on macros (performance boost)
set lazyredraw

" Use regex by default
set magic

" Highlight matching brackets
set showmatch

" Make bracket highlight static
set mat=2

" GOODBYE ERROR SOUNDS
set noerrorbells
set visualbell
set t_vb=
autocmd GUIEnter * set visualbell t_vb=

" Extra margin on left
set foldcolumn=1

" Show status line
set laststatus=2

" Status line format
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c

" Omni completion
if exists('+omnifunc')
    autocmd Filetype *
        \ if &omnifunc == "" |
        \   setlocal omnifunc=syntaxcomplete#Complete |
        \ endif
endif

" CSS autocomplete
autocmd FileType css set omnifunc=csscomplete#CompleteCSS

" Set number display to hybrid
set number
set relativenumber

augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" 3. Colour scheme and fonts
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntax highlighting
syntax enable

" Use 256 colour palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif

set background=dark

" Pmenu colours
highlight Pmenu ctermfg=15 ctermbg=0 guifg=#81a1c1 guibg=#3b4252

" Colour scheme is loaded by pathogen, so must be set in plugins file

" Disable scrollbars
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L

" Set font according to system
if has("mac") || has("macunix")
    set gfn=Fira\ Code\ Regular:h14,Hack:h14,Source\ Code\ Pro:h15,Menlo:h15
elseif has("win16") || has("win32")
    set gfn=IBM\ Plex\ Mono:h14,Source\ Code\ Pro:h12,Bitstream\ Vera\ Sans\ Mono:h11
elseif has("gui_gtk2")
    set gfn=IBM\ Plex\ Mono\ 14,:Hack\ 14,Source\ Code\ Pro\ 12,Bitstream\ Vera\ Sans\ Mono\ 11
elseif has("linux")
    set gfn=IBM\ Plex\ Mono\ 14,:Hack\ 14,Source\ Code\ Pro\ 12,Bitstream\ Vera\ Sans\ Mono\ 11
elseif has("unix")
    set gfn=Monospace\ 11
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" 4. Files and backups
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Disable backup since git is used
set noswapfile
set nobackup
set nowb

" Use UTF-8 encoding
set encoding=utf8

" Unix standard file types
set ffs=unix,dos,mac

" Allow filetype plugins
filetype plugin on
filetype indent on

" Automatically read when file changed on disk
set autoread
au FocusGained,BufEnter * checktime

" Reload buffer after outside change
let g:f5msg = 'Buffer reloaded'
nnoremap <F5> :e<CR>:echo g:f5msg<CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" 5. Text managements
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Smart tabbing
set smarttab

" Use spaces instead of tabs (prevents errors in some file types)
set expandtab

" Set tab size
set shiftwidth=4
set tabstop=4

" Auto indent andsmart indent
set autoindent
set smartindent

" Wrap long lines
set wrap

" Linebreak at 500 characters
set lbr
set tw=500

" Surround selected text in visual mode
vnoremap $( <esc>`>a)<esc>`<i(<esc>
vnoremap $[ <esc>`>a]<esc>`<i[<esc>
vnoremap ${ <esc>`>a}<esc>`<i{<esc>
vnoremap $" <esc>`>a"<esc>`<i"<esc>
vnoremap $' <esc>`>a'<esc>`<i'<esc>
vnoremap $` <esc>`>a`<esc>`<i`<esc>

" Map auto complete of (, {, ", ', [
inoremap $( ()<esc>i
inoremap $[ []<esc>i
inoremap ${ {}<esc>i
inoremap $} {<esc>o}<esc>O
inoremap $' ''<esc>i
inoremap $" ""<esc>i

" Date insert
iab xdate <C-r>=strftime("%d/%m/%y")<cr>

" Datetime insert
iab xdatet <C-r>=strftime("%d/%m/%y %H:%M:%S")<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" 6. Searching
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Search forward for current selection
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>

" Search backward for current selection
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" <Space> to forward search, Ctrl-<Space> to reverse search
map <space> /
map <C-space> ?

" Disable highlighting for search results
map <silent> <leader><cr> :noh<cr>

" Use the the_silver_searcher if possible (much faster than Ack)
if executable('ag')
  let g:ackprg = 'ag --vimgrep --smart-case'
endif

" When you press gv you Ack after the selected text
vnoremap <silent> gv :call VisualSelection('gv', '')<CR>

" Open Ack and put the cursor in the right position
map <leader>g :Ack 

" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace', '')<CR>

" Do :help cope if you are unsure what cope is. It's super useful!
"
" When you search with Ack, display your results in cope by doing:
"   <leader>cc
"
" To go to the next search result do:
"   <leader>n
"
" To go to the previous search results do:
"   <leader>p
"
map <leader>cc :botright cope<cr>
map <leader>co ggVGy:tabnew<cr>:set syntax=qf<cr>pgg
map <leader>n :cn<cr>
map <leader>p :cp<cr>

" Make sure that enter is never overriden in the quickfix window
autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" 7. Tab management
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" New empty tab
map <leader>tn :tabnew<cr>

" Close all tabs except the active one
map <leader>to :tabonly<cr>

" Close active tab
map <leader>tc :tabclose<cr>

" Move tab
map <leader>tm :tabmove

" Switch to last tab
let g:lasttab = 1
nmap <leader>tl :exe "tabn ".g:lasttab<cr>
au TabLeave * let g:lasttab = tabpagenr()

" Open new tab with current buffer path
map <leader>te :tabedit <C-r>=expand("%:p:h")<cr>/


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" 8. Window management
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use shortcut window movement
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-h> <C-w>h
map <C-l> <C-w>l


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" 9. Buffer management
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Close current buffer
map <leader>bd :Bclose<cr>:tabclose<cr>gT

" Close all buffers
map <leader>ba :bufdo bd<cr>


map <leader>l :bnext<cr>
map <leader>h :bprevious<cr>

" Change working directory to directory of current buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Fix for switching between buffers
try
    set switchbuf=useopen,usetab,newtab
    set stal=2
catch
endtry

" Return to last position when openning a file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Scribble buffer
map <leader>q :e ~/buffer<cr>

" Scribble markdown buffer
map <leader>x :e ~/buffer.md<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" 10. Editor mappings
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 0 goes to first non-blank instead of start of line
map 0 ^

" Move line up or down using ALT+jk or CMD+jk
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

if has("mac") || has("macunix")
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
  vmap <D-j> <M-j>
  vmap <D-k> <M-k>
endif

" Remove trailing whitespace on some files that don't like it
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

if has("autocmd")
    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" 11. Spell checking
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Toggle spell checking
map <leader>ss :setlocal spell!<cr>

" Goto next and previous errors
map <leader>sn ]s
map <leader>sp [s

" Add word to dictionary
map <leader>sa zg

" Spelling suggestions
map <leader>s? z=


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" 12. Misc
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Fix for windows ^M in encodings
noremap <leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Toggle paste mode on/off
map <leader>pp :setlocal paste!<cr>

" Persistent undo
try
    set undodir=~/.vim_runtime/temp_dirs/undodir
    set undofile
catch
endtry


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" 13. Command mappings
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Path mappings
cno $h e ~/
cno $d e ~/Desktop/
cno $j e ./
cno $c e <C-\>eCurrentFileDir("e")<cr>

" Deleted everything till last slash
cno $q <C-\>eDeleteTillSlash()<cr>

" Bash like keys for the command line
cnoremap <C-A>		<Home>
cnoremap <C-E>		<End>
cnoremap <C-K>		<C-U>

cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" 14. Helper functions
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Checks if paste mode is enabled for status line
function! HasPaste()
    if &paste
        return 'PASTE MODE '
    endif
    return ''
endfunction

" Keep window open when closing a buffer
command!Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

" Run a VIM command
function! CmdLine(str)
    call feedkeys(":" . a:str)
endfunction 

" Visual selection search
function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Delete text until slash in command line
func! DeleteTillSlash()
    let g:cmd = getcmdline()

    if has("win16") || has("win32")
        let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\]\\).*", "\\1", "")
    else
        let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*", "\\1", "")
    endif

    if g:cmd == g:cmd_edited
        if has("win16") || has("win32")
            let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\\]\\).*\[\\\\\]", "\\1", "")
        else
            let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*/", "\\1", "")
        endif
    endif   

    return g:cmd_edited
endfunc

" Get directory of current file
func! CurrentFileDir(cmd)
    return a:cmd . " " . expand("%:p:h") . "/"
endfunc
