"" Check OS

if !exists('g:os')
  if has('mac')
    let g:os = 'mac'
  elseif has('unix')
    let g:os = 'linux'
    if !exists('g:version')
      let g:version = system("uname -r | awk '{print substr($1,1,1)}'")
    endif
    " https://vi.stackexchange.com/a/43358
    if !exists('g:distro')
      let g:distro = readfile('/etc/os-release')->filter({k,v -> v =~# '^ID='})[0]->slice(3)
    endif
  else
    let g:os = 'unknown'
  endif
endif

"" macOS config

if g:os == 'mac'
  set langmenu=en_US
  let $LANG = 'en_US'
  set clipboard=unnamed
endif

"" Generic platform config

if g:os == 'mac' || g:version > '4'

let mapleader = ","

" https://cscope.sourceforge.net/cscope_maps.vim
if has("cscope")

    """"""""""""" Standard cscope/vim boilerplate

    " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
    set cscopetag

    " check cscope for definition of a symbol before checking ctags: set to 1
    " if you want the reverse search order.
    set csto=0

    " Fix Fedora issue:
    " E568: Duplicate cscope database not added
    " https://src.fedoraproject.org/rpms/vim/blob/rawhide/f/vimrc
    if exists('g:distro') && g:distro == 'fedora'
        set nocscopeverbose
    endif

    " Support gtags-cscope
    " https://cvs.savannah.gnu.org/viewvc/*checkout*/global/global/gtags-cscope.vim
    if filereadable("GTAGS")
        set csprg=gtags-cscope
        cs add GTAGS
    endif

    " add any cscope database in current directory
    if filereadable("cscope.out")
        cs add cscope.out
    " else add the database pointed to by environment variable
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif

    " show msg when any other cscope db added
    set cscopeverbose


    """"""""""""" My cscope/vim key mappings
    "
    " The following maps all invoke one of the following cscope search types:
    "
    "   's'   symbol: find all references to the token under cursor
    "   'g'   global: find global definition(s) of the token under cursor
    "   'c'   calls:  find all calls to the function name under cursor
    "   't'   text:   find all instances of the text under cursor
    "   'e'   egrep:  egrep search for the word under cursor
    "   'f'   file:   open the filename under cursor
    "   'i'   includes: find files that include the filename under cursor
    "   'd'   called: find functions that function under cursor calls
    "
    " Below are three sets of the maps: one set that just jumps to your
    " search result, one that splits the existing vim window horizontally and
    " diplays your search result in the new window, and one that does the same
    " thing, but does a vertical split instead (vim 6 only).
    "
    " I've used CTRL-\ and CTRL-@ as the starting keys for these maps, as it's
    " unlikely that you need their default mappings (CTRL-\'s default use is
    " as part of CTRL-\ CTRL-N typemap, which basically just does the same
    " thing as hitting 'escape': CTRL-@ doesn't seem to have any default use).
    " If you don't like using 'CTRL-@' or CTRL-\, , you can change some or all
    " of these maps to use other keys.  One likely candidate is 'CTRL-_'
    " (which also maps to CTRL-/, which is easier to type).  By default it is
    " used to switch between Hebrew and English keyboard mode.
    "
    " All of the maps involving the <cfile> macro use '^<cfile>$': this is so
    " that searches over '#include <time.h>" return only references to
    " 'time.h', and not 'sys/time.h', etc. (by default cscope will return all
    " files that contain 'time.h' as part of their name).


    " To do the first type of search, hit 'CTRL-\', followed by one of the
    " cscope search types above (s,g,c,t,e,f,i,d).  The result of your cscope
    " search will be displayed in the current window.  You can use CTRL-T to
    " go back to where you were before the search.
    "

    nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>


    " Using 'CTRL-spacebar' (intepreted as CTRL-@ by vim) then a search type
    " makes the vim window split horizontally, with search result displayed in
    " the new window.
    "
    " (Note: earlier versions of vim may not have the :scs command, but it
    " can be simulated roughly via:
    "    nmap <C-@>s <C-W><C-S> :cs find s <C-R>=expand("<cword>")<CR><CR>

    nmap <C-@>s :scs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@>g :scs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@>c :scs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@>t :scs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@>e :scs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@>f :scs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-@>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-@>d :scs find d <C-R>=expand("<cword>")<CR><CR>


    " Hitting CTRL-space *twice* before the search type does a vertical
    " split instead of a horizontal one (vim 6 and up only)
    "
    " (Note: you may wish to put a 'set splitright' in your .vimrc
    " if you prefer the new window on the right instead of the left

    nmap <C-@><C-@>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>f :vert scs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-@><C-@>i :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-@><C-@>d :vert scs find d <C-R>=expand("<cword>")<CR><CR>


    """"""""""""" key map timeouts
    "
    " By default Vim will only wait 1 second for each keystroke in a mapping.
    " You may find that too short with the above typemaps.  If so, you should
    " either turn off mapping timeouts via 'notimeout'.
    "
    "set notimeout
    "
    " Or, you can keep timeouts, by uncommenting the timeoutlen line below,
    " with your own personal favorite value (in milliseconds):
    "
    "set timeoutlen=4000
    "
    " Either way, since mapping timeout settings by default also set the
    " timeouts for multicharacter 'keys codes' (like <F1>), you should also
    " set ttimeout and ttimeoutlen: otherwise, you will experience strange
    " delays as vim waits for a keystroke after you hit ESC (it will be
    " waiting to see if the ESC is actually part of a key code like <F1>).
    "
    "set ttimeout
    "
    " personally, I find a tenth of a second to work well for key code
    " timeouts. If you experience problems and have a slow terminal or network
    " connection, set it higher.  If you don't set ttimeoutlen, the value for
    " timeoutlent (default: 1000 = 1 second, which is sluggish) is used.
    "
    "set ttimeoutlen=100

endif

" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
"
"autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
"  \| PlugInstall --sync | source $MYVIMRC
"\| endif

" Deploy vim-plug
call plug#begin('~/.vim/plugged')
  Plug 'itchyny/lightline.vim'
  Plug 'preservim/nerdtree'
  "Plug 'vim-scripts/taglist.vim'
  Plug 'preservim/tagbar'
  "Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
  Plug 'rust-lang/rust.vim'
  Plug 'prabirshrestha/vim-lsp'
  Plug 'mattn/vim-lsp-settings'
  Plug 'tpope/vim-fugitive'
  Plug 'halkn/lightline-lsp'
  Plug 'farmergreg/vim-lastplace'
  "Plug 'dstein64/vim-startuptime'
  Plug 'bfrg/vim-c-cpp-modern'
call plug#end()

" lightline
let g:lightline = {
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'gitstatus', 'filename', 'modified' ],
  \             [ 'lsp_errors', 'lsp_warnings', 'lsp_ok', ],
  \             [ 'lineinfo', 'filetype' ] ],
  \   'right': [ ],
  \ },
  \ 'inactive': {
  \   'left': [ [ 'mode' ] ],
  \   'right': [ ],
  \ },
  \ 'component': {
  \ },
  \ 'component_function': {
  \   'mode': 'LightlineMode',
  \   'filename': 'LightlineFilename',
  \   'gitstatus': 'FugitiveStatusline',
  \ },
  \ 'component_expand': {
  \   'lsp_warnings': 'lightline_lsp#warnings',
  \   'lsp_errors':   'lightline_lsp#errors',
  \   'lsp_ok':       'lightline_lsp#ok',
  \ },
  \ 'component_type': {
  \   'lsp_warnings': 'warning',
  \   'lsp_errors':   'error',
  \   'lsp_ok':       'middle',
  \ },
  \ }

function! LightlineFilename()
  let fname = expand('%:t')
  return fname =~# '^__Tagbar__' ? '' :
       \ fname =~# 'NERD_tree' ? '' :
       \ expand('%:t') !=# '' ? expand('%:t') : ''
endfunction

function! LightlineMode()
  let fname = expand('%:t')
  return fname =~# '^__Tagbar__' ? 'Tagbar' :
       \ fname =~# 'NERD_tree' ? 'NERDTree' :
       \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

" NERDTree

" same as tagbar
" https://github.com/preservim/tagbar/blob/master/doc/tagbar.txt#L619
" g:tagbar_width = 40
let g:NERDTreeWinSize = 40

function NERDTreeToggleCustom()
  if exists("g:NERDTree") && g:NERDTree.IsOpen()
    if &filetype == 'nerdtree'
      :NERDTreeClose
    else
      :NERDTreeFocus
    endif
  elseif &filetype == 'nerdtree'
    :NERDTreeToggle
  else
    :NERDTreeFind
  endif
endfunction

nnoremap <leader>n :call NERDTreeToggleCustom()<CR>

" Tlist
"let Tlist_Auto_Highlight_Tag=1
"let Tlist_Auto_Open=1
"let Tlist_Auto_Update=1
"let Tlist_Use_Right_Window=1
"let Tlist_Exit_OnlyWindow=1
"let Tlist_WinWidth=50
"let Tlist_Sort_Type='name'
"nnoremap <silent> <F2> :TlistOpen<CR>

" tagbar
nmap <F8> :TagbarToggle<CR>
"autocmd VimEnter * nested :call tagbar#autoopen(1)
if !&diff
  autocmd FileType * nested :call tagbar#autoopen(0)
endif
let g:tagbar_sort = 0

" LeaderF
"let g:Lf_GtagsAutoGenerate = 1

" hlsearch
nnoremap <silent> <F3> :noh<CR>

" PreviewMarkdown
function! PreviewMarkdown()
  let l:path=expand('%:p')
  silent execute "!echo ".l:path." > ~/.lastpreview.log"
  :execute "tab :terminal"
endfunction

nmap <F4> : call PreviewMarkdown()<CR>clear<CR>glow -p $(cat ~/.lastpreview.log)<CR>

" vim-lsp and vim-lsp-settings
let g:lsp_settings = {
\  'clangd': {'disabled': v:true}
\}

let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_diagnostics_echo_delay = 0
let g:lsp_diagnostics_signs_delay = 0
let g:lsp_diagnostics_virtual_text_enabled = 0
let g:lsp_diagnostics_highlights_enabled = 0
let g:lsp_settings_enable_suggestions = 0

function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> gs <plug>(lsp-document-symbol-search)
  nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
  nmap <buffer> gr <plug>(lsp-references)
  nmap <buffer> gi <plug>(lsp-implementation)
  nmap <buffer> gt <plug>(lsp-type-definition)
  nmap <buffer> <leader>rn <plug>(lsp-rename)
  nmap <buffer> [g <plug>(lsp-previous-diagnostic)
  nmap <buffer> ]g <plug>(lsp-next-diagnostic)
  nmap <buffer> K <plug>(lsp-hover)
  nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
  nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

  let g:lsp_format_sync_timeout = 1000
  autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')

  " refer to doc to add more commands
endfunction

augroup lsp_install
  au!
  " call s:on_lsp_buffer_enabled only for languages that has the server registered.
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

function! ToggleClangd()
  let g:lsp_settings['clangd']['disabled'] = v:false
  execute 'LspInstallServer!' 'clangd'
  sleep 1
  q!
  call lsp#activate()
endfunction

nnoremap <leader>gc :call ToggleClangd()<CR>

" vim-fugitive
nnoremap <leader>gb :Git blame<CR>:exec 'normal i'<CR>gg

" vim-c-cpp-modern
let g:cpp_attributes_highlight = 1
let g:cpp_member_highlight = 1
let g:cpp_operator_highlight = 1
let g:cpp_simple_highlight = 1

" Global copy-paste
" https://github.com/ConradIrwin/vim-bracketed-paste/blob/master/plugin/bracketed-paste.vim
let &t_ti .= "\<Esc>[?2004h"
let &t_te = "\e[?2004l" . &t_te

function! XTermPasteBegin(ret)
  set pastetoggle=<f29>
  set paste
  return a:ret
endfunction

execute "set <f28>=\<Esc>[200~"
execute "set <f29>=\<Esc>[201~"
map <expr> <f28> XTermPasteBegin("i")
imap <expr> <f28> XTermPasteBegin("")
vmap <expr> <f28> XTermPasteBegin("c")
cmap <f28> <nop>
cmap <f29> <nop>

" Custom mapping key helper
" https://github.com/preservim/tagbar/pull/875
nnoremap <leader>q :qall<CR>
nnoremap <leader>w :wqall<CR>

nnoremap <leader><F1> :echon
\ "F3     - stop the highlighting\n"
\ "F4     - preview markdown file\n"
\ "F8     - toggle tagbar\n"
\ ", + gb - git blame cursor line\n"
\ ", + gc - toggle clangd lsp\n"
\ ", + n  - toggle NERDTree\n"
\ ", + F1 - this custom helper\n"
\ ", + q  - :qall\n"
\ ", + w  - :wqall\n"
\<CR>

endif

" Config
set nocompatible
syntax on
set backspace=indent,eol,start
set number
set hls
set mouse=a
set listchars=trail:.,tab:>-,space:.
set list
set background=dark
highlight ModeMsg ctermfg=lightblue
highlight Comment ctermfg=red
highlight TabSpace ctermfg=darkgrey
au BufRead,BufNewFile * match TabSpace /\t\| /
highlight! link DiffText ToDo
set tabstop=8
set softtabstop=8
set shiftwidth=8
set smarttab
set ruler
"set tags=tags
set laststatus=2
set noshowmode
" https://vimhelp.org/options.txt.html#%27clipboard%27
if has('unnamedplus')
  set clipboard=unnamedplus
endif
autocmd FileType cpp setlocal tabstop=4 shiftwidth=4 expandtab
