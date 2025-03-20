filetype plugin indent on
syntax enable

set encoding=utf-8 fileencoding=utf-8 fileformats=unix,mac,dos fileencodings=utf-8,latin
set nowrap tabstop=4 shiftwidth=4 expandtab smarttab autoindent smartindent scrolloff=8
set rnu nu nohidden autoread hlsearch incsearch
set list listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set showcmd noruler showmode laststatus=2 signcolumn=yes statusline=%<%.99f\ %h%w%m%r%=%y\ %{&fenc!=#''?&fenc:'none'}\ %{&ff}\ %P
set path=.,, wildmenu wildignore=*.~,*.?~,*.o,*.sw?,*.bak,*.hi,*.pyc,*.out suffixes=*.pdf
set updatetime=50 lazyredraw ttyfast ttimeoutlen=50
if v:version >= 900 | set wildoptions=pum | endif
if has('nvim') | set inccommand=split | endif

let $UNDO_DATA = (has('nvim') ? $HOME . '/.vim/undodir' : $HOME . '/.vim/undo')
set undodir=$UNDO_DATA undofile nobackup noswapfile

let &t_SI = "\<Esc>[6 q"
let &t_EI = "\<Esc>[2 q"
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set background=dark termguicolors
colorscheme habamax

nnoremap k gk
nnoremap j gj
vnoremap k gk
vnoremap j gj
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
vnoremap <C-d> <C-d>zz
vnoremap <C-u> <C-u>zz
nnoremap n nzzzv
nnoremap N Nzzzv
vnoremap <silent> > >gv
vnoremap <silent> < <gv
vnoremap $ $h
nnoremap ]q :cn<CR>
nnoremap [q :cp<CR>
nnoremap ,n :set rnu! nu! rnu?<CR>
nnoremap ,w :set wrap! wrap?<CR>
nnoremap ,p :set paste! paste?<CR>
nnoremap ,r :Scratch<CR>
nnoremap <expr> ,d ":" . (&diff ? "diffoff" : "diffthis") . "<CR>"
nnoremap Q <nop>
nnoremap gQ <nop>
nnoremap <silent> g] :<C-u>Grep <C-R><C-w><CR>
cnoremap <expr> <space> getcmdtype() =~ '[/?]' ? '.\{-}' : "<space>"
for ch in 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    exe $'nnoremap <silent> m{tolower(ch)} m{ch}'
    exe $"nnoremap <silent> '{tolower(ch)} `{ch}"
endfor

let mapleader = " "
nmap <silent> <leader>/ :let @/ = ""<CR>
nnoremap <leader>sh :Files<CR>
nnoremap <leader>? :OldFiles<CR>
nnoremap <leader><leader> :b <space>
nnoremap <silent> - :Ex<CR>
nnoremap <silent><expr> <leader>- ":e " . g:root_dir . "<CR>"
xnoremap <leader>y "+y
nnoremap <leader>p "+p
nnoremap <silent> <leader>dm :delmarks A-Z<CR>

let g:root_dir = getcwd()
augroup vimrc | autocmd!
    autocmd BufEnter * if &filetype !=# 'netrw' | exec "lcd " . g:root_dir | endif
    autocmd filetype netrw hi! link netrwMarkFile ErrorMsg
    autocmd filetype qf nnoremap <silent><buffer> i <CR>:cclose<CR>
augroup end
let g:netrw_keepdir = 0
let g:netrw_localcopydircmd = 'cp -r'

" commands
command! Scratch if bufexists('scratch') | buffer scratch | else
            \ | enew | setlocal bt=nofile bh=hide noswapfile nowritebackup noundofile noautoread ff=unix fenc=utf-8 | file scratch | endif

command! -nargs=+ Grep cgetexpr system('git grep -rnH <args> ') | copen
command! -nargs=0 Files cgetexpr map(systemlist('git ls-files -co --exclude-standard'), 'v:val . ":1:0"') | copen
command! -nargs=0 OldFiles cgetexpr map(v:oldfiles, 'v:val . ":1:0"') | copen

command! RemoveWhiteSpaces if mode() ==# 'n' | silent! keeppatterns keepjumps execute 'undojoin | %s/[ \t]\+$//g' | update | endif
" end commands

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-sleuth'
Plug 'tomtom/tcomment_vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'mbbill/undotree'
if has('nvim')
    Plug 'navarasu/onedark.nvim'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'williamboman/mason.nvim'
    Plug 'williamboman/mason-lspconfig.nvim/'
    Plug 'neovim/nvim-lspconfig'
    Plug 'echasnovski/mini.completion'
    Plug 'stevearc/oil.nvim'
    Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
endif
call plug#end()

nnoremap <silent> <leader>gs :G <CR>
vnoremap <silent> gbb :TCommentBlock<CR>
nnoremap <silent> <expr> <leader>sh ":FZF -i " . g:root_dir . "<CR>"
nnoremap <silent> <leader>u :UndotreeToggle<CR>:UndotreeFocus<CR>
nmap ]c <Plug>(GitGutterNextHunk)
nmap [c <Plug>(GitGutterPrevHunk)
