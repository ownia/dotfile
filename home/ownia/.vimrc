call plug#begin('~/.vim/plugged')
"Plug 'Valloric/YouCompleteMe'
call plug#end()
set nocompatible
syntax on
set termguicolors
set backspace=indent,eol,start
set number
set hls
set mouse=a
set listchars=space:.,tab:>.,extends:>,precedes:<,trail:., "eol:¬
set list
highlight TabSpace ctermfg=242 ctermbg=NONE
match TabSpace /\t\| /
set tabstop=4
set softtabstop=4
set shiftwidth=4
set smarttab
set expandtab
set tags+=~/codespace/tags
