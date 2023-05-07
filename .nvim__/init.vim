source ~/.nvim__/plugins.vim
nnoremap <C-n>v :source ~/.nvimrc<CR>

" motions

" jump between paragraphs
map J }
map K {
map <C-j> <C-d>
map <C-k> <C-u>

" copy paste
vnoremap <C-d> "+y:delete<CR>
vnoremap <C-c> "*y :let @+=@*<CR>
nnoremap cc <S-v> "*y :let @+=@*<CR>
noremap <C-p> "+P
noremap <C-s> :w<CR>h

" surround with symbols

" turn off macros
map q <Nop>

" quote shell $variable
nnoremap qb lF$dEi""<Esc>hpl
nnoremap Qb F"xf"xh
nnoremap QB Qb

" quote word
nnoremap qq lbdEi""<Esc>hpl
nnoremap QQ F"xf"xh
nnoremap Qq QQ

nnoremap q' lbdEi''<Esc>hpl
nnoremap Q' F'xf'xh

nnoremap q9 lbdEi()<Esc>hpl
nnoremap Q9 F(xf)xh

nnoremap q, lbdEi<><Esc>hpl
nnoremap Q, F<xf>xh
nnoremap q. q,
nnoremap Q. Q,

nnoremap q- lbdEi__<Esc>hpl
nnoremap Q- F_xf_xh
nnoremap q_ q-
nnoremap Q_ Q-

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

cnoreabbrev w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit! " save as sudo

autocmd SwapExists * let v:swapchoice = "e" | echomsg "swap exists"
autocmd BufRead * if getline(1) == '#!/usr/bin/dash' | set filetype=sh | endif " fix dash syntax highlighting

" C highlighting
autocmd BufRead,BufNewFile *.c,*.h,*.hpp,*.cpp silent! hi PreProc ctermfg=35 guifg=#8ed5e5
silent! autocmd BufRead,BufNewFile *.c,*.h,*.hpp,*.cpp silent! match Operator /[\<\>\?\{\}\:\+\=\|\.\-\&\*,;!]/
silent! autocmd BufRead,BufNewFile *.c,*.h,*.hpp,*.cpp silent! 2match Special /[(){}]/

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
