filetype plugin indent on
syntax enable

set encoding=utf-8 fileencoding=utf-8 fileformats=unix,mac,dos fileencodings=utf-8,latin
set nohidden autoread hlsearch incsearch list listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set nowrap showmode laststatus=2 signcolumn=yes statusline=%<%.99f\ %h%w%m%r%=%y\ %{&fenc!=#''?&fenc:'none'}\ %{&ff}\ %P
set path=.,, wildmenu wildoptions=pum updatetime=50 lazyredraw ttyfast ttimeoutlen=50
set tabstop=4 shiftwidth=4 expandtab smarttab autoindent smartindent scrolloff=8
let $UNDO_DATA = $HOME . '/.vim/undo'
set undodir=$UNDO_DATA undofile nobackup noswapfile

let &t_SI = "\<Esc>[6 q"
let &t_EI = "\<Esc>[2 q"
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set background=dark termguicolors
colorscheme habamax

noremap k gk
noremap j gj
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
nnoremap <silent> <leader>- :e .<CR>
xnoremap <leader>y "+y
nnoremap <leader>p "+p
nnoremap <silent> <leader>md :delmarks A-Z<CR>

augroup vimrc | autocmd!
    autocmd filetype qf nnoremap <silent><buffer> i <CR>:cclose<CR>
    autocmd Syntax * syntax sync fromstart
augroup end

" commands
command! Scratch if bufexists('scratch') | buffer scratch | else
            \ | enew | setlocal bt=nofile bh=hide noswapfile nowritebackup noundofile noautoread ff=unix fenc=utf-8 | file scratch | endif

command! -nargs=+ Grep cgetexpr system('git grep -rnH <args> ') | copen
command! -nargs=0 Files cgetexpr map(systemlist('git ls-files -co --exclude-standard'), 'v:val . ":1:0"') | copen
command! -nargs=0 OldFiles cgetexpr map(v:oldfiles, 'v:val . ":1:0"') | copen
if executable('rg')
    command! -nargs=+ Grep cgetexpr system('rg --vimgrep --hidden --no-heading --color=never --no-ignore <args> ') | copen
endif

" Build a regex pattern that matches groups separated by custom delimiters.
" Usage:
"   :RegexGroups 3, 2-
" Produces a pattern like: v^([^,]*,[^,]*,[^,]*),([^-]*-[^-]*)-(.*)
function! RegexGroups(...)
    let search = ""
    let max = 1
    for attr in a:000
        if max >= 9
            echoerr "too many args"
            break
        endif
        let number = matchstr(attr, '\v(\d+)')
        let delimiter = substitute(attr, '\v(\d+)', '', 'g')
        let matchable = '[^' . delimiter . ']*'
        let group = matchable
        if number != ''
            for i in range(1, number - 1)
                let group .= delimiter . matchable
            endfor
        endif
        let searchable = '(' . group . ')' . delimiter
        let max += 1
        let search .= searchable
    endfor
    if max <= 9
        let @/ = '\v^' . search . '(.*)'
    endif
endfunction

command! -nargs=+ RegexGroups call RegexGroups(<f-args>)

command! RemoveWhiteSpaces if mode() ==# 'n' | silent! keeppatterns keepjumps execute 'undojoin | %s/[ \t]\+$//g' | update | endif
" end commands

let data_dir = '~/.vim'
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
Plug 'lambdalisue/vim-fern'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'joshdick/onedark.vim'
call plug#end()

nnoremap <silent> <leader>gs :G <CR>
vnoremap <silent> gbb :TCommentBlock<CR>
nnoremap <silent> <leader>sh :FZF -i <CR>
nnoremap <silent> <leader>u :UndotreeToggle<CR>:UndotreeFocus<CR>
nnoremap <silent> <leader>S :set cuc cul nu<CR>:colo onedark<CR>
nnoremap - :Fern %:h<CR>
nnoremap <silent> <leader>- :Fern .<CR>

let g:fern#hide_cursor = 1
let g:fern#default_hidden = 1
augroup fern | autocmd!
    autocmd FileType fern nmap <buffer> - <Plug>(fern-action-leave)
    autocmd FileType fern nmap <buffer> <TAB> <Plug>(fern-action-mark)
    autocmd FileType fern nmap <buffer> % <Plug>(fern-action-new-file)
    autocmd FileType fern nmap <buffer> d <Plug>(fern-action-new-dir)
    autocmd FileType fern nmap <buffer> D <Plug>(fern-action-remove)
augroup end

" coc
let g:coc_enable_locationlist = 0
let g:coc_global_extensions = [
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
nmap <silent> ]d <Plug>(coc-diagnostic-next)
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nnoremap <silent><nowait> <leader>td  :<C-u>CocList diagnostics<CR>

nnoremap <silent> K :call CocActionAsync('doHover')<CR>
nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<CR>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<CR>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

command! -nargs=0 Prettier CocCommand prettier.formatFile

autocmd Filetype vue setlocal iskeyword+=-

