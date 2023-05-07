so ~/.nvim__/plugins.vim
nn nvim :source ~/.nvimrc<CR>

" motions

" jump between paragraphs
map J }
map K {
map <C-j> <C-d>
map <C-k> <C-u>

" copy paste
vn <C-d> "+y:delete<CR>
vn <C-c> "*y :let @+=@*<CR>
nn cc <S-v> "*y :let @+=@*<CR>
no <C-p> "+P
no <C-s> :w<CR>h

" surround with symbols

" turn off macros
map q <Nop>

" quote shell $variable
nn qs lF$dEi""<Esc>hpl
nn Qs F"xf"xh
nn QS Qs

" quote word
nn qq lbdEi""<Esc>hpl
nn QQ F"xf"xh
nn Qq QQ

nn q' lbdEi''<Esc>hpl
nn Q' F'xf'xh

nn q9 lbdEi()<Esc>hpl
nn Q9 F(xf)xh

nn q, lbdEi<><Esc>hpl
nn Q, F<xf>xh
nn q. q,
nn Q. Q,

nn q- lbdEi__<Esc>hpl
nn Q- F_xf_xh
nn q_ q-
nn Q_ Q-

colorscheme murphy
if has('nvim')
	se termguicolors
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
	se inccommand=nosplit
endif

cnoreabbrev w!! execute 'sil! write !sudo tee % >/dev/null' <bar> edit! " save as sudo

au SwapExists * let v:swapchoice = "e" | echomsg "swap exists"
au BufRead * if getline(1) == '#!/usr/bin/dash' | se filetype=sh | endif " fix dash syntax highlighting

" C highlighting
au BufRead,BufNewFile *.c,*.h,*.hpp,*.cpp sil! hi PreProc ctermfg=35 guifg=#8ed5e5
sil! au BufRead,BufNewFile *.c,*.h,*.hpp,*.cpp sil! mat Operator /[\<\>\?\{\}\:\+\=\|\.\-\&\*,;!]/
sil! au BufRead,BufNewFile *.c,*.h,*.hpp,*.cpp sil! 2mat Special /[(){}]/

au BufWritePost *sxhkdrc !killall sxhkd; nohup sxhkd & rm nohup.out; " reload key bindings
au BufNewFile,BufRead * setlocal formatoptions-=ro " disable autocomment

" tab spacing
au BufNewFile,BufRead *.dart se autoindent expandtab tabstop=4 shiftwidth=4
au BufNewFile,BufRead *.json se autoindent expandtab tabstop=4 shiftwidth=4

" skeleton
au BufNewFile,BufRead *.h se filetype=c
au BufNewFile *.c,*.cpp 0r ~/.config/nvim/templates/skeleton.c | $delete _
au BufNewFile *.pl,*.pm 0r ~/.config/nvim/templates/skeleton.pl

" visible cursor and parens
hi CursorLine ctermbg=none guibg=#3c3836
hi CursorColumn ctermbg=none guibg=#3c3836
hi MatchParen guifg=white guibg=none
" completion menu
hi Pmenu ctermbg=none ctermfg=15 guibg=none guifg=#ffffff
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
	cal system('mkdir ' . vimDir)
	cal system('mkdir ' . myUndoDir)
	let &undodir = myUndoDir
	se undofile
endif
