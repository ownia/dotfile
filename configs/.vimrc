"" Check OS
if !exists('g:os')
  if has('mac')
    let g:os = 'mac'
  elseif has('unix')
    let g:os = 'linux'
    if !exists('g:version')
      let g:version = system("uname -r | awk '{print substr($1,1,1)}'")
    endif
  else
    let g:os = 'unknown'
  endif
endif


if g:os == 'mac'
  set langmenu=en_US
  let $LANG = 'en_US'
endif

if g:os == 'mac' || g:version > '4'

" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

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
call plug#end()

" NERDTree
let mapleader = ","
nnoremap <silent> <leader>n :NERDTreeToggle<CR>

" Tlist
"let Tlist_Auto_Highlight_Tag=1
"let Tlist_Auto_Open=1
"let Tlist_Auto_Update=1
"let Tlist_Use_Right_Window=1
"let Tlist_Exit_OnlyWindow=1
"let Tlist_WinWidth=50
"" let Tlist_Sort_Type='name'
"nnoremap <silent> <F2> :TlistOpen<CR>

" tagbar
nmap <F8> :TagbarToggle<CR>
autocmd VimEnter * nested :call tagbar#autoopen(1)
let g:tagbar_sort = 0

" LeaderF
"let g:Lf_GtagsAutoGenerate = 1


" PreviewMarkdown
function! PreviewMarkdown()
  let l:path=expand('%:p')
  silent execute "!echo ".l:path." > ~/.lastpreview.log"
  :execute "bel vert terminal"
endfunction

" Map
nmap <F4> : call PreviewMarkdown()<CR>clear<CR>glow -p $(cat ~/.lastpreview.log)<CR>

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
highlight TabSpace ctermfg=DarkGrey
match TabSpace /\t\| /
set tabstop=8
set softtabstop=8
set shiftwidth=8
set smarttab
set ruler
set tags=./.tags;,.tags
set laststatus=2
set noshowmode
set background=dark
