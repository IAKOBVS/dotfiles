call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-commentary'
Plug 'vim-airline/vim-airline'
Plug 'preservim/nerdtree'
Plug 'tribela/vim-transparent'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
Plug 'lervag/vimtex'
Plug 'bkad/CamelCaseMotion'
Plug 'mechatroner/rainbow_csv'
Plug 'godlygeek/tabular'
Plug 'dart-lang/dart-vim-plugin'
Plug 'vim-scripts/LargeFile'
Plug 'jiangmiao/auto-pairs'
Plug 'dense-analysis/ale'
Plug 'tpope/vim-surround'
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim', {'do': ':MasonUpdate'}
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'L3MON4D3/LuaSnip'
Plug 'VonHeikemen/lsp-zero.nvim', {'branch': 'v2.x'}
call plug#end()

" defaults
filetype plugin indent on
colorscheme murphy
set number relativenumber
set linebreak
set nohlsearch
set incsearch
" use as much memory as possible
set maxmempattern=2000000
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
" disable switch case indent
set cinoptions+=:0

" copy paste
vnoremap <C-c> "+y
vnoremap <C-d> "+y:delete<Return>
map <C-p> <F1> :set paste "+P :set nopaste <F1>
map <C-p> <F1> :set paste "+p :set nopaste <F1>
vnoremap <C-c> "*y :let @+=@*<CR>

function! TabularizeMacro()
	let lnum = line('.')
	execute '/^$\\ze\\n{/;/^}$/normal! vip:substitute/\\zs$/\\\\/ | ' . &tabstop . 'retab'
	call cursor(lnum, 1)
endfunction
vnoremap ff :call TabularizeMacro()<CR>

" tabularize C macros
nmap <Leader>f VggVG:Tabularize /\\$<CR>
vmap ff :Tabularize /\\$<CR>

nnoremap <space>o :History<CR>
nnoremap <space>h :cd ~ \| Files<CR>
nnoremap <space>f :call fzf#vim#files(expand('%:p:h'))<CR>
nnoremap <space>r :Rg<CR>
" open new terminal with cwd
nnoremap <space>s :w<CR>:let @a=expand('%')<CR>:silent !sd % >/dev/null 2>&1 & disown &<CR>:e!<CR>:let &modified=0<CR>:let @" = @a<CR>

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

" respect camelCase
map <silent>w <Plug>CamelCaseMotion_w
map <silent>b <Plug>CamelCaseMotion_b
map <silent>e <Plug>CamelCaseMotion_e
map <silent>ge <Plug>CamelCaseMotion_ge
sunmap w
sunmap b
sunmap e
sunmap ge

" ctrl + s to save
map <C-s> :w<Return>
" J and K to jump between paragraphs
map J }
map K {
map <C-j> <C-d>
map <C-k> <C-u>
" q to quote; q unquote -- depends on vim-surround
map q ysiw"hxp
nmap Q F"xf"x

" disable autoquote
" let b:coc_pairs_disabled = ['"',"'",'<','>']
" let b:coc_pairs_disabled = ['<','>']

" spellcheck
" noremap <C-n> :set nospell!<Return>
" set spell spelllang=en_us

" set termguicolors
if has('nvim')
	autocmd VimEnter * call timer_start(8, { tid -> execute(':set termguicolors')})
endif

" vim insert cursor mode
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" vimtex
let g:vimtex_view_method = 'zathura'
let g:vimtex_compiler_method = 'latexmk'
map cc :VimtexCompile<Return>:VimtexCompile<Return>
map C :VimtexCompile<Return>

" save as sudo
cabbrev w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" transparent vim with st
if has('nvim')
	set termguicolors
	hi NormalFloat guibg=none
	hi VertSplit guibg=none
	hi FoldColumn guibg=none
	hi SignColumn guibg=none
	hi LineNr guibg=none
	hi CursorLineNr guibg=none
	hi Normal ctermbg=none guibg=none
endif

" tab spacing
autocmd BufNewFile,BufRead *.dart set autoindent expandtab tabstop=4 shiftwidth=4
" disable autocomment
autocmd BufNewFile,BufRead * setlocal formatoptions-=ro

" enter for accepting completion
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
	\: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]	=~# '\s'
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" tab j and tab + k for navigating errors
nmap <silent> <tab>k <Plug>(coc-diagnostic-prev)
nmap <silent> <tab>j <Plug>(coc-diagnostic-next)

set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" ctrl + j and ctrl + k for navigating completions
inoremap <silent><expr> <C-j>
	\ coc#pum#visible() ? coc#pum#next(1) :
	\ CheckBackspace() ? "\<Tab>" :
	\ coc#refresh()
inoremap <expr><C-k>
	\ coc#pum#visible() ? coc#pum#prev(1) :
	\ "\<C-h>"

" Recolor C macros
silent! autocmd BufRead,BufNewFile *.c,*.h,*.hpp,*.cpp silent! hi PreProc ctermfg=35 guifg=#8ed5e5
silent! autocmd BufRead,BufNewFile *.c,*.h,*.hpp,*.cpp silent! match Operator /[\<\>\?\{\}\:\+\=\|\.\-\&\*,;!]/
silent! autocmd BufRead,BufNewFile *.c,*.h,*.hpp,*.cpp silent! 2match Special /[(){}]/

" Change the color of completion menu
hi CursorLine ctermbg=none guibg=#3c3836
hi CursorColumn ctermbg=none guibg=#3c3836
hi Pmenu ctermbg=none ctermfg=15 guibg=none guifg=#ffffff
hi MatchParen guifg=white guibg=none
hi link Function Function
" hi PmenuSel ctermfg=Black ctermbg=none gui=reverse
" disables ale for perl
autocmd BufRead *.pl,*.pm let g:ale_enabled = 0
" automatically edits swap warning
autocmd SwapExists * let v:swapchoice = "e" | echomsg "swap exists"
autocmd BufRead * if getline(1) == '#!/usr/bin/dash' | set filetype=sh | endif
autocmd VimEnter * call timer_start(8, { tid -> execute(':set spelllang=id_id')})
" recompile suckless programs
autocmd BufWritePost config.h,config.def.h,blocks.h !sudo make install
" reload key bindings 
autocmd BufWritePost *sxhkdrc !killall sxhkd; nohup sxhkd & rm nohup.out;
" skeleton
autocmd BufNewFile,BufRead *.h set filetype=c
autocmd BufNewFile *.c,*.cpp 0r ~/.config/nvim/templates/skeleton.c | $delete _
autocmd BufNewFile *.pl 0r ~/.config/nvim/templates/skeleton.pl

" only let ale use clang-tidy
let g:ale_linters = {
\	'cpp': ['clangtidy'],
\	'c': ['clangtidy']
\}

let g:Hexokinase_highlighters = ['backgroundfull']
let g:ale_c_cc_options = '-Wall -Wextra -Wshadow -Warray-bounds -Wuninitialized'
let g:ale_c_clangtidy_checks = ['-clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling']
let g:ale_cpp_cc_options = '-Wall -Wextra -Wshadow -Warray-bounds -Wshadow -Wuninitialized'
let g:ale_cpp_clangtidy_checks = ['-clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling']
" let g:ale_clang_cxx_standard = 'c++17'
" let g:ale_cpp_options = '-std=gnu++17'
" disable weird pairing behaviour
let g:AutoPairsMultilineClose = 0

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
