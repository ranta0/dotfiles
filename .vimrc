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
Plug 'tpope/vim-sleuth'
Plug 'tomtom/tcomment_vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
if !has('nvim')
    Plug 'markonm/traces.vim'
    Plug 'joshdick/onedark.vim'
    Plug 'leafOfTree/vim-vue-plugin'
else
    Plug 'navarasu/onedark.nvim'
    Plug 'nvim-treesitter/nvim-treesitter'
endif
call plug#end()

nnoremap <silent> <leader>gs :G <CR>
vnoremap <silent> gbb :TCommentBlock<CR>
nnoremap <silent> <expr> <leader>sh ":FZF " . g:root_dir . "<CR>"

" coc
let g:coc_enable_locationlist = 0
let g:coc_global_extensions = [
            \ 'coc-git',
            \ 'coc-json',
            \ 'coc-yaml',
            \ 'coc-prettier',
            \ 'coc-tsserver',
            \ '@yaegassy/coc-volar',
            \ '@yaegassy/coc-intelephense',
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

nnoremap <silent> K :call CocActionAsync('doHover')<CR>
nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<CR>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<CR>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

nnoremap <silent><nowait> <leader>td  :<C-u>CocList diagnostics<CR>
nnoremap <silent><nowait> <leader>o   :<C-u>CocList -A outline -kind<CR>
nnoremap <silent><nowait> <leader>w   :<C-u>CocList -I -N symbols<CR>

nmap <silent> ]d <Plug>(coc-diagnostic-next)
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> <expr> [c &diff ? '[c' : '<Plug>(coc-git-prevchunk)'
nmap <silent> <expr> ]c &diff ? ']c' : '<Plug>(coc-git-nextchunk)'

command! -nargs=0 Prettier CocCommand prettier.formatFile

autocmd Filetype vue setlocal iskeyword+=-
