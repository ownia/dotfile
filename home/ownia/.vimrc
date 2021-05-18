"sync vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

"deploy vim-plug
call plug#begin('~/.vim/plugged')
  Plug 'itchyny/lightline.vim'
  Plug 'preservim/nerdtree'
  Plug 'ctrlpvim/ctrlp.vim'
call plug#end()

"config
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
set tabstop=4
set softtabstop=4
set shiftwidth=4
set smarttab
set ruler
set tags=tags
set tags+=./tags
set tags+=~/code/linux-5.10/tags
set laststatus=2
set noshowmode

"NERDTree
let mapleader = ","
nnoremap <silent> <leader>n :NERDTreeToggle<CR>

"ctrlp
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_custom_ignore = {
	\ 'dir':  '\v[\/]\.(git|hg|svn)$',
	\ 'file': '\v\.(exe|so|dll)$',
	\ 'link': 'SOME_BAD_SYMBOLIC_LINKS',
	\ }
let g:ctrlp_user_command = 'find %s -type f'
let g:ctrlp_user_command = {
	\ 'types': {
		\ 1: ['.git', 'cd %s && git ls-files'],
		\ 2: ['.hg', 'hg --cwd %s locate -I .'],
		\ },
	\ 'fallback': 'find %s -type f'
	\ }
