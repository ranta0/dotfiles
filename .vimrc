" thanks to https://github.com/itchyny/dotfiles/blob/main/.vimrc
if &encoding !=? 'utf-8' | let &termencoding = &encoding | endif
set encoding=utf-8 fileencoding=utf-8 fileformats=unix,mac,dos
set fileencodings=utf-8,iso-2022-jp-3,euc-jisx0213,cp932,euc-jp,sjis,jis,latin,iso-2022-jp

set number relativenumber nowrap
set tabstop=4 shiftwidth=4 expandtab smarttab autoindent smartindent
set scrolloff=8

set nohidden autoread

set list listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set hlsearch incsearch

set showcmd noruler laststatus=2
set statusline=[%n]\ %<%.99f\ %h%w%m%r%=%y\ %{&fenc!=#''?&fenc:'none'}\ %{&ff}\ %P

" thanks to https://github.com/changemewtf/no_plugins/blob/master/no_plugins.vim
set path+=**
set wildmenu
if v:version >= 900 | set wildoptions=pum | endif
set wildignore=*.~,*.?~,*.o,*.sw?,*.bak,*.hi,*.pyc,*.out suffixes=*.pdf

set nobackup noswapfile
set updatetime=50 lazyredraw ttyfast

set grepprg=grep\ -rnH\ --exclude-dir={.git,node_modules,vendor}
if executable('rg')
    set grepprg=rg\ --vimgrep
endif
set grepformat=%f:%l:%m

packadd! matchit
packadd! cfilter

filetype plugin indent on
syntax enable

" undo
let $UNDO_DATA = $HOME . '/.vim/undo'
if v:version >= 703
    silent !mkdir -p $UNDO_DATA
    set undofile undodir=$UNDO_DATA
endif

let g:netrw_keepj='keepj'

" windows causing problems
let &t_SI = "\<Esc>[5 q"
let &t_SR = "\<Esc>[3 q"
let &t_EI = "\<Esc>[1 q"

" nice to have
nnoremap k gk
nnoremap j gj
xnoremap k gk
xnoremap j gj
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzzzv
nnoremap N Nzzzv
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
vnoremap <silent> > >gv
vnoremap <silent> < <gv
vnoremap $ $h
nnoremap Q <nop>
nnoremap gQ <nop>

" tabs
nnoremap gf <C-w>gf
nnoremap <silent> <C-t> :tabnew<CR>
nnoremap <C-l> gt
nnoremap <C-h> gT

" qf
nnoremap <C-k> :cn<CR>
nnoremap <C-j> :cp<CR>

" unimpared like
nnoremap ]b :bnext<CR>
nnoremap [b :bprevious<CR>
nnoremap ]w <C-w>w
nnoremap [w <C-w>W
nnoremap ]l :lnext<CR>
nnoremap [l :lprevious<CR>

" wildmenu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

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
nnoremap <leader>- :Ex<CR>
vnoremap <leader>T :s/\s\+$//e<LEFT><CR>
xnoremap <leader>y "+y
nnoremap <silent> <leader>cd :lcd%:p:h<CR>:pwd<CR>
nnoremap <leader>f :call g:RangerExplorer()<CR>
nnoremap <leader>sg :call QFGrep(1)<CR>
nnoremap <leader>sG :call QFGrep(0)<CR>

" theme
" thanks to https://github.com/karoliskoncevicius/oldbook-vim/blob/master/colors/oldbook.vim
colorscheme slate
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
" end functions

" autocmds
augroup vimrc
      autocmd!
augroup END

" do not keep commenting
autocmd vimrc BufEnter * set formatoptions-=cro

" close qf when picked an item
autocmd vimrc FileType qf nnoremap <buffer> <CR> <CR>:cclose<CR>:lclose<CR>

" close quickfix window when it is the only window
autocmd vimrc WinEnter * if &l:buftype ==# 'quickfix' && winnr('$') == 1 && has('timers')
            \ | call timer_start(0, {-> execute('quit') }) | endif
" end autocmds

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
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'mbbill/undotree'
  Plug 'skanehira/vsession'
  Plug 'markonm/traces.vim'

  " lsp/linter/formatter
  Plug 'prabirshrestha/vim-lsp'
  Plug 'prabirshrestha/asyncomplete.vim'
  Plug 'prabirshrestha/asyncomplete-lsp.vim'
  Plug 'mattn/vim-lsp-settings'
  Plug 'dense-analysis/ale'

  " colors
  Plug 'joshdick/onedark.vim'
  Plug 'sheerun/vim-polyglot'
  call plug#end()

  colorscheme onedark

  " git
  nnoremap <leader>gs :Git<CR>
  nmap ]h <Plug>(GitGutterNextHunk)
  nmap [h <Plug>(GitGutterPrevHunk)

  " utils
  nnoremap <leader>sf :Files<CR>
  nnoremap <leader>sh :GFiles<CR>
  nnoremap <leader>? :History<CR>
  nnoremap <leader><leader> :Buffers<CR>
  nnoremap <leader>u :UndotreeToggle<CR><CMD>UndotreeFocus<CR><CR>

  " session
  let g:vsession_path = '~/.vim/sessions'
  let g:vsession_save_last_on_leave = 1
  let g:vsession_ui = 'fzf'

  " lsp
  function! s:on_lsp_buffer_enabled() abort
      setlocal omnifunc=lsp#complete
      setlocal signcolumn=yes
      if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
      nmap <buffer> gd <plug>(lsp-definition)
      nmap <buffer> gs <plug>(lsp-document-symbol-search)
      nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
      nmap <buffer> gr <plug>(lsp-references)
      nmap <buffer> gi <plug>(lsp-implementation)
      nmap <buffer> gT <plug>(lsp-type-definition)
      nmap <buffer> <leader>rp <plug>(lsp-rename)
      nmap <buffer> <leader>ca :LspCodeAction<CR>
      nmap <buffer> <leader>mf :LspDocumentFormat<CR>
      nmap <buffer> <leader>td :LspDocumentDiagnostics<CR>

      nmap <buffer> [d <plug>(lsp-previous-diagnostic)
      nmap <buffer> ]d <plug>(lsp-next-diagnostic)
      nmap <buffer> K <plug>(lsp-hover)

      nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
      nnoremap <buffer> <expr><c-g> lsp#scroll(-4)

      inoremap <expr> <cr> pumvisible() ? asyncomplete#close_popup() : "\<cr>"

      let g:lsp_format_sync_timeout = 1000

      augroup lsp_autoformat
          au!
          autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
      augroup END
  endfunction

  augroup lsp_install
      au!
      autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
  augroup END

  let g:lsp_use_native_client = 1
  let g:lsp_semantic_enabled = 0
  let g:lsp_format_sync_timeout = 1000
  let g:lsp_diagnostics_virtual_text_insert_mode_enabled = 0
  let g:lsp_diagnostics_virtual_text_align = 'after'
  let g:lsp_diagnostics_virtual_text_wrap = 'wrap'
  " vue specific
  let g:lsp_settings_filetype_vue = ['typescript-language-server', 'volar-server']

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
