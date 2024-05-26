call plug#begin()

" git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" utils
Plug 'tpope/vim-commentary'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'mbbill/undotree'

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
nnoremap <leader>u :UndotreeToggle<CR><CMD>UndotreeFocus<CR><CR>

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

    nmap <buffer> [d <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]d <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)

    nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
    nnoremap <buffer> <expr><c-g> lsp#scroll(-4)

    inoremap <expr> <cr> pumvisible() ? asyncomplete#close_popup() : "\<cr>"

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
endfunction

augroup lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" vue specific
let g:lsp_settings_filetype_vue = ['typescript-language-server', 'volar-server']

" rust
if executable('rustup')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'rust-analyzer',
        \ 'cmd': {server_info->['rustup', 'run', 'stable', 'rust-analyzer']},
        \ 'allowlist': ['rust'],
        \ })
endif

" lint/format
nmap <silent> ]e <Plug>(ale_previous_wrap)
nmap <silent> [e <Plug>(ale_next_wrap)

let g:ale_sign_error = "E>"
let g:ale_sign_warning = "W>"
let g:ale_sign_info = "I>"

let g:ale_linters_explicit = 1
let g:ale_linters = {
\   'php': ['phpstan'],
\   'typescript': ['eslint'],
\   'javascript': ['eslint'],
\   'vue': ['eslint'],
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
