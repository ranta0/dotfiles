unlet! skip_defaults_vim
so $VIMRUNTIME/defaults.vim
au! vimHints
let &t_SI = "\<Esc>[6 q"
let &t_EI = "\<Esc>[2 q"

set nohidden autoread hls ignorecase smartcase list listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set updatetime=50 lazyredraw ttyfast nowrap ts=4 sw=4 et sta ai wildoptions=pum ve=block belloff=all
let $UNDO_DATA = $HOME . '/.vim/undo'
set undodir=$UNDO_DATA undofile nobackup noswapfile laststatus=2 signcolumn=yes
set t_Co=256 background=dark termguicolors

noremap k gk
noremap j gj
nnoremap ]q :<C-u>cn<CR>
nnoremap [q :<C-u>cN<CR>
nnoremap ,w :<C-u>set wrap! wrap?<CR>
nnoremap ,s :<C-u>set spell! spell?<CR>
nnoremap ,r :<C-u>Scratch<CR>
nnoremap \\ <C-^>
nnoremap <expr> ,d ":" . (&diff ? "diffoff" : "diffthis") . "<CR>"
nnoremap <expr><silent> m ":mark " . toupper(getcharstr()) . "<CR>"
nnoremap <expr><silent> ' ":normal! `" . toupper(getcharstr()) . "<CR>'\""
nnoremap <silent> g] :<C-u>Grep <C-R><C-w><CR>
cnoremap <expr> <space> getcmdtype() =~ '[/?]' ? '.\{-}' : "<space>"

let mapleader = " "
nnoremap <silent> - :Ex<CR>
xnoremap <leader>y "+y
nnoremap <leader>p "+p
nnoremap <silent> <leader>/ :nohls<CR>

command! Scratch if bufexists('scratch') | buffer scratch | else
            \ | enew | setlocal bt=nofile bh=hide noswapfile nowritebackup noundofile noautoread ff=unix fenc=utf-8 | file scratch | endif
command! RemoveWhiteSpaces if mode() ==# 'n' | silent! keeppatterns keepjumps execute 'undojoin | %s/[ \t]\+$//g' | update | endif
command! -nargs=+ Grep cgetexpr system('git grep -rnH <args> ') | copen
command! -nargs=0 OldFiles cgetexpr map(v:oldfiles, 'v:val . ":1:0"') | copen
command! -nargs=0 Marks cgetexpr map(getmarklist(), 'v:val.file . ":" . v:val.pos[2] . ":" . v:val.mark') | copen | winc p
if executable('rg')
    command! -nargs=+ Grep cgetexpr system('rg --vimgrep --hidden --no-heading --color=never --no-ignore <args> ') | copen
endif

augroup vimrc | autocmd!
    autocmd filetype qf nnoremap <silent><buffer> i <CR>:cclose<CR>:lclose<CR>
    autocmd Syntax * syntax sync fromstart
    autocmd OptionSet shiftwidth execute 'setlocal listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+,leadmultispace:\|' . repeat('\ ', &sw - 1)
    autocmd ColorScheme * set fillchars+=stl:-,stlnc:-
                \ | hi StatusLine   cterm=bold guibg=NONE guifg=#c0c0c0
                \ | hi StatusLineNC cterm=NONE guibg=NONE guifg=#c0c0c0
                \ | hi! link CurSearch IncSearch
                \ | hi! link VertSplit StatusLineNC
                \ | hi! link EndOfBuffer Normal
                \ | hi! link SignColumn Normal
augroup end
colorscheme slate

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
Plug 'Ashik80/VimExplorer'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'joshdick/onedark.vim'
call plug#end()
colorscheme onedark

nnoremap <silent> <leader>gs :G <CR>
nnoremap <silent> <leader>sh :FZF -i <CR>
nnoremap <silent> <leader>u :UndotreeToggle<CR>:UndotreeFocus<CR>

let g:vimexplorer_show_hidden = 1
let g:vimexplorer_detail = 0
nnoremap - :VimExplorer<CR>
nnoremap <silent> <leader>- :VimExplorerCwd<CR>

" coc
let g:coc_enable_locationlist = 0
let g:coc_global_extensions = [
            \ 'coc-lists',
            \ 'coc-marketplace',
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
nmap <silent> ]d <Plug>(coc-diagnostic-next)
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> <expr> [c &diff ? '[c' : '<Plug>(coc-git-prevchunk)'
nmap <silent> <expr> ]c &diff ? ']c' : '<Plug>(coc-git-nextchunk)'
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
