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
Plug 'lervag/vimtex'
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

nnoremap <C-n>v :source ~/.nvimrc<CR>

" motions

" jump between paragraphs
map J }
map K {
map <C-j> <C-d>
map <C-k> <C-u>

" navigate errors
nnoremap <silent> <tab>k <Plug>(coc-diagnostic-prev)
nnoremap <silent> <tab>j <Plug>(coc-diagnostic-next)

nnoremap <silent> <tab>k <Plug>(ale_previous_wrap)
nnoremap <silent> <tab>j <Plug>(ale_next_wrap)

" navigate completions
inoremap <silent><expr> <C-j>
	\ coc#pum#visible() ? coc#pum#next(1) :
	\ CheckBackspace() ? "\<Tab>" :
	\ coc#refresh()
inoremap <expr><C-k>
	\ coc#pum#visible() ? coc#pum#prev(1) :
	\ "\<C-h>"
" accept completion
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
	\ :"\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" respect camelCase
map <silent>w <Plug>CamelCaseMotion_w
map <silent>b <Plug>CamelCaseMotion_b
map <silent>e <Plug>CamelCaseMotion_e
map <silent>ge <Plug>CamelCaseMotion_ge
sunmap w
sunmap b
sunmap e
sunmap ge

" copy paste
vnoremap <C-d> "+y:delete<CR>
vnoremap <C-c> "*y :let @+=@*<CR>
nnoremap cc <S-v> "*y :let @+=@*<CR>
noremap <C-p> "+P
noremap <C-s> :w<CR>h

" surround with symbols
nnoremap qq lbdei"<Esc>pli"<Esc>h
nnoremap QQ F"xf"xh
nnoremap Qq QQ

nnoremap q' lbdei'<Esc>pli'<Esc>h
nnoremap Q' F'xf'xh

nnoremap q9 lbdei(<Esc>pli)<Esc>h
nnoremap Q9 F(xf)xh
nnoremap q, lbdei<<Esc>pli><Esc>h
nnoremap Q, F<xf>xh

" tabularize C macro
vnoremap ff :Tabularize /\\$<CR>

" fzf
nnoremap <space>l :History<CR>
nnoremap <space>h :cd ~ \| Files<CR>
nnoremap <space>f :call fzf#vim#files(expand('%:p:h'))<CR>
nnoremap <space>r :Rg<CR>

" open cwd in new terminal
nnoremap <space>s :w<CR>:let @a=expand('%')<CR>:silent !sd % >/dev/null 2>&1 & disown &<CR>:e!<CR>:let &modified=0<CR>:let @" = @a<CR>

if has('nvim-0.6')
	let g:ale_use_neovim_diagnostics_api = 1
endif

colorscheme murphy
if has('nvim')
	set termguicolors
endif
highlight NormalFloat guibg=none
highlight VertSplit guibg=none
highlight FoldColumn guibg=none
highlight SignColumn guibg=none
highlight LineNr guibg=none
highlight CursorLineNr guibg=none
highlight Normal ctermbg=none guibg=none

filetype plugin indent on
set cinoptions+=:0 " disable switch indent
set number relativenumber
set linebreak
set nohlsearch
set incsearch
set maxmempattern=2000000 " use more ram
set pastetoggle=<F1>
set mouse=a
set encoding=utf-8
set nobackup
set nowritebackup
set updatetime=300
set signcolumn=yes
set modifiable
set nocompatible
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
if has('nvim')
	set inccommand=nosplit
endif

let g:AutoPairsMultilineClose = 0 " disable weird pairing behaviour

cnoreabbrev w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit! " save as sudo

autocmd CursorHold * silent call CocActionAsync('highlight') " highlight symbol
autocmd SwapExists * let v:swapchoice = "e" | echomsg "swap exists"

autocmd BufRead * if getline(1) == '#!/usr/bin/dash' | set filetype=sh | endif " fix dash syntax highlighting

" C highlighting
silent! autocmd BufRead,BufNewFile *.c,*.h,*.hpp,*.cpp silent! hi PreProc ctermfg=35 guifg=#8ed5e5
silent! autocmd BufRead,BufNewFile *.c,*.h,*.hpp,*.cpp silent! match Operator /[\<\>\?\{\}\:\+\=\|\.\-\&\*,;!]/
silent! autocmd BufRead,BufNewFile *.c,*.h,*.hpp,*.cpp silent! 2match Special /[(){}]/

autocmd BufRead *.pl,*.pm let g:ale_enabled = 0 " disables ale for perl
autocmd BufWritePost *sxhkdrc !killall sxhkd; nohup sxhkd & rm nohup.out; " reload key bindings
autocmd BufNewFile,BufRead * setlocal formatoptions-=ro " disable autocomment

" tab spacing
autocmd BufNewFile,BufRead *.dart set autoindent expandtab tabstop=4 shiftwidth=4
autocmd BufNewFile,BufRead *.json set autoindent expandtab tabstop=4 shiftwidth=4

" skeleton
autocmd BufNewFile,BufRead *.h set filetype=c
autocmd BufNewFile *.c,*.cpp 0r ~/.config/nvim/templates/skeleton.c | $delete _
autocmd BufNewFile *.pl,*.pm 0r ~/.config/nvim/templates/skeleton.pl

" visible cursor and parens
highlight CursorLine ctermbg=none guibg=#3c3836
highlight CursorColumn ctermbg=none guibg=#3c3836
highlight MatchParen guifg=white guibg=none
" completion menu
highlight Pmenu ctermbg=none ctermfg=15 guibg=none guifg=#ffffff
" hi PmenuSel ctermfg=Black ctermbg=none gui=reverse

" undodir
let vimDir = '$HOME/.vim'
if stridx(&runtimepath, expand(vimDir)) == -1
	" vimDir is not on runtimepath, add it
	let &runtimepath.=','.vimDir
endif
if has('persistent_undo')
	let myUndoDir = expand(vimDir . '/undodir')
	" Create dirs
	call system('mkdir ' . vimDir)
	call system('mkdir ' . myUndoDir)
	let &undodir = myUndoDir
	set undofile
endif

" only let ale use clang-tidy
let g:ale_linters = {
	\ 'cpp': ['clangtidy'],
	\ 'c': ['clangtidy']
\ }

let g:ale_c_clangtidy_checks = ['-clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling', 'clang-analyzer-security.insecureAPI.strcpy']
let g:ale_cpp_clangtidy_checks = ['-clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling', 'clang-analyzer-security.insecureAPI.strcpy']
let g:ale_lint_on_save = 1
let g:vimtex_view_method = 'zathura'
let g:vimtex_compiler_method = 'latexmk'
let g:Hexokinase_highlighters = ['backgroundfull'] " depends on hexokinase

" for coc-nvim autocomplete
function! CheckBackspace() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]	=~# '\s'
endfunction

" compile latex
" nnoremap cc :VimtexCompile<CR>:VimtexCompile<CR>
" nnoremap C :VimtexCompile<CR>

" spellcheck
" noremap <C-n> :set nospell!<CR>
" set spell spelllang=en_us

" function! Complete__()
" 	let output = system("/home/james/c/cnlp/correct " . expand('<cword>'))
" 	let completions = split(output, "\n")
" 	return completions
" endfunction

" set omnifunc=Complete__
