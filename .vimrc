set nu
set relativenumber

set tabstop=4
set shiftwidth=4
set expandtab
set smarttab

set ai
set si

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
nnoremap <C-a> ggVG<cr>
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

" tools
nnoremap tr :%s///gn<CR>``cgn
nnoremap tR :%s///gn<CR>``cgN

" nnoremap th :set hls!<CR>
" nnoremap tw :set wrap!<CR>
" nnoremap tn :set relativenumber!<CR>
" vnoremap T :s/\s\+$//e<LEFT><CR>
