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
cnoremap <expr> <space> getcmdtype() =~ '[/?]' ? '.\{-}' : "<space>"
for ch in 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    exe $'nnoremap <silent> m{tolower(ch)} m{ch}'
    exe $"nnoremap <silent> '{tolower(ch)} `{ch}"
endfor

let mapleader = " "
nmap <silent> <leader>/ :let @/ = ""<CR>
nnoremap <leader>sh :AllFiles <space>
nnoremap <leader>? :MRUFiles <space>
nnoremap <leader><leader> :b <space>
nnoremap <silent> <expr> <leader>jsh ":Scratch<CR>:%!" . g:findcmd . "<CR><CR>"
nnoremap <silent> - :Ex<CR>
nnoremap <silent><expr> <leader>- ":e " . g:root_dir . "<CR>"
xnoremap <leader>y "+y
nnoremap <leader>p "+p
nnoremap <silent> <leader>dm :delmarks A-Z<CR>

let g:root_dir = getcwd()
augroup vimrc | autocmd!
    autocmd BufEnter * if &filetype !=# 'netrw' | exec "lcd " . g:root_dir | endif
    autocmd filetype netrw hi! link netrwMarkFile ErrorMsg
augroup end
let g:netrw_keepdir = 0
let g:netrw_localcopydircmd = 'cp -r'

" functions
let g:findcmd = 'find ' . g:root_dir . ' -type f -not -path "*vendor*/*" -not -path "*node_modules*/*" -not -path "*dist*/*"'
if has("win32") | let g:findcmd = 'dir /s /b /a-d ' . g:root_dir | endif

function! Fuzzy(files, search)
    let files = a:files->map('fnamemodify(v:val, ":~:.")')
    if empty(a:search) | return a:files | endif
    if v:version < 900
        return copy(a:files)->filter('v:val =~ a:search')
    else
        return matchfuzzy(a:files, a:search)
    endif
endfunction
function! MRUFiles(arg, ...)
    return Fuzzy(copy(v:oldfiles)->filter('filereadable(fnamemodify(v:val, ":p"))'), a:arg)
endfunction
function! AllFiles(arg, ...)
    return Fuzzy(systemlist(g:findcmd)->map('substitute(v:val, "\r", "", "")'), a:arg)
endfunction
" end functions

" commands
command! Scratch if bufexists('scratch') | buffer scratch | else
            \ | enew | setlocal bt=nofile bh=hide noswapfile nowritebackup noundofile noautoread ff=unix fenc=utf-8 | file scratch | endif

command! -nargs=1 -complete=customlist,MRUFiles MRUFiles edit <args>
command! -nargs=1 -complete=customlist,AllFiles AllFiles edit <args>

let g:grep = 'grep -rnH --exclude-dir=.git --exclude-dir=node_modules --exclude-dir=vendor --exclude-dir=dist'
let g:grep_dir = g:root_dir
if has("win32") | let g:grep = 'findstr /s /n /i' | let g:grep_dir = '"'.g:root_dir.'\*"' | endif
command! -nargs=+ Grep cgetexpr system(g:grep . ' <args> ' . g:grep_dir) | copen

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
if has('nvim')
    Plug 'navarasu/onedark.nvim'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'williamboman/mason.nvim'
    Plug 'williamboman/mason-lspconfig.nvim/'
    Plug 'neovim/nvim-lspconfig'
    Plug 'echasnovski/mini.completion'
    Plug 'stevearc/oil.nvim'
endif
call plug#end()

nnoremap <silent> <leader>gs :G <CR>
vnoremap <silent> gbb :TCommentBlock<CR>
nnoremap <silent> <expr> <leader>sh ":FZF " . g:root_dir . "<CR>"
nmap ]c <Plug>(GitGutterNextHunk)
nmap [c <Plug>(GitGutterPrevHunk)
