cal plug#begin('~/.vim/plugged')
Plug 'tpope/vim-commentary'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'tribela/vim-transparent'
Plug 'bkad/CamelCaseMotion'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
Plug 'godlygeek/tabular'
Plug 'ptzz/lf.vim'
Plug 'voldikss/vim-floaterm'
Plug 'vim-scripts/LargeFile'

Plug 'dense-analysis/ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Plug 'preservim/nerdtree'
" Plug 'mechatroner/rainbow_csv'
" Plug 'dart-lang/dart-vim-plugin'
" Plug 'lervag/vimtex'

" Plug 'williamboman/mason.nvim', {'do': ':MasonUpdate'}
" Plug 'VonHeikemen/lsp-zero.nvim', {'branch': 'v2.x'}
" Plug 'neovim/nvim-lspconfig'
" Plug 'williamboman/mason-lspconfig.nvim'
" Plug 'hrsh7th/nvim-cmp'
" Plug 'hrsh7th/cmp-nvim-lsp'
" Plug 'L3MON4D3/LuaSnip'
cal plug#end()

" highlight things
au CursorHold * sil cal CocActionAsync('highlight')
" for coc-nvim autocomplete
fu! CheckBackspace() abort
	let col = col('.') - 1
	retu !col || getline('.')[col - 1]	=~# '\s'
endf
se statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
" navigate errors
nn <silent> <tab>k <Plug>(coc-diagnostic-prev)
nn <silent> <tab>j <Plug>(coc-diagnostic-next)
" navigate completions
ino <silent><expr> <C-j>
	\ coc#pum#visible() ? coc#pum#next(1) :
	\ CheckBackspace() ? "\<Tab>" :
	\ coc#refresh()
ino <expr><C-k>
	\ coc#pum#visible() ? coc#pum#prev(1) :
	\ "\<C-h>"
ino <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
	\ :"\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" accept completion
nn <silent> <tab>k <Plug>(ale_previous_wrap)
nn <silent> <tab>j <Plug>(ale_next_wrap)
nn <space>a :ALEToggle<CR>
if has('nvim-0.6')
	let g:ale_use_neovim_diagnostics_api = 1
en
let g:ale_lint_on_text_changed = 1
let g:ale_c_cc_executable = 'gcc'
let g:ale_cpp_cc_executable = 'g++'
let g:ale_c_cc_options =
	\ '-std=c17 -Wall -Wextra -Wuninitialized -Wshadow -Warray-bounds -Wnull-dereference -Wformat -Wno-sign-compare -Wno-sign-conversion -fanalyzer'
let g:ale_cpp_cc_options =
	\ '-std=c++17 -Wall -Wextra -Wuninitialized -Wshadow -Warray-bounds -Wnull-dereference -Wformat -Wno-sign-compare -Wno-sign-conversion -fanalyzer'
let g:ale_c_clangtidy_checks = [
	\ '-clang-diagnostic-error',
	\ '-clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling',
	\ '-clang-analyzer-security.insecureAPI.strcpy']
let g:ale_cpp_clangtidy_checks = g:ale_c_clangtidy_checks

" respect camelCase
map <silent>w <Plug>CamelCaseMotion_w
map <silent>b <Plug>CamelCaseMotion_b
map <silent>e <Plug>CamelCaseMotion_e
map <silent>ge <Plug>CamelCaseMotion_ge
sunm w
sunm b
sunm e
sunm ge

" fzf
nn <space>l :History<CR>
nn <space>h :Files ~<CR>
nn <space>f :Files<CR>
nn <space>r :Rg<CR>

nn <space>o :Lf<CR>
let g:lf_replace_netrw = 1

" open cwd in new terminal
nn <space>s :w<CR>:let @a=expand('%')<CR>:silent !sd % >/dev/null 2>&1 & disown &<CR>:e!<CR>:let &modified=0<CR>:let @" = @a<CR>

let g:AutoPairsMultilineClose = 0 " disable weird pairing behaviour
let g:NERDTreeHijackNetrw = 0
let g:fzf_preview_window = ['right,50%', 'ctrl-/']
