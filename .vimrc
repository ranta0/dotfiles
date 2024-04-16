set nu
set relativenumber

set tabstop=4
set shiftwidth=4
set expandtab
set smarttab

set nowrap

set nocompatible

set list
set listchars=eol:¬,tab:▸\ ,trail:·

set autoread

set nobackup
set nowb
set noswapfile

set showcmd
set hlsearch
set incsearch
set updatetime=50
set isfname+=@-@

" thanks to https://github.com/changemewtf/no_plugins/blob/master/no_plugins.vim
set path+=**
set wildmenu

" movement
nnoremap <silent><expr> j v:count == 0 ? 'gj' : 'j'
nnoremap <silent><expr> k v:count == 0 ? 'gk' : 'k'
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap J mzJ`z
nnoremap n nzzzv
nnoremap N Nzzzv
xnoremap J :m<space>'>+1<CR>gv
xnoremap K :m<space>'<-2<CR>gv
vnoremap <silent> > >gv
vnoremap <silent> < <gv
nnoremap Q <nop>
" 's goes back to the starting search
nnoremap / ms/
nnoremap ? ms?
nnoremap gf <C-w>gf
nnoremap <C-t> :tabnew<CR>
nnoremap <C-l> gt
nnoremap <C-h> gT
nnoremap <C-k> :cn<CR>zz
nnoremap <C-j> :cp<CR>zz

" tools
nnoremap tr :%s///gn<CR>``cgn
nnoremap tR :%s///gn<CR>``cgN

let mapleader = " "

nnoremap <leader><C-k> :lnext<CR>zz
nnoremap <leader><C-j> :lprevious<CR>zz

nnoremap <leader>th :set hls!<CR>
nnoremap <leader>tw :set wrap!<CR>
nnoremap <leader>tn :set relativenumber!<CR>
nnoremap <leader>- :Ex<CR>

vnoremap <leader>T :s/\s\+$//e<LEFT><CR>

xnoremap <leader>y "+y
