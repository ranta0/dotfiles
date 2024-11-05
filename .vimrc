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
nnoremap ,r :Scratch<CR>:%!
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
nnoremap <leader>sf :GitFiles <space>
nnoremap <leader>gs :GitStatus <space>
nnoremap <leader>sh :AllFiles <space>
nnoremap <leader>? :MRUFiles <space>
nnoremap <leader><leader> :b <space>
nnoremap <leader>- :Ex<CR>
xnoremap <leader>y "+y
nnoremap <leader>p "+p
nnoremap <silent> <leader>dm :delmarks A-Z<CR>

" functions
function! Fuzzy(files, search)
    if empty(a:search) || v:version < 900 | return a:files | endif
    return matchfuzzy(a:files, a:search)
endfunction
function! MRUFiles(arg, ...)
    return Fuzzy(copy(v:oldfiles)->filter('filereadable(fnamemodify(v:val, ":p"))')->map('fnamemodify(v:val, ":~:.")'), a:arg)
endfunction
function! AllFiles(arg, ...)
    return Fuzzy(systemlist('find . -type f -not -path "*.git*/*" -not -path "*vendor*/*" -not -path "*node_modules*/*" -not -path "*dist*/*"'), a:arg)
endfunction
function! GitFiles(arg, ...)
    return Fuzzy(systemlist("git ls-files"), a:arg)
endfunction
function! GitStatus(arg, ...)
    return Fuzzy(systemlist("git status -s"), a:arg)
endfunction

function! ShellCommandOutput(command) abort
    if bufexists('logshell') | call deletebufline('logshell', 1, '$') | endif

    let job_command = [&shell, &shellcmdflag, escape(a:command, '\')]
    if has("win32") | let job_command = a:command | endif

    let logjob = job_start(job_command,
                \ {'out_io': 'buffer', 'err_io': 'buffer', 'out_name': 'logshell', 'err_name': 'logshell', 'out_msg': ''})

    let winnr = win_getid()
    buffer logshell
    if win_getid() != winnr | win_gotoid(winnr) | endif
endfunction
" end functions

" commands
command! Scratch if bufexists('scratch') | buffer scratch | else
            \ | noswapfile hide enew | setlocal bt=nofile bh=hide | file scratch | endif

if !has('nvim')
    command! -complete=shellcmd -nargs=+ Sh call ShellCommandOutput(<q-args>)
endif

command! -nargs=1 -complete=customlist,MRUFiles MRUFiles edit <args>
command! -nargs=1 -complete=customlist,AllFiles AllFiles edit <args>
command! -nargs=1 -complete=customlist,GitFiles GitFiles edit <args>
command! -nargs=1 -complete=customlist,GitStatus GitStatus let parts = split("<args>", ' ') |
            \ if parts[1] == '' | execute 'e' parts[2] | else | execute 'e' parts[1] | endif

let g:grep= 'grep -rnH --exclude-dir=.git --exclude-dir=node_modules --exclude-dir=vendor --exclude-dir=dist'
command! -nargs=+ Grep cgetexpr system(g:grep . ' <args>') | copen
command! -nargs=+ Grepi cgetexpr system(g:grep . ' --ignore-case <args>') | copen

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
Plug 'lambdalisue/vim-fern'
Plug 'sedm0784/vim-resize-mode'
if !has('nvim')
    Plug 'markonm/traces.vim'
    Plug 'joshdick/onedark.vim'
    Plug 'leafOfTree/vim-vue-plugin'
else
    Plug 'navarasu/onedark.nvim'
    Plug 'nvim-treesitter/nvim-treesitter'
endif
call plug#end()

nnoremap <silent><expr> <leader>gl ":G log -L " . line(".") . ",+1:" . expand("%:p") ."<CR>"
vnoremap gbb :TCommentBlock<CR>
nnoremap <BS> :Fern %:h<CR>

let g:fern#hide_cursor = 1
let g:fern#default_hidden = 1
function! FernInit() abort
    nmap <buffer> - <Plug>(fern-action-leave)
    nmap <buffer> <TAB> <Plug>(fern-action-mark)
    nmap <buffer> % <Plug>(fern-action-new-file)
    nmap <buffer> d <Plug>(fern-action-new-dir)
    nmap <buffer> D <Plug>(fern-action-remove)
endfunction
augroup fern | autocmd!
    autocmd FileType fern call FernInit()
augroup END

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
nmap go <Plug>(coc-git-chunkinfo)
omap ig <Plug>(coc-git-chunk-inner)
xmap ig <Plug>(coc-git-chunk-inner)

command! -nargs=0 Prettier CocCommand prettier.formatFile
command! -nargs=? Fold :call CocAction('fold', <f-args>)

autocmd Filetype vue setlocal iskeyword+=-
