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
  Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
call plug#end()

" NERDTree
let mapleader = ","
nnoremap <silent> <leader>n :NERDTreeToggle<CR>

" Tlist
let Tlist_Auto_Highlight_Tag=1
let Tlist_Auto_Open=1
let Tlist_Auto_Update=1
let Tlist_Use_Right_Window=1
let Tlist_Exit_OnlyWindow=1
let Tlist_WinWidth=50
"" let Tlist_Sort_Type='name'
nnoremap <silent> <F2> :TlistOpen<CR>

" tagbar
nmap <F8> :TagbarToggle<CR>
autocmd VimEnter * nested :call tagbar#autoopen(1)
let g:tagbar_sort = 0

" LeaderF
let g:Lf_GtagsAutoGenerate = 1

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
