filetype plugin indent on
syntax enable

set encoding=utf-8 fileencoding=utf-8 fileformats=unix,mac,dos fileencodings=utf-8,latin
set nohidden autoread hlsearch incsearch list listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+,leadmultispace:\|\ \ \ ,
set nowrap showcmd showmode laststatus=2 signcolumn=yes statusline=%<%.99f\ %h%w%m%r%=%y\ %{&fenc!=#''?&fenc:'none'}\ %{&ff}\ %P
set path=.,, wildmenu wildoptions=pum updatetime=50 lazyredraw ttyfast ttimeoutlen=50
set tabstop=4 shiftwidth=4 expandtab smarttab autoindent smartindent scrolloff=8
let $UNDO_DATA = $HOME . '/.vim/undo'
set undodir=$UNDO_DATA undofile nobackup noswapfile

let &t_SI = "\<Esc>[6 q"
let &t_EI = "\<Esc>[2 q"
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
let &t_BE = "\e[?2004h"
let &t_BD = "\e[?2004l"
exec "set t_PS=\e[200~"
exec "set t_PE=\e[201~"
set t_Co=256
set background=light termguicolors
colorscheme slate

noremap k gk
noremap j gj
nnoremap ,w :set wrap! wrap?<CR>
nnoremap ,r :Scratch<CR>
nnoremap <expr> ,d ":" . (&diff ? "diffoff" : "diffthis") . "<CR>"
nnoremap Q <nop>
nnoremap gQ <nop>
nnoremap <silent> g] :<C-u>Grep <C-R><C-w><CR>
cnoremap <expr> <space> getcmdtype() =~ '[/?]' ? '.\{-}' : "<space>"

let mapleader = " "
nmap <silent> <leader>/ :let @/ = ""<CR>
nnoremap <leader>sh :Files<CR>
nnoremap <leader>? :OldFiles<CR>
nnoremap <leader><leader> :b <space>
nnoremap <silent> - :Ex<CR>
nnoremap <silent> <leader>- :e .<CR>
xnoremap <leader>y "+y
nnoremap <leader>p "+p

augroup vimrc | autocmd!
    autocmd filetype qf nnoremap <silent><buffer> i <CR>:cclose<CR>
    autocmd Syntax * syntax sync fromstart
    autocmd OptionSet <buffer> shiftwidth let &lcs = 'tab:> ,trail:-,extends:>,precedes:<,nbsp:+,leadmultispace:|' . repeat(' ', &sw - 1)
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

" colors
hi Cursor       ctermfg=234 ctermbg=252 guibg=#c6c8d1 guifg=#161821
hi Visual       ctermfg=NONE ctermbg=236 cterm=NONE guibg=#272c42 guifg=NONE
hi VertSplit    ctermbg=233 ctermfg=233 cterm=NONE guibg=#0f1117 guifg=#0f1117 gui=NONE
hi StatusLine   ctermbg=234 ctermfg=245 cterm=reverse guibg=#17171b guifg=#818596 gui=reverse term=reverse
hi StatusLineNC ctermbg=238 ctermfg=233 cterm=reverse guibg=#3e445e guifg=#0f1117 gui=reverse
hi PmenuSel     ctermbg=240 ctermfg=255 guibg=#5b6389 guifg=#eff0f4
hi Directory    ctermfg=109 guifg=#89b8c2
hi Folded       ctermbg=235 ctermfg=245 guibg=#1e2132 guifg=#686f9a
hi Normal       ctermbg=234 ctermfg=252 guibg=#161821 guifg=#c6c8d1
hi Comment      ctermfg=242 guifg=#6b7089
hi MatchParen   ctermfg=203 ctermbg=NONE cterm=underline guifg=#ff6541 guibg=NONE gui=underline
hi Search       ctermfg=231 ctermbg=197 cterm=NONE guifg=#f8f8f0 guibg=#f92672 gui=NONE
hi IncSearch    ctermfg=231 ctermbg=197 cterm=underline guifg=#f8f8f0 guibg=#f92672 gui=underline
hi SpecialKey   ctermfg=240 ctermbg=NONE cterm=NONE guifg=#585858 guibg=NONE gui=NONE
hi! link TabLine StatusLine
hi! link TabLineFill StatusLine
hi! link TabLineSel PmenuSel
hi! link EndOfBuffer Normal
hi! link SignColumn Normal
hi! link Pmenu Visual
hi! link PmenuThumb Search
hi! link CurSearch IncSearch
hi! link StatusLineTerm StatusLine
hi! link StatusLineTermNC StatusLineNC

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
Plug 'habamax/vim-dir'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'joshdick/onedark.vim'
call plug#end()

nnoremap <silent> <leader>gs :G <CR>
vnoremap <silent> gbb :TCommentBlock<CR>
nnoremap <silent> <leader>sh :FZF -i <CR>
nnoremap <silent> <leader>u :UndotreeToggle<CR>:UndotreeFocus<CR>
nnoremap <silent> <leader>S :set cuc cul nu<CR>:colo onedark<CR>
nnoremap - :Dir<CR>
nnoremap <silent> <leader>- :Dir .<CR>

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
