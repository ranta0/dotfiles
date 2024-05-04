" https://github.com/itchyny/dotfiles/blob/main/.vimrc
if &encoding !=? 'utf-8' | let &termencoding = &encoding | endif
set encoding=utf-8 fileencoding=utf-8 fileformats=unix,mac,dos
set fileencodings=utf-8,iso-2022-jp-3,euc-jisx0213,cp932,euc-jp,sjis,jis,latin,iso-2022-jp

set nu relativenumber nowrap
set tabstop=4 shiftwidth=4 expandtab smarttab autoindent smartindent

set nohidden autoread

set list listchars=eol:¬,tab:▸\ ,trail:·
set hlsearch incsearch

set showcmd noruler laststatus=2 statusline=%t\ %=\ %m%r%y%w\ %3l:%-2c

" thanks to https://github.com/changemewtf/no_plugins/blob/master/no_plugins.vim
set path+=**
set wildmenu
set wildignore=*.~,*.?~,*.o,*.sw?,*.bak,*.hi,*.pyc,*.out suffixes=*.pdf

set nobackup noswapfile
set updatetime=50 lazyredraw ttyfast

" nice to have
nnoremap <silent><expr> j v:count == 0 ? 'gj' : 'j'
nnoremap <silent><expr> k v:count == 0 ? 'gk' : 'k'
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzzzv
nnoremap N Nzzzv
xnoremap J :m<space>'>+1<CR>gv
xnoremap K :m<space>'<-2<CR>gv
vnoremap <silent> > >gv
vnoremap <silent> < <gv
vnoremap $ $h
nnoremap Q <nop>
nnoremap gQ <nop>

" tabs
nnoremap gf <C-w>gf
nnoremap <C-t> :tabnew<CR>
nnoremap <C-l> gt
nnoremap <C-h> gT

" qf
nnoremap <C-k> :cn<CR>zz
nnoremap <C-j> :cp<CR>zz

" command
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" tools
nnoremap tr :%s///gn<CR>``cgn
nnoremap tR :%s///gn<CR>``cgN

" leader keys
let mapleader = " "

" lf
nnoremap <leader><C-k> :lnext<CR>zz
nnoremap <leader><C-j> :lprevious<CR>zz

" toggles
nnoremap <leader>th :set hls!<CR>
nnoremap <leader>tw :set wrap!<CR>
nnoremap <leader>tn :set relativenumber!<CR>
nnoremap <leader>tp :set paste!<CR>

" tools
" This man is a legend https://github.com/itchyny/dotfiles/blob/main/.vimrc
nnoremap <expr> ,d ":\<C-u>".(&diff?"diffoff":"diffthis")."\<CR>"
nnoremap <leader>- :Ex<CR>
vnoremap <leader>T :s/\s\+$//e<LEFT><CR>
xnoremap <leader>y "+y

" extras
" thanks to https://github.com/karoliskoncevicius/oldbook-vim/blob/master/colors/oldbook.vim
hi DiffAdd ctermbg=72 ctermfg=238 cterm=NONE guibg=#5bb899 guifg=#3c4855 gui=NONE
hi DiffDelete ctermbg=167 ctermfg=238 cterm=NONE guibg=#db6c6c guifg=#3c4855 gui=NONE
hi DiffChange ctermbg=238 ctermfg=178 cterm=UNDERLINE guibg=#3c4855 guifg=#d5bc02 gui=UNDERLINE
hi DiffText ctermbg=178 ctermfg=238 cterm=NONE guibg=#d5bc02 guifg=#3c4855 gui=NONE

" undo
let $UNDO_DATA = $HOME . '/.vim/undo'
if version >= 703
    silent !mkdir -p $UNDO_DATA
    set undofile undodir=$UNDO_DATA
endif

" session
set sessionoptions=buffers,tabpages,options,folds

autocmd VimEnter * if argc() == 0 | call LoadSession() | endif
autocmd VimLeave * : call NewSession()

let $SESSION_DATA = $HOME . '/.vim/sessions'
function NewSession()
    silent !mkdir -p $SESSION_DATA
    let dir = substitute(getcwd(), '\/', '_', 'g')
    execute 'mksession! ' .$SESSION_DATA .'/'. dir
endfunction

function LoadSession()
    let dir = substitute(getcwd(), '\/', '_', 'g')
    let session_file = $SESSION_DATA .'/'. dir
    if filereadable(session_file)
        execute 'so ' . session_file
    endif
endfunction
