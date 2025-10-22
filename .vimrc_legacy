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

noremap k gk
noremap j gj
noremap <C-d> <C-d>zz
noremap <C-u> <C-u>zz
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
    autocmd Syntax * syntax sync fromstart
augroup end
let g:netrw_keepdir = 0
let g:netrw_localcopydircmd = 'cp -r'

" commands
command! Scratch if bufexists('scratch') | buffer scratch | else
            \ | enew | setlocal bt=nofile bh=hide noswapfile nowritebackup noundofile noautoread ff=unix fenc=utf-8 | file scratch | endif

command! -nargs=+ Grep cgetexpr system('git grep -rnH <args> ') | copen
command! -nargs=0 Files cgetexpr map(systemlist('git ls-files -co --exclude-standard'), 'v:val . ":1:0"') | copen
command! -nargs=0 OldFiles cgetexpr map(v:oldfiles, 'v:val . ":1:0"') | copen
if executable('rg')
    command! -nargs=+ Grep cgetexpr system('rg --vimgrep --hidden --no-heading --color=never --no-ignore <args> ') | copen
endif

command! RemoveWhiteSpaces if mode() ==# 'n' | silent! keeppatterns keepjumps execute 'undojoin | %s/[ \t]\+$//g' | update | endif
" end commands

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'tpope/vim-fugitive'
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
else
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'joshdick/onedark.vim'
endif
call plug#end()

nnoremap <silent> <leader>gs :G <CR>
vnoremap <silent> gbb :TCommentBlock<CR>
nnoremap <silent> <expr> <leader>sh ":FZF -i " . g:root_dir . "<CR>"
nnoremap <silent> <leader>u :UndotreeToggle<CR>:UndotreeFocus<CR>

" coc
if !has('nvim')
    " screenshare mode
    nnoremap <silent> <leader>s :set cuc cul<CR>:colo onedark<CR>

    let g:coc_enable_locationlist = 0
    let g:coc_global_extensions = [
                \ 'coc-git',
                \ 'coc-json',
                \ 'coc-yaml',
                \ 'coc-prettier',
                \ 'coc-explorer',
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
    nnoremap <silent> <expr> <leader>- ":CocCommand explorer " . g:root_dir . "<CR>"

    autocmd Filetype vue setlocal iskeyword+=-
endif
