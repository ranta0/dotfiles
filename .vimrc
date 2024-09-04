if !has('vim9script') || v:version < 900 | finish | endif
vim9script

g:mapleader = "\<Space>"
g:maplocalleader = "\<Space>"

# cursor modes
&t_SI = "\<Esc>[6 q"
&t_EI = "\<Esc>[2 q"

filetype plugin indent on
syntax enable

set encoding=utf-8 fileencoding=utf-8 fileformats=unix,mac,dos
set fileencodings=utf-8,latin
set number relativenumber nowrap
set tabstop=4 shiftwidth=4 expandtab smarttab autoindent smartindent
set scrolloff=8
set nohidden autoread
set list listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set hlsearch incsearch
set showcmd noruler laststatus=2
set statusline=%<%.99f\ %h%w%m%r%=%y\ %{&fenc!=#''?&fenc:'none'}\ %{&ff}\ %P
set path=.,,
set wildmenu wildoptions=pum
set wildignore=*.~,*.?~,*.o,*.sw?,*.bak,*.hi,*.pyc,*.out suffixes=*.pdf
set updatetime=50 lazyredraw ttyfast ttimeoutlen=50

&undodir = $'{fnamemodify($MYVIMRC, ":p:h")}/.vim/undo//'
if !isdirectory(&undodir) | mkdir(&undodir, "p") | endif
set undofile nobackup noswapfile

set grepprg=grep\ -rnH\ --exclude-dir={.git,node_modules,vendor}
set grepformat=%f:%l:%m

set background=dark
set termguicolors
colorscheme lunaperche

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
nnoremap <silent> <C-t> :tabnew<CR>
nnoremap ]w <C-w>w
nnoremap [w <C-w>W
nnoremap ]t gt
nnoremap [t gT
nnoremap ]q :cn<CR>
nnoremap [q :cp<CR>
nnoremap ]f :next<CR>
nnoremap [f :previous<CR>
# splits
nnoremap <silent> <C-Up> :resize +5<cr>
nnoremap <silent> <C-Down> :resize -5<cr>
nnoremap <silent> <C-Right> :vertical resize -5<cr>
nnoremap <silent> <C-Left> :vertical resize +5<cr>
# completion
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
# toggles
nnoremap ,n :set relativenumber!<CR>
nnoremap ,w :set wrap!<CR>
nnoremap ,p :set paste!<CR>
nnoremap <expr> ,d ":" .. (&diff ? "diffoff" : "diffthis") .. "<CR>"
# nope
nnoremap Q <nop>
nnoremap gQ <nop>
nnoremap <F1> <esc>

# leader keys
nmap <silent> <leader>/ :let @/ = ""<CR>
nnoremap <leader>sf :GitFiles <space>
nnoremap <leader>sh :AllFiles <space>
nnoremap <leader>? :MRUFiles <space>
nnoremap <leader>- :Ex<CR>
xnoremap <leader>y "+y
nnoremap <leader>p "+p
nnoremap <leader>f <scriptcmd>RangerExplorer()<CR>
nnoremap <leader>sg <scriptcmd>QFGrep(1)<CR>
nnoremap <leader>sG <scriptcmd>QFGrep(0)<CR>
nnoremap <leader><leader> :b *

# functions
def Fuzzy(files: list<any>, search: string): list<any>
    if empty(search) | return files | endif
    return matchfuzzy(files, search)
enddef
def MRUFiles(ArgLead: string, CmdLine: string, CursorPos: number): list<any>
    return Fuzzy(g:RecentFiles(), ArgLead)
enddef
def AllFiles(ArgLead: string, CmdLine: string, CursorPos: number): list<any>
    return Fuzzy(systemlist("find . -type f 2>&1"), ArgLead)
enddef
def GitFiles(ArgLead: string, CmdLine: string, CursorPos: number): list<any>
    return Fuzzy(systemlist("git ls-files"), ArgLead)
enddef

def QFGrep(ignore_case: bool)
    var search_pattern = input('Grep > ')
    var cmd = 'silent grep! ' .. search_pattern
    if ignore_case
        cmd = cmd .. ' --ignore-case'
    endif
    if !empty(search_pattern)
        execute cmd
        redraw!
        copen
    endif
enddef

def RangerExplorer()
    var tmpfile = tempname()
    var cmd = 'silent !ranger --cmd "set show_hidden=true" --choosefile=' .. tmpfile .. ' ' .. shellescape(expand('%:p:h'))
    execute cmd

    if filereadable(tmpfile)
        var filepath = readfile(tmpfile)[0]
        execute 'edit ' .. fnameescape(filepath)
        delete(tmpfile)
    else
        echohl ErrorMsg | echo 'No file chosen or ranger command failed' | echohl None
    endif
    redraw!
enddef
#  end functions

#  commands
command Scratch if bufexists('scratch') | buffer scratch | else
            \ | noswapfile hide enew | setlocal bt=nofile bh=hide | file scratch | endif

command -nargs=1 -complete=customlist,MRUFiles MRUFiles edit <args>
command -nargs=1 -complete=customlist,AllFiles AllFiles edit <args>
command -nargs=1 -complete=customlist,GitFiles GitFiles edit <args>
#  end commands

# mru
g:recent_files = []
g:recent_files_max_entries = 100
g:recent_files_file = $'{fnamemodify($MYVIMRC, ":p:h")}/.vim/mru'
def g:RecentFiles(): list<any>
    if filereadable(g:recent_files_file)
        g:recent_files = readfile(g:recent_files_file)
    endif

    var files = copy(g:recent_files)
    return files->map('fnamemodify(v:val, ":~:.")')
enddef

augroup mru | autocmd!
    def AddRecentFile(bufnr: string)
        if !empty(&buftype) | return | endif

        if filereadable(g:recent_files_file)
            g:recent_files = readfile(g:recent_files_file)
        endif

        var fname = bufname(eval(bufnr))->fnamemodify(':p')
        if !filereadable(fname) | return | endif

        g:recent_files->filter((_, v) => v !~ fname)
        g:recent_files->insert(fname)

        if g:recent_files->len() > g:recent_files_max_entries
            g:recent_files->remove(g:recent_files_max_entries, -1)
        endif

        g:recent_files->writefile(g:recent_files_file)
    enddef

    autocmd BufRead,BufWritePost,BufEnter * call AddRecentFile(expand('<abuf>'))
augroup END
# end mru

# Install plug like this
# curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
if filereadable(expand('~/.vim/autoload/plug.vim'))
    plug#begin()
    Plug 'tpope/vim-fugitive'
    Plug 'airblade/vim-gitgutter'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-sleuth'
    Plug 'dense-analysis/ale'
    Plug 'yegappan/lsp'
    Plug 'girishji/devdocs.vim'
    Plug 'girishji/autosuggest.vim'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'markonm/traces.vim'
    Plug 'sheerun/vim-polyglot'
    Plug 'joshdick/onedark.vim'
    plug#end()

    silent! colorscheme onedark

    # fuzzy finders, override the default ones
    g:fzf_popup_option = '-i --ansi --bind tab:up,shift-tab:down'
    command! GitFiles call fzf#run(fzf#wrap({
                \ 'source': 'git ls-files', 'sink': 'e',
                \ 'options': g:fzf_popup_option .. ' --prompt "GFiles> "'}))
    nnoremap <leader>sf :GitFiles<CR>

    command! AllFiles call fzf#run(fzf#wrap({
                \ 'source': 'find . -type f', 'sink': 'e',
                \ 'options': g:fzf_popup_option .. ' --prompt "Files> "'}))
    nnoremap <leader>sh :AllFiles<CR>

    command! MRUFiles call fzf#run(fzf#wrap({
                \ 'source': g:RecentFiles(), 'sink': 'e',
                \ 'options': g:fzf_popup_option .. ' --no-sort --prompt "History> "'}))
    nnoremap <leader>? :MRUFiles<CR>

    # git
    def Go2LineGrep(selected: string)
        var parts = split(selected, ':')
        execute 'e' parts[0]
        cursor(eval(parts[1]), eval(parts[2]))
    enddef
    g:fzf_git_grep = 'git grep --line-number --column --color -- '
    command -nargs=* GGrep call fzf#run(fzf#wrap({
                \ 'source': g:fzf_git_grep .. shellescape(<q-args>), 'sink': function('Go2LineGrep'),
                \ 'options': g:fzf_popup_option .. ' --prompt "GitGrep [' .. shellescape(<q-args>) .. ']> "'}))
    nnoremap <leader>gg :GGrep <space>

    def GitStatusEdit(selected: string)
        var parts = split(selected, ' ')
        if parts[0] == 'D' | echohl ErrorMsg | echo 'This file has been deleted' | echohl None | return | endif
        if parts[1] == '' | execute 'e' parts[2] | else | execute 'e' parts[1] | endif
    enddef
    command GStatus call fzf#run(fzf#wrap({
                \ 'source': 'git -c color.status=always status -s', 'sink': function('GitStatusEdit'),
                \ 'options': g:fzf_popup_option .. ' --prompt "GitStatus> "'}))
    nnoremap <leader>gs :GStatus <CR>

    g:gitgutter_map_keys = 0
    g:gitgutter_show_msg_on_hunk_jumping = 1
    nmap ]h <Plug>(GitGutterNextHunk)
    nmap [h <Plug>(GitGutterPrevHunk)

    g:lspOpts = {
        autoHighlightDiags: true,
        ignoreMissingServer: true,
        useQuickfixForLocations: true,
        aleSupport: true,
    }

    g:lspServers = [
        {
            name: 'golang',
            filetype: ['go', 'gomod'],
            path: '/usr/local/bin/gopls',
            args: ['serve'],
            syncInit: true,
            initializationOptions: {
            semanticTokens: true,
            },
        },
        {
            name: 'tsserver',
            filetype: ['javascript', 'typescript'],
            path: '/usr/local/bin/typescript-language-server',
            args: ['--stdio'],
        },
        {
            name: 'vue-ls',
            filetype: ['vue'],
            path: '/usr/local/bin/vue-language-server',
            args: ['--stdio'],
            initializationOptions: {
            typescript: {
            tsdk: '/usr/local/bin/typescript-lib'
            },
            vue: {
            hybridMode: false
            }
            },
        },
        {
            name: 'rustlang',
            filetype: ['rust'],
            path: '/usr/local/bin/rust-analyzer',
            args: [],
            syncInit: true,
        },
        {
            name: 'intelephense',
            filetype: ['php'],
            path: '/usr/local/bin/intelephense',
            args: ['--stdio']
        },
    ]

    augroup Lsp
        au!
        autocmd User LspSetup call LspOptionsSet(g:lspOpts)
        autocmd User LspSetup call LspAddServer(g:lspServers)
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

            nmap <buffer> ]d :LspDiag next<CR>
            nmap <buffer> [d :LspDiag prev<CR>
        }
    augroup END

    nmap <leader>td :ALEPopulateQuickfix<CR>:copen<CR>
    g:ale_sign_error = 'E '
    g:ale_sign_warning = 'W '
    g:ale_sign_info = 'I '

    g:ale_linters_explicit = 1
    g:ale_linters = {
        'php': ['phpstan'],
        'typescript': ['eslint'],
        'javascript': ['eslint'],
        'vue': ['eslint'],
        'vim': ['vint'],
    }

    g:ale_fix_on_save = 1
    g:ale_fixers = {
        '*': ['remove_trailing_lines', 'trim_whitespace'],
        'javascript': ['prettier'],
        'typescript': ['prettier'],
        'vue': ['prettier'],
        'svelte': ['prettier'],
        'css': ['prettier'],
        'html': ['prettier'],
        'json': ['prettier'],
        'yaml': ['prettier'],
        'markdown': ['prettier'],
        'lua': ['stylua'],
        'sh': ['shfmt'],
        'go': ['gofmt'],
    }

    # commentstring
    autocmd FileType php setlocal commentstring=//\ %s
    autocmd FileType vim setlocal commentstring=#\ %s
endif
