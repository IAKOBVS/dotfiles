call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-commentary'
Plug 'vim-airline/vim-airline'
Plug 'preservim/nerdtree'
Plug 'tribela/vim-transparent'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'bkad/CamelCaseMotion'
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
" Plug 'mechatroner/rainbow_csv'
Plug 'godlygeek/tabular'
Plug 'vim-scripts/LargeFile'
" Plug 'lervag/vimtex'
" lsp
Plug 'dense-analysis/ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" nvim lsp
" Plug 'williamboman/mason.nvim', {'do': ':MasonUpdate'}
" Plug 'VonHeikemen/lsp-zero.nvim', {'branch': 'v2.x'}
" Plug 'neovim/nvim-lspconfig'
" Plug 'williamboman/mason-lspconfig.nvim'
" Plug 'hrsh7th/nvim-cmp'
" Plug 'hrsh7th/cmp-nvim-lsp'
" Plug 'L3MON4D3/LuaSnip'
" dart
" Plug 'dart-lang/dart-vim-plugin'
call plug#end()

" navigate errors
nn <silent> <tab>k <Plug>(coc-diagnostic-prev)
nn <silent> <tab>j <Plug>(coc-diagnostic-next)

nn <silent> <tab>k <Plug>(ale_previous_wrap)
nn <silent> <tab>j <Plug>(ale_next_wrap)

" navigate completions
ino <silent><expr> <C-j>
	\ coc#pum#visible() ? coc#pum#next(1) :
	\ CheckBackspace() ? "\<Tab>" :
	\ coc#refresh()
ino <expr><C-k>
	\ coc#pum#visible() ? coc#pum#prev(1) :
	\ "\<C-h>"
" accept completion
ino <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
	\ :"\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

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
nn <space>h :cd ~ \| Files<CR>
nn <space>f :cal fzf#vim#files(expand('%:p:h'))<CR>
nn <space>r :Rg<CR>

" open cwd in new terminal
nn <space>s :w<CR>:let @a=expand('%')<CR>:silent !sd % >/dev/null 2>&1 & disown &<CR>:e!<CR>:let &modified=0<CR>:let @" = @a<CR>

if has('nvim-0.6')
	let g:ale_use_neovim_diagnostics_api = 1
endif
let g:AutoPairsMultilineClose = 0 " disable weird pairing behaviour

au CursorHold * sil cal CocActionAsync('highlight') " highlight symbol
au BufRead *.pl,*.pm let g:ale_enabled = 0 " disables ale for perl

" only let ale use clang-tidy
let g:ale_linters = {
	\ 'cpp': ['clangtidy'],
	\ 'c': ['clangtidy']
\ }

let g:ale_lint_on_save = 1
let g:ale_c_clangtidy_checks = ['-clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling', 'clang-analyzer-security.insecureAPI.strcpy']
let g:ale_cpp_clangtidy_checks = ['-clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling', 'clang-analyzer-security.insecureAPI.strcpy']
let g:Hexokinase_highlighters = ['backgroundfull'] " depends on hexokinase
" let g:vimtex_view_method = 'zathura'
" let g:vimtex_compiler_method = 'latexmk'

" for coc-nvim autocomplete
function! CheckBackspace() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]	=~# '\s'
endfunction
