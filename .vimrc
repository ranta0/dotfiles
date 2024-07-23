filetype plugin indent on
syntax enable

set encoding=utf-8 fileencoding=utf-8 fileformats=unix,mac,dos
set fileencodings=utf-8,latin
set termguicolors

set number relativenumber nowrap
set tabstop=4 shiftwidth=4 expandtab smarttab autoindent smartindent
set scrolloff=8

set nohidden autoread

set list listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set hlsearch incsearch

set showcmd noruler laststatus=2
set statusline=[%n]\ %<%.99f\ %h%w%m%r%=%y\ %{&fenc!=#''?&fenc:'none'}\ %{&ff}\ %P

set path=.,,
set wildmenu
if v:version >= 900 | set wildoptions=pum | endif
set wildignore=*.~,*.?~,*.o,*.sw?,*.bak,*.hi,*.pyc,*.out suffixes=*.pdf

set nobackup noswapfile
set updatetime=50 lazyredraw ttyfast
set ttimeoutlen=50

set grepprg=grep\ -rnH\ --exclude-dir={.git,node_modules,vendor}
set grepformat=%f:%l:%m

" undo
let $UNDO_DATA = $HOME . '/.vim/undo'
if v:version >= 703
    silent !mkdir -p $UNDO_DATA
    set undofile undodir=$UNDO_DATA
endif

" cursor modes
let &t_SI = "\<Esc>[6 q"
let &t_EI = "\<Esc>[2 q"

" nice to have
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
nnoremap Q <nop>
nnoremap gQ <nop>
nnoremap <F1> <esc>
nnoremap ]w <C-w>w
nnoremap [w <C-w>W

" tabs
nnoremap <silent> <C-t> :tabnew<CR>
nnoremap <C-l> gt
nnoremap <C-h> gT

" completion
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" qf
nnoremap <C-k> :cn<CR>
nnoremap <C-j> :cp<CR>
nnoremap ]q :lnext<CR>
nnoremap [q :lprevious<CR>

" tools
nnoremap tr *Ncgn

" toggles
nnoremap ,h :set hls!<CR>
nnoremap ,n :set relativenumber!<CR>
nnoremap ,w :set wrap!<CR>
nnoremap ,p :set paste!<CR>
nnoremap <expr> ,d ":\<C-u>".(&diff?"diffoff":"diffthis")."\<CR>"

" leader keys
let mapleader = ' '

" tools
nmap <silent> <leader>/ :let @/ = ""<CR>
nnoremap <leader>sf :find *
nnoremap <leader>sh :AllFiles <space>
nnoremap <leader>? :OldFiles <space>
nnoremap <leader>- :Ex<CR>
vnoremap <leader>T :s/\s\+$//e<LEFT><CR>
xnoremap <leader>y "+y
nnoremap <leader>f :call g:RangerExplorer()<CR>
nnoremap <leader>sg :call QFGrep(1)<CR>
nnoremap <leader>sG :call QFGrep(0)<CR>
nnoremap <silent> <leader>cd :lcd%:p:h<CR>:call g:SetPath()<CR>:pwd<CR>
nnoremap <leader><leader> :b *

" theme
" thanks to https://github.com/karoliskoncevicius/oldbook-vim/blob/master/colors/oldbook.vim
colorscheme slate
if v:version >= 900 | colorscheme habamax | endif
hi DiffAdd          ctermbg=72   ctermfg=238  cterm=NONE        guibg=#5bb899 guifg=#3c4855 gui=NONE
hi DiffDelete       ctermbg=167  ctermfg=238  cterm=NONE        guibg=#db6c6c guifg=#3c4855 gui=NONE
hi DiffChange       ctermbg=238  ctermfg=178  cterm=UNDERLINE   guibg=#3c4855 guifg=#d5bc02 gui=UNDERLINE
hi DiffText         ctermbg=178  ctermfg=238  cterm=NONE        guibg=#d5bc02 guifg=#3c4855 gui=NONE
hi link diffBDiffer        WarningMsg
hi link diffCommon         WarningMsg
hi link diffDiffer         WarningMsg
hi link diffIdentical      WarningMsg
hi link diffIsA            WarningMsg
hi link diffNoEOL          WarningMsg
hi link diffOnly           WarningMsg
hi link diffRemoved        WarningMsg
hi link diffAdded          String
" end theme

" functions
function! g:QFGrep(ignore_case)
  let l:search_pattern = input('Grep > ')
  let l:cmd = 'silent grep! '.l:search_pattern
  if a:ignore_case
    let l:cmd = l:cmd . ' --ignore-case'
  endif
  if !empty(l:search_pattern)
    execute l:cmd
    redraw!
    copen
  endif
endfunction

function! g:RangerExplorer()
    let tmpfile = tempname()
    let l:cmd = 'silent !ranger --cmd "set show_hidden=true" --choosefile=' . tmpfile . ' ' . shellescape(expand('%:p:h'))
    execute l:cmd

    if filereadable(tmpfile)
        let filepath = readfile(tmpfile)[0]
        execute 'edit ' . fnameescape(filepath)
        call delete(tmpfile)
    else
        echohl ErrorMsg | echo 'No file chosen or ranger command failed' | echohl None
    endif

    redraw!
endfunction

" copied recent_files from https://github.com/junegunn/fzf.vim
function! g:Buflisted()
    function! s:sort_buffers(...)
        let [b1, b2] = map(copy(a:000), 'get(g:buffers, v:val, v:val)')
        return b1 < b2 ? 1 : -1
    endfunction

    function! s:buflisted()
        return filter(range(1, bufnr('$')), 'buflisted(v:val) && getbufvar(v:val, "&filetype") != "qf"')
    endfunction

    return sort(s:buflisted(), 's:sort_buffers')
endfunction

function! g:OldFiles(a,...)
    function! s:unique(list)
        let visited = {}
        let ret = []
        for l in a:list
            if !empty(l) && !has_key(visited, l)
                call add(ret, l)
                let visited[l] = 1
            endif
        endfor
        return ret
    endfunction

    let l:recent_files = s:unique(map(
                \ filter([expand('%')], 'len(v:val)')
                \   + filter(map(g:Buflisted(), 'bufname(v:val)'), 'len(v:val)')
                \   + filter(copy(v:oldfiles), "filereadable(fnamemodify(v:val, ':p'))"),
                \ 'fnamemodify(v:val, ":~:.")'))

    return copy(l:recent_files)->filter('v:val =~ a:a')
endfunction
" end recent files

function! g:AllFiles(a,...)
    let l:result = system("find . -type f 2>&1 | grep -v 'Permission denied'")
    let l:files = split(l:result, "\n")
    if v:version >= 900
        return matchfuzzy(l:files, a:a)
    else
        return copy(l:files)->filter('v:val =~ a:a')
    endif
endfunction

function! g:SetPath()
    if isdirectory('.git')
        silent! let &path .= join(systemlist('git ls-tree -d --name-only -r HEAD'), ',')
    endif
endfunction
" end functions

" commands
command! Scratch if bufexists('scratch') | buffer scratch | else
            \ | noswapfile hide enew | setlocal bt=nofile bh=hide | file scratch | endif

" custom pickers
command -nargs=1 -complete=customlist,OldFiles OldFiles edit <args>
command -nargs=1 -complete=customlist,AllFiles AllFiles edit <args>
" end commands

" autocmds
augroup vimrc
      autocmd!
augroup END

" close qf/lf when picked an item
autocmd vimrc FileType qf nnoremap <buffer> <CR> <CR>:cclose<CR>:lclose<CR>

" close quickfix window when it is the only window
autocmd vimrc WinEnter * if &l:buftype ==# 'quickfix' && winnr('$') == 1 && has('timers')
            \ | call timer_start(0, {-> execute('quit') }) | endif

" git powered path
autocmd vimrc VimEnter,BufReadPost,BufNewFile * :call g:SetPath()

" https://github.com/junegunn/fzf.vim
let g:buffers = {}
augroup buffers
    autocmd!
    if exists('*reltimefloat')
        autocmd BufWinEnter,WinEnter * let g:buffers[bufnr('')] = reltimefloat(reltime())
    else
        autocmd BufWinEnter,WinEnter * let g:buffers[bufnr('')] = localtime()
    endif
    autocmd BufDelete * silent! call remove(g:buffers, expand('<abuf>'))
augroup END
" end autocmds

" packadd! matchit
" packadd! cfilter
" packadd! editorconfig

" Install plug like this
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"
" only load plugins if plug detected
if filereadable(expand('~/.vim/autoload/plug.vim'))
  " it works on nvim as well like this
  silent! exec 'source ~/.vim/autoload/plug.vim'

  call plug#begin()
  " git
  Plug 'tpope/vim-fugitive'
  Plug 'airblade/vim-gitgutter'

  " utils
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-sleuth'
  Plug 'mbbill/undotree'
  Plug 'skanehira/vsession'
  Plug 'markonm/traces.vim'
  Plug 'habamax/vim-shout'

  " lsp/linter/formatter
  Plug 'dense-analysis/ale'
  Plug 'yegappan/lsp'

  " colors
  Plug 'joshdick/onedark.vim'
  Plug 'sheerun/vim-polyglot'
  call plug#end()

  " silent! colorscheme onedark

  " git
  nnoremap <leader>gs :Git<CR>
  nmap ]h <Plug>(GitGutterNextHunk)
  nmap [h <Plug>(GitGutterPrevHunk)

  " utils
  nnoremap <leader>u :UndotreeToggle<CR><CMD>UndotreeFocus<CR><CR>

  " session
  let g:vsession_path = '~/.vim/sessions'
  let g:vsession_save_last_on_leave = 1

  let lspOpts = #{
              \ autoHighlightDiags: v:true,
              \ ignoreMissingServer: v:true,
              \ }

  let lspServers = [
              \ #{
              \     name: 'golang',
              \     filetype: ['go', 'gomod'],
              \     path: '/usr/local/bin/gopls',
              \     args: ['serve'],
              \     syncInit: v:true,
              \     initializationOptions: #{
              \         semanticTokens: v:true,
              \     },
              \ },
              \ #{
              \   name: 'tsserver',
              \   filetype: ['javascript', 'typescript'],
              \   path: '/usr/local/bin/tsserver',
              \   args: ['--stdio'],
              \ },
              \ #{
              \   name: 'vue-ls',
              \   filetype: ['vue'],
              \   path: '/usr/local/bin/vue-language-server',
              \   args: ['--stdio'],
              \   initializationOptions: #{
              \       typescript: #{
              \           tsdk: '/usr/local/bin/typescript-lib'
              \       },
              \       vue: #{
              \           hybridMode: v:false
              \       }
              \   },
              \ },
              \ #{
              \     name: 'rustlang',
              \     filetype: ['rust'],
              \     path: '/usr/local/bin/rust-analyzer',
              \     args: [],
              \     syncInit: v:true,
              \ },
              \ #{
              \     name: 'intelephense',
              \     filetype: ['php'],
              \     path: '/usr/local/bin/intelephense',
              \     args: ['--stdio']
              \ },
              \ ]

  augroup Lsp
      au!
      autocmd User LspSetup call LspOptionsSet(lspOpts)
      autocmd User LspSetup call LspAddServer(lspServers)
      autocmd User LspAttached {
          setlocal signcolumn=yes
          setlocal tagfunc=lsp#lsp#TagFunc
          setlocal formatexpr=lsp#lsp#FormatExpr()
          setlocal keywordprg=:LspHover

          nmap <buffer> gd :LspGotoDefinition<CR>
          nmap <buffer> gs :LspDocumentSymbol<CR>
          nmap <buffer> gS :LspSymbolSearch<CR>
          nmap <buffer> gr :LspShowReferences<CR>
          nmap <buffer> gi :LspGotoImpl<CR>
          nmap <buffer> gT :LspGotoTypeDef<CR>
          nmap <buffer> <leader>rp :LspRename<CR>
          nmap <buffer> <leader>ca :LspCodeAction<CR>
          nmap <buffer> <leader>mf :LspFormat<CR>
          nmap <buffer> <leader>td :LspDiag show<CR>

          nmap <buffer> ]d :LspDiag next<CR>
          nmap <buffer> [d :LspDiag prev<CR>
      }
  augroup END

  " lint/format
  nmap <silent> ]e <Plug>(ale_previous_wrap)
  nmap <silent> [e <Plug>(ale_next_wrap)
  nmap <leader>te :ALEPopulateQuickfix<CR>:copen<CR>

  let g:ale_sign_error = 'E>'
  let g:ale_sign_warning = 'W>'
  let g:ale_sign_info = 'I>'

  let g:ale_linters_explicit = 1
  let g:ale_linters = {
  \   'php': ['phpstan'],
  \   'typescript': ['eslint'],
  \   'javascript': ['eslint'],
  \   'vue': ['eslint'],
  \   'vim': ['vint'],
  \}

  let g:ale_fix_on_save = 1
  let g:ale_fixers = {
  \   '*': ['remove_trailing_lines', 'trim_whitespace'],
  \   'javascript': ['prettier'],
  \   'typescript': ['prettier'],
  \   'vue': ['prettier'],
  \   'svelte': ['prettier'],
  \   'css': ['prettier'],
  \   'html': ['prettier'],
  \   'json': ['prettier'],
  \   'yaml': ['prettier'],
  \   'markdown': ['prettier'],
  \   'lua': ['stylua'],
  \   'sh': ['shfmt'],
  \   'go': ['gofmt'],
  \}
endif
