call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
Plug 'bkad/CamelCaseMotion'
" Plug 'godlygeek/tabular'
Plug 'vim-scripts/LargeFile'
Plug 'dense-analysis/ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/goyo.vim'
Plug 'rhysd/vim-grammarous'
if 0
	Plug 'bergercookie/asm-lsp'
	Plug 'OmniSharp/omnisharp-vim'
endif
call plug#end()

" coc.nvim Extensions
" Use ":CocInstall <coc-extension>"

" coc-clangd
" coc-vimlsp
" coc-snippets
" coc-pairs
" coc-lists
" coc-json
" coc-highlight
" coc-eslint
" coc-diagnostic
" coc-vimtex
" coc-tsserver
" coc-sh
" coc-perl
" coc-java

" Unused
" coc-flutter
" coc-flutter-tools
" coc-lua
" coc-prettier
" coc-rust-analyzer
" coc-omnisharp
" coc-pylsp

let g:LargeFile = 10 

vnoremap ff :Tabularize /\\$<CR>

" highlight things
autocmd CursorHold * silent call CocActionAsync('highlight')
" for coc-nvim autocomplete
function! CheckBackspace() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]	=~# '\s'
endfunction
if has('statusline')
	se statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
endif
" navigate errors
nnoremap <silent> <tab>k <Plug>(coc-diagnostic-prev)
nnoremap <silent> <tab>j <Plug>(coc-diagnostic-next)
" navigate completions
inoremap <silent><expr> <C-j> coc#pum#visible() ? coc#pum#next(1) :
	\ CheckBackspace() ? "\<C-j>" :
	\ coc#refresh()
inoremap <expr><C-k> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
	\ :"\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" GoTo code navigation
noremap <silent> gd <Plug>(coc-definition)
noremap <silent> gi <Plug>(coc-implementation)
noremap <silent> gr <Plug>(coc-references)
nnoremap ;coc :CocConfig<CR>

if 0
	autocmd FileType perl silent :CocDisable
	autocmd FileType perl nnoremap <leader>f :silent! CocEnable<CR> :silent! CocStart<CR>
	autocmd BufNewFile,BufEnter *.js,*.ts,*.html,*.css silent! nnoremap <leader>f :CocCommand prettier.formatFile<CR>
	autocmd BufNewFile,BufEnter *.js,*.ts,*.html,*.css silent! :ALEDisable<CR>
endif

" accept completion
nnoremap <silent> <tab>k <Plug>(ale_previous_wrap)
nnoremap <silent> <tab>j <Plug>(ale_next_wrap)
nnoremap <space>a :ALEToggle<CR>

if has('nvim-0.6')
	let g:ale_use_neovim_diagnostics_api = 1
endif
let g:ale_linters = { 
\ 'cs': ['mcs'] 
\}
let g:ale_lint_on_enter = 0
let g:ale_lint_on_save = 0
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_text_changed = 1
let g:ale_c_cc_executable = 'gcc'
let g:ale_cpp_cc_executable = 'g++'
let g:__my_gcc_flags__ = '-Wall -Wpedantic -pedantic -Wextra -Wuninitialized -Wshadow -Warray-bounds -Wnull-dereference -Wformat -Wunused -Wwrite-strings -fanalyzer -Wsign-conversion'
let g:ale_c_cc_options = '-std=c99 ' . g:__my_gcc_flags__
let g:ale_cpp_cc_options = '-std=c++17 ' . g:__my_gcc_flags__
let g:ale_c_clangtidy_checks = [
	\ '-clang-diagnostic-error',
	\ '-clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling',
	\ '-clang-analyzer-security.insecureAPI.strcpy'
	\ ]
let g:ale_cpp_clangtidy_checks = g:ale_c_clangtidy_checks
let g:ale_javascript_eslint_executable = 0

if 0
	autocmd FileType perl nnoremap <silent> <leader>f :let g:ale_linters = {'perl': ['perl']}<CR>
endif

" respect camelCase
map <silent>w <Plug>CamelCaseMotion_w
map <silent>b <Plug>CamelCaseMotion_b
map <silent>e <Plug>CamelCaseMotion_e
map <silent>ge <Plug>CamelCaseMotion_ge
sunmap w
sunmap b
sunmap e
sunmap ge

let g:airline_section_y = '%{trim(system("git branch --show-current 2>/dev/null"))}'

if 0
	let g:OmniSharp_server_use_mono = 1
	let g:OmniSharp_typeLookupInPreview = 1
	let g:OmniSharp_coc_snippet = 1
	let g:OmniSharp_popup = 1
endif

autocmd Filetype c setlocal commentstring=/\*%s\*/
