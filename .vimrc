filetype plugin indent on
syntax enable

" cursor modes
let &t_SI = "\<Esc>[6 q"
let &t_EI = "\<Esc>[2 q"

set encoding=utf-8 fileencoding=utf-8 fileformats=unix,mac,dos fileencodings=utf-8,latin
set number relativenumber nowrap
set tabstop=4 shiftwidth=4 expandtab smarttab autoindent smartindent scrolloff=8
set nohidden autoread
set list listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set hlsearch incsearch
set showcmd noruler laststatus=2 shortmess-=S signcolumn=yes
set statusline=%<%.99f\ %h%w%m%r%=%y\ %{&fenc!=#''?&fenc:'none'}\ %{&ff}\ %P
set path=.,,
set wildmenu
if v:version >= 900 && !has('nvim') | set wildoptions=pum | endif
set wildignore=*.~,*.?~,*.o,*.sw?,*.bak,*.hi,*.pyc,*.out suffixes=*.pdf
set updatetime=50 lazyredraw ttyfast ttimeoutlen=50

let $UNDO_DATA = (has('nvim') ? $HOME . '/.vim/undodir' : $HOME . '/.vim/undo')
if v:version >= 703 && !has('nvim') && !isdirectory($UNDO_DATA)
    silent !mkdir -p $UNDO_DATA
endif
set undodir=$UNDO_DATA undofile nobackup noswapfile

set grepprg=grep\ -rnH\ --exclude-dir=.git\ --exclude-dir=node_modules\ --exclude-dir=vendor
set grepformat=%f:%l:%m

let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set background=dark
set termguicolors
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
" toggles
nnoremap ,n :set relativenumber!<CR>
nnoremap ,w :set wrap!<CR>
nnoremap ,p :set paste!<CR>
nnoremap <expr> ,d ":" . (&diff ? "diffoff" : "diffthis") . "<CR>"
" nope
nnoremap Q <nop>
nnoremap gQ <nop>

" leader keys
let mapleader = " "
nmap <silent> <leader>/ :let @/ = ""<CR>
nnoremap <leader>sf :GitFiles <space>
nnoremap <leader>sh :AllFiles <space>
nnoremap <leader>? :MRUFiles <space>
nnoremap <leader><leader> :BufFiles <space>
nnoremap <leader>- :Ex<CR>
xnoremap <leader>y "+y

for ch in 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    exe $'nnoremap <silent> m{tolower(ch)} m{ch}'
    exe $"nnoremap <silent> '{tolower(ch)} `{ch}"
endfor
nnoremap <silent> <leader>dm :delmarks A-Z<CR>

" functions
function! Fuzzy(files, search)
    if empty(a:search) && v:version < 900 | return a:files | endif
    return matchfuzzy(a:files, a:search)
endfunction
function! MRUFiles(arg, ...)
    return Fuzzy(copy(v:oldfiles)->map('fnamemodify(v:val, ":~:.")'), a:arg)
endfunction
function! AllFiles(arg, ...)
    return Fuzzy(systemlist("find . -type f 2>&1"), a:arg)
endfunction
function! GitFiles(arg, ...)
    return Fuzzy(systemlist("git ls-files"), a:arg)
endfunction
function! BufFiles(arg, ...)
    return Fuzzy(map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), 'fnamemodify(bufname(v:val), ":~:.")'), a:arg)
endfunction
" end functions

" commands
command! Scratch if bufexists('scratch') | buffer scratch | else
            \ | noswapfile hide enew | setlocal bt=nofile bh=hide | file scratch | endif

command! -nargs=1 -complete=customlist,MRUFiles MRUFiles edit <args>
command! -nargs=1 -complete=customlist,AllFiles AllFiles edit <args>
command! -nargs=1 -complete=customlist,GitFiles GitFiles edit <args>
command! -nargs=1 -complete=customlist,BufFiles BufFiles edit <args>

command! -nargs=+ Grep cgetexpr system(&grepprg . ' <args>') | copen
command! -nargs=+ Grepi cgetexpr system(&grepprg . ' --ignore-case <args>') | copen

highlight ExtraWhitespace ctermbg=red guibg=red | match ExtraWhitespace /\s\+$/
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red | match ExtraWhitespace /\s\+$/
command! RemoveWhiteSpaces if mode() ==# 'n' | silent! keeppatterns keepjumps execute 'undojoin | %s/[ \t]\+$//g' | update | endif
" end commands

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-sleuth'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'francoiscabrol/ranger.vim'
Plug 'habamax/vim-godot'
if !has('nvim')
    Plug 'markonm/traces.vim'
    Plug 'joshdick/onedark.vim'
    Plug 'leafOfTree/vim-vue-plugin'
else
    Plug 'rbgrouleff/bclose.vim'
    Plug 'navarasu/onedark.nvim'
    Plug 'nvim-treesitter/nvim-treesitter'
endif
call plug#end()

silent! colorscheme onedark
let g:ranger_replace_netrw = 0
let g:ranger_command_override = 'ranger --cmd "set show_hidden=true"'

" fuzzy finders, override the standard ones
let $FZF_DEFAULT_OPTS = '--ignore-case'
let g:fzf_vim = {}
let g:fzf_vim.preview_window = []
nnoremap <leader>sf :GFiles<CR>
nnoremap <leader>sh :Files<CR>
nnoremap <leader>? :History<CR>
nnoremap <leader>gs :GFiles?<CR>
nnoremap <leader>sm :Marks<CR>
nnoremap <leader><leader> :Buffers<CR>

" coc
let g:coc_enable_locationlist = 0
let g:coc_global_extensions = [
            \ 'coc-git',
            \ 'coc-json',
            \ 'coc-yaml',
            \ 'coc-prettier',
            \ ]

inoremap <silent><expr> <TAB>
            \ coc#pum#visible() ? coc#pum#next(1) :
            \ CheckBackspace() ? "\<Tab>" :
            \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
            \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
function! CheckBackspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction
inoremap <silent><expr> <c-@> coc#refresh()

nmap <silent> <leader>gd <Plug>(coc-definition)
nmap <silent> <leader>gy <Plug>(coc-type-definition)
nmap <silent> <leader>gi <Plug>(coc-implementation)
nmap <silent> <leader>gr <Plug>(coc-references)
nmap <silent> <leader>ca <Plug>(coc-codeaction-refactor)
nmap <silent> <leader>mf :call CocActionAsync('format')<CR>
nmap <leader>rn <Plug>(coc-rename)
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

nnoremap <silent> K :call CocActionAsync('doHover')<cr>
nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

nnoremap <silent><nowait> <leader>td  :<C-u>CocList diagnostics<cr>
nnoremap <silent><nowait> <leader>o   :<C-u>CocList -A outline -kind<CR>
nnoremap <silent><nowait> <leader>w   :<C-u>CocList -I -N symbols<CR>

nmap <silent> ]d <Plug>(coc-diagnostic-next)
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> <expr> [c &diff ? '[c' : '<Plug>(coc-git-prevchunk)'
nmap <silent> <expr> ]c &diff ? ']c' : '<Plug>(coc-git-nextchunk)'

command! -nargs=0 Prettier CocCommand prettier.formatFile
command! -nargs=? Fold :call CocAction('fold', <f-args>)

" commentstring
autocmd Filetype vue setlocal iskeyword+=-
autocmd FileType php setlocal commentstring=//\ %s
