" set color scheme
colorscheme koehler
" set spell lang
setlocal spell spelllang=en_us
" nocompatible to vi mode
set nocompatible 
" Set to auto read when a file is changed from the outside
set autoread
" When vimrc is edited, reload it
autocmd! bufwritepost .vimrc source ~/.vimrc
"Always show current position
set ruler
" status line
set statusline=%F%m%r%h%w\ %y\ [len=%L]\ %5(%l%V\,%c%V\ %p%%%)
set laststatus=2 " Always show the statusline on the 2nd last row
" Set backspace config
set backspace=eol,start,indent
set whichwrap +=<,>,h,l
"search settings
set hlsearch "Highlight search things
set incsearch "Make search act like search in modern browsers
"Show matching bracets when text indicator is over them
set showmatch 
" Enable filetype plugin
filetype plugin on
filetype indent on "Indent files
"Enable syntax hl
syntax on 
"Show line number
set number 
" tab config
set tabstop=8
set expandtab
set softtabstop=4
set shiftwidth=4
" C-n/p to go to the next/previous buffer.
noremap <silent> <C-n> :bn<CR>
noremap <silent> <C-p> :bp<CR>
" ss: horizontal split // vv: vertical split
nnoremap <silent> ss :split<CR>
nnoremap <silent> vv :vsplit<CR>
" switch between splits easily
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
