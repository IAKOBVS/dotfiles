nn nvim :source ~/.nvimrc<CR>
au BufEnter * sil! lcd %:p:h
se wildmode=longest,full,full
au FileType * setl formatoptions-=c formatoptions-=r formatoptions-=o
map cfm :!cfm %:p<CR>

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

" turn off vim macros
map q <Nop>

" surround word with symbol

" quote $variable
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

colo murphy
if has('nvim')
	se termguicolors
en
hi NormalFloat guibg=none
hi VertSplit guibg=none
hi FoldColumn guibg=none
hi SignColumn guibg=none
hi LineNr guibg=none
hi CursorLineNr guibg=none
hi Normal ctermbg=none guibg=none

filet plugin indent on
se cinoptions+=:0 " disable switch indent
se number relativenumber
se linebreak
se nohlsearch
se incsearch
se maxmempattern=2000000 " use more ram
se pastetoggle=<F1>
se mouse=a
se encoding=utf-8
se nobackup
se nowritebackup
se updatetime=300
se signcolumn=yes
se modifiable
se nocompatible
if has('nvim')
	se inccommand=nosplit
en

" save as sudo
cnorea w!! execute 'sil! write !sudo tee % >/dev/null' <bar> edit!

au SwapExists * let v:swapchoice = "e" | echom "swap exists"
au BufRead * if getline(1) == '#!/usr/bin/dash' | se filetype=sh | en

" C highlighting
au BufRead,BufNewFile *.c,*.h,*.hpp,*.cpp sil! hi PreProc ctermfg=35 guifg=#8ed5e5
sil! au BufRead,BufNewFile *.c,*.h,*.hpp,*.cpp sil! mat Operator /[\<\>\?\{\}\:\+\=\|\.\-\&\*,;!]/
sil! au BufRead,BufNewFile *.c,*.h,*.hpp,*.cpp sil! 2mat Special /[(){}]/

au BufWritePost *sxhkdrc !killall sxhkd; nohup sxhkd & rm nohup.out;
au BufNewFile,BufRead *.dart se autoindent expandtab tabstop=4 shiftwidth=4 " tab spacing
au BufNewFile,BufRead *.json se autoindent expandtab tabstop=4 shiftwidth=4
au BufNewFile,BufRead *.h se filetype=c " skeleton
au BufNewFile *.c,*.cpp 0r ~/.config/nvim/templates/skeleton.c | $delete _
au BufNewFile *.pl,*.pm 0r ~/.config/nvim/templates/skeleton.pl

" visible cursor and parens
hi MatchParen guifg=white guibg=none
hi CursorLine ctermbg=none guibg=#3c3836
hi CursorColumn ctermbg=none guibg=#3c3836
" completion menu
hi Pmenu ctermbg=none ctermfg=15 guibg=none guifg=#ffffff
" hi PmenuSel ctermfg=Black ctermbg=none gui=reverse

" undodir
let vimDir = '$HOME/.vim'
if stridx(&runtimepath, expand(vimDir)) == -1
	let &runtimepath.=','.vimDir " add if !vimDir
en
if has('persistent_undo')
	let myUndoDir = expand(vimDir . '/undodir')
	" Create dirs
	cal system('mkdir ' . vimDir)
	cal system('mkdir ' . myUndoDir)
	let &undodir = myUndoDir
	se undofile
en
