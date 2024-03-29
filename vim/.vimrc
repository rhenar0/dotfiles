"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                   Plugins!
"                               Managed with VAM
"                https://github.com/MarcWeber/vim-addon-manager
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nocompatible | filetype indent plugin on | syn on

let g:vim_addon_manager = {}
let g:vim_addon_manager.shell_commands_run_method='system'

fun! SetupVAM()
  let c = get(g:, 'vim_addon_manager', {})
  let g:vim_addon_manager = c
  let c.plugin_root_dir = expand('$HOME', 1) . '/.vim/vim-addons'
  let &rtp.=(empty(&rtp)?'':',').c.plugin_root_dir.'/vim-addon-manager'
  if !isdirectory(c.plugin_root_dir.'/vim-addon-manager/autoload')
    execute '!git clone --depth=1 git://github.com/MarcWeber/vim-addon-manager '
        \       shellescape(c.plugin_root_dir.'/vim-addon-manager', 1)
  endif
  call vam#ActivateAddons([], {'auto_install' : 0})
endfun

call SetupVAM()
" use <c-x><c-p> to complete plugin names
" My plugin declarations
VAMActivate Solarized
VAMActivate ag
VAMActivate ctrlp
VAMActivate fugitive

VAMActivate github:rking/ag.vim
VAMActivate github:sjl/gundo.vim
VAMActivate mustache
VAMActivate github:scrooloose/nerdcommenter
VAMActivate github:scrooloose/nerdtree
VAMActivate github:ervandew/supertab
"VAMActivate vim-coffee-script
VAMActivate github:nathanaelkane/vim-indent-guides
"VAMActivate github:wikimatze/hammer.vim
"VAMActivate github:plasticboy/vim-markdown
"VAMActivate github:suan/vim-instant-markdown
VAMActivate github:tpope/vim-rails
VAMActivate github:vim-ruby/vim-ruby
VAMActivate github:jelera/vim-javascript-syntax
VAMActivate github:scrooloose/syntastic
VAMActivate github:pangloss/vim-javascript
VAMActivate github:kchmck/vim-coffee-script
VAMActivate github:rodjek/vim-puppet
VAMActivate github:moll/vim-node
VAMActivate github:henrik/vim-qargs
"VAMActivate vim-rvm
"VAMActivate vim-script
"VAMActivate vim-textobj-rubyblock
"VAMActivate vim-textobj-user
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  END VAM
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

filetype off
syntax on
filetype plugin indent on
set noswapfile
filetype indent on
set number
" LEADER
set shell=bash\ -i
  let mapleader = ","
"
" EXPERIMENTAL
nnoremap / /\v
vnoremap / /\v
cnoremap %s/ %smagic/
cnoremap \>s/ \>smagic/
nnoremap :g/ :g/\v
nnoremap :g// :g//
nnoremap <leader>a :Ag ""<left>
 let g:ctrlp_user_command = [
    \ '.git', 'cd %s && git ls-files . -co --exclude-standard',
    \ 'find %s -type f'
    \ ]
let g:syntastic_check_on_open=0
  "set shell=/bin/sh
  ab PRY require 'pry';binding.pry
  ab PRYR require 'pry-remote'; binding.remote_pry
  set tags=./tags,tags;
  noremap <leader>pp :cd ~/src/apm_bundle/apps/property
  noremap <leader>nt :NERDTreeFind<cr>
  let g:NERDTreeMapOpenSplit = "q"
  let NERDTreeIgnore=['.*tmp/.*', 'Icon$', '\~$']
  let g:ctrlp_max_depth = 500
  let g:ctrlp_max_files=100000
  let g:ctrlp_follow_symlinks = 1
  let g:ctrlp_clear_cache_on_exit = 1
  set wildignore+=**/screenshots/**
  noremap <leader>nu :GundoToggle<cr>
  noremap <C-b> :CtrlPBuffer<cr>
  noremap <leader>bb :bp<cr>
  noremap <D-R> :wa<cr>:.Rake<cr>
  noremap <leader>pc :!column -t -s ' '<cr>gv==
  noremap <leader>pf :call PathToCurrentFile()<cr>
  noremap <leader>pcc :call SnakeCaseToCamelCase()<cr>
  noremap <leader>psc :call CamelCaseToSnakeCase()<cr>
  noremap <leader>fp  :let @" = expand("%:p")
  set wildmenu
  set gcr=n:blinkon0
  set nocursorline
  noremap Y y$

  " MARKDOWN EDITING JUNK
  function! VimifyMarkDown()
    execute '%s/\~\([^~]\+\)/\~\r\1/g'
  endfunction

  function! DeVimifyMarkDown()
    execute '%s/\~\~\~\n\(.\+\)$/\~\~\~\1/g'
  endfunction

  " noremap <leader>fd :syn clear Repeat | g/^\(.*\)\n\ze\%(.*\n\)*\1$/exe 'syn match Repeat "^' . escape(getline('.'), '".\^$*[]') . '$"' | nohlsearch<cr>

  command! -nargs=0 -bar Qargs execute 'args' QuickfixFilenames()
  function! QuickfixFilenames()
    " pk: look into argdo
    " Building a hash ensures we get each buffer only once
    let buffer_numbers = {}
    for quickfix_item in getqflist()
      let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
    endfor
    return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
  endfunction

" Compile Ruby code after writing (show warnings/errors)
  function! CheckRubySyntax()
    " don't compile if it's an Rspec file (extra warnings)
    let name = expand('<afile>')
    if name !~ 'spec'
      compiler ruby
      setlocal makeprg=ruby\ -wc\ %
      make
    endif
  endfunction
  "autocmd BufWritePost *.rb call CheckRubySyntax()

  function! SnakeCaseToCamelCase()
    execute 's#\(\%(\<\l\+\)\%(_\)\@=\)\|_\(\l\)#\u\1\2#g'
  endfunction

  function! CamelCaseToSnakeCase()
    execute ':s#\C\(\<\u[a-z0-9]\+\|[a-z0-9]\+\)\(\u\)#\l\1_\l\2#g'
  endfunction

  function! PathToCurrentFile()
    execute 'cd %:p:h'
    execute 'pwd'
  endfunction

  "noremap <leader>r *#:%s///gc<left><left><left>
  noremap <leader>r :rubydo $_.gsub! //, ''<left><left><left><left><left>
  noremap <leader>v :vsp<cr>:e $MYVIMRC<cr>
  noremap <C-tab> gt
  noremap <C-S-tab> gT
  noremap <C-l> <C-i>
  noremap <C-j> <C-o>

  " DELETE HIDDEN BUFFERS
  function! DeleteInactiveBufs()
    "From tabpagebuflist() help, get a list of all buffers in all tabs
    let tablist = []
    for i in range(tabpagenr('$'))
      call extend(tablist, tabpagebuflist(i + 1))
    endfor

    "Below originally inspired by Hara Krishna Dara and Keith Roberts
    "http://tech.groups.yahoo.com/group/vim/message/56425
    let nWipeouts = 0
    for i in range(1, bufnr('$'))
      if bufexists(i) && !getbufvar(i,"&mod") && index(tablist, i) == -1
        "bufno exists AND isn't modified AND isn't in the list of buffers open in windows and tabs
        silent exec 'bwipeout' i
        let nWipeouts = nWipeouts + 1
      endif
    endfor
    echomsg nWipeouts . ' buffer(s) wiped out'
  endfunction
  command! Bdi :call DeleteInactiveBufs()

" open ctag in new tab
  function! OpenTagSameWindow()
    let pk_last_line = getline(2)
    if pk_last_line == ''
      echo 'close the window here'
      echo expand('<cword>')
      execute "normal :lclose<CR>"
      echo "only one line"
    endif
    echo "more than one line"
  endfunction

  function! EchoWord()
    let _pk_word = expand('<cword>')
    echo _pk_word
    exec "tag " . _pk_word
  endfunction
  "map <C-]> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
  map <C-]> :tab split<CR>:exec("ltag ".expand("<cword>"))<CR>:lopen<CR><CR>
  "map <C-k> :exec("ltag ".expand("<cword>"))<CR>:lopen<CR><CR>
  map <C-k> :exec("ltag ".expand("<cword>"))<CR>:lopen<CR><CR>:call OpenTagSameWindow()<cr>

"Ruby standards
set shiftwidth=2

set tabstop=2
" Use space instead of a tab code?
set expandtab
"   Don't complain about hiding buffers
    set hidden

" Basic movement

"   left
    noremap j h
    "noremap <A-j> h

"   down
    noremap k j
    "noremap <A-k> j

"   up
    noremap i k
    "noremap <A-i> k

"   Big up
    noremap I 22gk

"   Big down
    noremap K 22gj

"   Fix insert
    noremap h i
    "noremap <A-h> i
    noremap H I
    "noremap <A-H> I

" Control

"   redo
    noremap U <C-r>

"   undo to previous file save state
    noremap <leader>u :earlier 1f<cr>
    noremap <leader>U :later 1f<cr>

    "noremap / :set hlsearch<cr>/
    noremap <esc> :set hlsearch!<cr><esc>

"   record to register h
    "noremap ! qh

"   play from register h
    "noremap @ @h
    "noremap # @

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
    set iskeyword=@,?,!,_,48-57,192-255

"   Turn on persistent undo
    set undofile

"   Set the undofile direcetory
    set undodir=~/.vimundo/

"   maximum number of changes that can be undone
    set undolevels=10000

"   maximum number lines to save for undo on a buffer reload
    set undoreload=100000

"   Enter command mode when focus lost
    au FocusLost,TabLeave * call feedkeys("\<C-\>\<C-n>")
    au FocusLost * silent! wa

"   Strip trailing whitespace on write
    "autocmd BufWritePre * :%s/\s\+$//e

    noremap <leader>w :%s/\s\+$//e<cr>

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
"   for NerdComment
    filetype plugin on

"  Ctrl P for tags!
    noremap <C-t> :CtrlPTag<Cr>

"   Jquery syntax
    "au BufRead,BufNewFile *.js set ft=javascript syntax=jquery

"   Handlebars syntax
    au BufRead,BufNewFile *.hbs set ft=handlebars syntax=mustache


"   SuperTab Completion option to let me continue
    set completeopt=longest,menu,preview
    let g:SuperTabLongestEnhanced=0

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
  " cursorline makes things slow :(
  "au WinEnter * set cursorline
  au WinLeave * set nocursorline
augroup END

"   Set line cursor in insert mode
"   Cursorline makes things slow :(
    "autocmd InsertEnter,InsertLeave * set cul!
"   Keep cursor in center
    set so=10

"   Font and size
    "set gfn=Menlo:h20
    set gfn=Menlo:h12

"   Theme
    "syntax enable

    if has('gui_running')
        set background=dark
    else
        set background=light
    endif
    colorscheme solarized

    if &diff
      let g:solarized_diffmode='high'
      set syntax=off
    else
    endif


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
"   Folding colors
    hi Folded guifg=#073642 guibg=bg

"   Show filename in status bar
    set laststatus=2
    set statusline=
    set statusline +=%2*[%n]\ %*            "buffer number
    set statusline +=%2*%m%*                "modified flag
    "set statusline +=%1*%{&ff}%*            "file format
    "set statusline +=%1*%y%*                "file type
    "set statusline +=%{rvm#statusline()}
    set statusline +=%1*\ %<%F%*            "full path
    set statusline +=%1*%=%5l%*             "current line
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

"
  noremap <D-i> k
  noremap <D-k> j
  noremap <D-j> h
  noremap <D-l> l

