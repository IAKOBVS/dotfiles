cal plug#begin('~/.vim/plugged')
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
Plug 'bkad/CamelCaseMotion'
Plug 'godlygeek/tabular'
Plug 'vim-scripts/LargeFile'
Plug 'dense-analysis/ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'OmniSharp/omnisharp-vim'
cal plug#end()

vn ff :Tabularize /\\$<CR>

" highlight things
au CursorHold * sil cal CocActionAsync('highlight')
" for coc-nvim autocomplete
fu! CheckBackspace() abort
	let col = col('.') - 1
	retu !col || getline('.')[col - 1]	=~# '\s'
endf
if has('statusline')
	se statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
en
" navigate errors
nn <silent> <tab>k <Plug>(coc-diagnostic-prev)
nn <silent> <tab>j <Plug>(coc-diagnostic-next)
" navigate completions
ino <silent><expr> <C-j> coc#pum#visible() ? coc#pum#next(1) :
	\ CheckBackspace() ? "\<C-j>" :
	\ coc#refresh()
ino <expr><C-k> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
ino <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
	\ :"\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nn ;coc :CocConfig<CR>
au BufNewFile,BufEnter *.js,*.ts,*.html,*.css sil! nn <leader>f :CocCommand prettier.formatFile<CR>
" au BufNewFile,BufEnter *.js,*.ts,*.html,*.css sil! :ALEDisable<CR>

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
let g:__my_gcc_flags__ = '-Wall -Wextra -Wuninitialized -Wshadow -Warray-bounds -Wnull-dereference -Wformat -Wno-sign-compare -Wno-sign-conversion -fanalyzer'
let g:ale_c_cc_options = '-std=c17 ' . g:__my_gcc_flags__
let g:ale_cpp_cc_options = '-std=c++17 ' . g:__my_gcc_flags__
let g:ale_c_clangtidy_checks = [
	\ '-clang-diagnostic-error',
	\ '-clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling',
	\ '-clang-analyzer-security.insecureAPI.strcpy'
	\ ]
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

let g:airline_section_y = '%{trim(system("git branch --show-current 2>/dev/null"))}'

" let g:OmniSharp_selector_ui = 'fzf'    " Use fzf
" let g:ale_linters = { 
" \ 'cs': ['OmniSharp']
" \}
