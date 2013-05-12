execute pathogen#infect()
filetype off
syntax on
filetype plugin indent on
set noswapfile
filetype indent on
set number
" APP SPECIFIC
  noremap <C-u> :CtrlP ~/src/property/property_bundle/trunk/apps/property<cr>
"
"
"Ruby standards
set shiftwidth=2
set tabstop=2
" Use space instead of a tab code?
set expandtab
"   Don't complain about hiding buffers
    set hidden


" LEADER
  let mapleader = ","

" Basic movement

"   left
    noremap j h

"   down
    noremap k j

"   up
    noremap i k

"   Big up
    noremap I 22gk

"   Big down
    noremap K 22gj

"   Fix insert
    noremap h i
    noremap H I

" Control

"   redo
    noremap U <C-r>

"   undo to previous file save state
    noremap <leader>u :earlier 1f<cr>
    noremap <leader>U :later 1f<cr>

    noremap / :set hlsearch<cr>/
    noremap <esc> :set nohlsearch<cr><esc>

"   record to register h
    noremap ! qh

"   play from register h
    noremap @ @h

" MARKS

"   delete all marks
    noremap '<space> :delmarks ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz

" BUFFERS

"   back a buffer
    noremap <leader>b :ls<cr>:b<space>

"   next buffer
    noremap <leader>B :bn!<return>


"   Move between tabs
    noremap <leader>T :tabp<cr>
    noremap <leader>t :tabn<cr>

"   Move between panes
    noremap <leader>i <C-w>k
    noremap <leader>j <C-w>h
    noremap <leader>k <C-w>j
    noremap <leader>l <C-w>l

" INSERT MODE

"   Enter insert mode

"     Tab in command mode
      nnoremap <tab> i<tab>
      "inoremap <tab> <space><space>

"   Code folding

"     Turn on
      set foldmethod=indent
      set foldlevel=3
      set foldnestmax=3
      "set foldenable

"     Increase foldlevel
      noremap zl zm

"     Descrease foldlevel
      noremap zj zr


"   NERDcomment uncomment
    map zk <leader>cu

"   NERDcomment Comment on
    map zi <Leader>cl
"   Special keys

" Settings

"   No audio bell
    set vb

"   let underscore separate words
    set iskeyword=@,_,48-57,192-255

"   Turn on persistent undo
    set undofile

"   Set the undofile direcetory
    set undodir=~/.vimundo/

"   maximum number of changes that can be undone
    set undolevels=1000

"   maximum number lines to save for undo on a buffer reload
    set undoreload=10000

"   Enter command mode when focus lost
    au FocusLost,TabLeave * call feedkeys("\<C-\>\<C-n>")

"   Strip trailing whitespace on write
    autocmd BufWritePre * :%s/\s\+$//e

"   ignore case on search
    "set ignorecase

"   If searching for caps, don't ignore case
    "set smartcase

"   jump to results as they are typed
    set incsearch

"   match def/end/if/else
    runtime 'macros/matchit.vim'

"   For speed

    set synmaxcol=500
    set ttyfast " u got a fast terminal
    set ttyscroll=3
    set lazyredraw " to avoid scrolling problems

"   Search
    "  this is pretty, but not working
    "  hi Search term=reverse,underline ctermfg=0 ctermbg=14 gui=underline,bold guifg=#b58900

" Plugins
" open ctag in new tab
map <C-a> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
"   for NerdComment
    filetype plugin on

"  Ctrl P for tags!
    noremap <C-t> :CtrlPTag<Cr>

"   Jquery syntax
    au BufRead,BufNewFile *.js set ft=javascript syntax=jquery

"   Handlebars syntax
    au BufRead,BufNewFile *.hbs set ft=handlebars syntax=handlebars


"   SuperTab Completion option to let me continue
    set completeopt=longest,menu,preview
    let g:SuperTabLongestEnhanced=0

"   Custom
  function! g:ToggleNuMode()
    if(&rnu == 1)
      set nu
    else
      set rnu
    endif
  endfunc
  noremap <leader>n :call g:ToggleNuMode()<cr>
  set rnu

" Appearance
" turn off scrollbars
" Yes, we need both of these lines :(
  set guioptions+=LlRrb
  set guioptions-=LlRrb
" Dim inactive windows using 'colorcolumn' setting
" This tends to slow down redrawing, but is very useful.
" Based on https://groups.google.com/d/msg/vim_use/IJU-Vk-QLJE/xz4hjPjCRBUJ
" XXX: this will only work with lines containing text (i.e. not '~')
function! s:DimInactiveWindows()
  for i in range(1, tabpagewinnr(tabpagenr(), '$'))
    let l:range = ""
    if i != winnr()
      if &wrap
        let l:width=256 " max
      else
        let l:width=winwidth(i)
      endif
      let l:range = join(range(1, l:width), ',')
    endif
    highlight ColorColumn guibg=#04222A
    call setwinvar(i, '&colorcolumn', l:range)
    "call setwinvar(i, '&guifg', l:range)
  endfor
endfunction
augroup DimInactiveWindows
  au!
  au WinEnter * call s:DimInactiveWindows()
  au WinEnter * set cursorline
  au WinLeave * set nocursorline
augroup END

"   Set line cursor in insert mode
    autocmd InsertEnter,InsertLeave * set cul!
"   Keep cursor in center
    set so=10

"   Font and size
    "set gfn=Menlo:h20
    set gfn=Menlo:h12

"   Theme
    syntax enable

    if has('gui_running')
        set background=dark
    else
        set background=light
    endif

    colorscheme solarized
    "colorscheme tir_black

"   Folding colors
    autocmd VimEnter * :hi Folded guifg=#073642 guibg=bg

"   Indent plug-in appearance
    let g:indent_guides_guide_size=2
    let g:indent_guides_auto_colors = 0
    autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=#002D38 ctermbg=3
    autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#003340 ctermbg=4

"   Turn on Indentation
    autocmd VimEnter * :IndentGuidesEnable

"   Set status bar colors
    hi User1 guifg=#6C71C4 guibg=#073642
    hi User2 guifg=#d33682 guibg=#073642

"   Show filename in status bar
    set laststatus=2
    set statusline=
    set statusline +=%2*[%n]\ %*            "buffer number
    set statusline +=%2*%m%*                "modified flag
    "set statusline +=%1*%{&ff}%*            "file format
    "set statusline +=%1*%y%*                "file type
    set statusline +=%1*\ %<%F%*            "full path
    set statusline +=%1*%=%5l%*             "current line
    set statusline +=%2*/%L%*               "total lines
    set statusline +=%1*%4v\ %*             "virtual column number
    set statusline +=%2*0x%04B\ %*          "character under cursor

" OPTIONS

"   set which commands wrap (default: b,s)
    set ww=b,s,h,l

"   break at nice chars (df: nolbr)
    set lbr

"   text selection doesn't include what's under the cursor (df: inclusive, or old)
    " set sel=old

"   auto indent new line? (df: noai)
    set ai


"   smart indent??? (df: nosi)
    set si

"   highlight search terms"
    "set hlsearch



function! RunCurrentSpecFile()
  if InSpecFile()
    let l:command = "s " . @% . " -f documentation"
    call SetLastSpecCommand(l:command)
    call RunSpecs(l:command)
  endif
endfunction

function! RunNearestSpec()
  if InSpecFile()
    let l:command = "s " . @% . " -l " . line(".") . " -f documentation"
    call SetLastSpecCommand(l:command)
    call RunSpecs(l:command)
  endif
endfunction

function! RunLastSpec()
  if exists("t:last_spec_command")
    call RunSpecs(t:last_spec_command)
  endif
endfunction

function! InSpecFile()
  return match(expand("%"), "_spec.rb$") != -1
endfunction

function! SetLastSpecCommand(command)
  let t:last_spec_command = a:command
endfunction

function! RunSpecs(command)
  execute ":w\|!clear && echo " . a:command . " && echo && " . a:command
endfunction
