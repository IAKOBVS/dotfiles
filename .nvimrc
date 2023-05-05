call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'vim-airline/vim-airline'
Plug 'preservim/nerdtree'
Plug 'tribela/vim-transparent'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'lervag/vimtex'
Plug 'bkad/CamelCaseMotion'
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
Plug 'mechatroner/rainbow_csv'
Plug 'godlygeek/tabular'
Plug 'jiangmiao/auto-pairs'
Plug 'vim-scripts/LargeFile'
" lsp
Plug 'dense-analysis/ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim', {'do': ':MasonUpdate'}
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'L3MON4D3/LuaSnip'
Plug 'VonHeikemen/lsp-zero.nvim', {'branch': 'v2.x'}
" dart
Plug 'dart-lang/dart-vim-plugin'
call plug#end()

" copy paste
vnoremap <C-d> "+y:delete<Return>
vnoremap <C-c> "*y :let @+=@*<CR>
map <C-p> "+P
map <C-s> :w<Return> " ctrl + s (save)

" J and K to jump between paragraphs
map J }
map K {
map <C-j> <C-d>
map <C-k> <C-u>
" q to quote; q unquote -- depends on vim-surround
map q ysiw"hxp
nmap Q F"xf"x
vmap ff :Tabularize /\\$<CR> " tabularize C macros

nnoremap <space>l :History<CR>
nnoremap <space>h :cd ~ \| Files<CR>
nnoremap <space>f :call fzf#vim#files(expand('%:p:h'))<CR>
nnoremap <space>r :Rg<CR>

" open cwd in new terminal
nnoremap <space>s :w<CR>:let @a=expand('%')<CR>:silent !sd % >/dev/null 2>&1 & disown &<CR>:e!<CR>:let &modified=0<CR>:let @" = @a<CR>

" navigaet errors
nmap <silent> <tab>k <Plug>(coc-diagnostic-prev)
nmap <silent> <tab>j <Plug>(coc-diagnostic-next)

function! TabularizeMacro()
	let lnum = line('.')
	execute '/^$\\ze\\n{/;/^}$/normal! vip:substitute/\\zs$/\\\\/ | ' . &tabstop . 'retab'
	call cursor(lnum, 1)
endfunction
vnoremap ff :call TabularizeMacro()<CR>

" ctrl + j and ctrl + k for navigating completions
inoremap <silent><expr> <C-j>
	\ coc#pum#visible() ? coc#pum#next(1) :
	\ CheckBackspace() ? "\<Tab>" :
	\ coc#refresh()
inoremap <expr><C-k>
	\ coc#pum#visible() ? coc#pum#prev(1) :
	\ "\<C-h>"

" respect camelCase
map <silent>w <Plug>CamelCaseMotion_w
map <silent>b <Plug>CamelCaseMotion_b
map <silent>e <Plug>CamelCaseMotion_e
map <silent>ge <Plug>CamelCaseMotion_ge
sunmap w
sunmap b
sunmap e
sunmap ge

colorscheme murphy
if has('nvim')
	set termguicolors
endif
hi NormalFloat guibg=none
hi VertSplit guibg=none
hi FoldColumn guibg=none
hi SignColumn guibg=none
hi LineNr guibg=none
hi CursorLineNr guibg=none
hi Normal ctermbg=none guibg=none

" vim insert cursor mode
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" defaults
filetype plugin indent on
set number relativenumber
set linebreak
set nohlsearch
set incsearch
set maxmempattern=2000000 " use more ram
set mouse=a
set modifiable
set encoding=utf-8
set nobackup
set nowritebackup
set updatetime=300
set signcolumn=yes
set nocompatible
set pastetoggle=<F1>
set inccommand=nosplit
set cinoptions+=:0 " disable switch indent

set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

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

" st fix
" set t_8f=^[[38;2;%lu;%lu;%lum	" set foreground color
" set t_8b=^[[48;2;%lu;%lu;%lum	" set background color
" set t_Co=256 " Enable 256 colors

" disable autoquote
" let b:coc_pairs_disabled = ['"',"'",'<','>']
" let b:coc_pairs_disabled = ['<','>']

" spellcheck
" noremap <C-n> :set nospell!<Return>
" set spell spelllang=en_us

" vimtex
let g:vimtex_view_method = 'zathura'
let g:vimtex_compiler_method = 'latexmk'
map cc :VimtexCompile<Return>:VimtexCompile<Return>
map C :VimtexCompile<Return>

" save as sudo
cabbrev w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" enter for accepting completion
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
	\: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]	=~# '\s'
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')
autocmd SwapExists * let v:swapchoice = "e" | echomsg "swap exists"

" automatically edits swap warning
autocmd BufRead * if getline(1) == '#!/usr/bin/dash' | set filetype=sh | endif
autocmd VimEnter * call timer_start(8, { tid -> execute(':set spelllang=id_id')})

" Recolor C macros
silent! autocmd BufRead,BufNewFile *.c,*.h,*.hpp,*.cpp silent! hi PreProc ctermfg=35 guifg=#8ed5e5
silent! autocmd BufRead,BufNewFile *.c,*.h,*.hpp,*.cpp silent! match Operator /[\<\>\?\{\}\:\+\=\|\.\-\&\*,;!]/
silent! autocmd BufRead,BufNewFile *.c,*.h,*.hpp,*.cpp silent! 2match Special /[(){}]/

" Change the color of completion menu
hi CursorLine ctermbg=none guibg=#3c3836
hi CursorColumn ctermbg=none guibg=#3c3836
hi Pmenu ctermbg=none ctermfg=15 guibg=none guifg=#ffffff
hi MatchParen guifg=white guibg=none
" hi link Function Function
" hi PmenuSel ctermfg=Black ctermbg=none gui=reverse

" disables ale for perl
autocmd BufRead *.pl,*.pm let g:ale_enabled = 0

" recompile suckless programs
autocmd BufWritePost config.h,config.def.h,blocks.h !sudo make install
" reload key bindings 
autocmd BufWritePost *sxhkdrc !killall sxhkd; nohup sxhkd & rm nohup.out;

" skeleton
autocmd BufNewFile,BufRead *.h set filetype=c
autocmd BufNewFile *.c,*.cpp 0r ~/.config/nvim/templates/skeleton.c | $delete _
autocmd BufNewFile *.pl 0r ~/.config/nvim/templates/skeleton.pl

" tab spacing
autocmd BufNewFile,BufRead *.dart set autoindent expandtab tabstop=4 shiftwidth=4
" disable autocomment
autocmd BufNewFile,BufRead * setlocal formatoptions-=ro

" set termguicolors
if has('nvim')
	autocmd VimEnter * call timer_start(8, { tid -> execute(':set termguicolors')})
endif

" only let ale use clang-tidy
let g:ale_linters = {
\	'cpp': ['clangtidy'],
\	'c': ['clangtidy']
\}

let g:Hexokinase_highlighters = ['backgroundfull']
let g:ale_c_cc_options = '-Wall -Wextra -Wshadow -Warray-bounds -Wuninitialized'
let g:ale_c_clangtidy_checks = ['-clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling', 'clang-analyzer-security.insecureAPI.strcpy']
let g:ale_cpp_cc_options = '-Wall -Wextra -Wshadow -Warray-bounds -Wshadow -Wuninitialized'
let g:ale_cpp_clangtidy_checks = ['-clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling', 'clang-analyzer-security.insecureAPI.strcpy']
" let g:ale_clang_cxx_standard = 'c++17'
" let g:ale_cpp_options = '-std=gnu++17'
" disable weird pairing behaviour

let g:AutoPairsMultilineClose = 0

" lsp
lua <<EOF
local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
	lsp.default_keymaps({buffer = bufnr})
end)

-- (Optional) Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()

require'lspconfig'.perlnavigator.setup{
	settings = {
		perlnavigator = {
			perlPath = 'perl',
			enableWarnings = true,
			perltidyProfile = '',
			perlcriticProfile = '',
			perlcriticEnabled = true,
		}
	}
}
EOF

" function! Complete__()
" 	let output = system("/home/james/c/cnlp/correct " . expand('<cword>'))
" 	let completions = split(output, "\n")
" 	return completions
" endfunction

" set omnifunc=Complete__
