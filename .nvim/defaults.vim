nn ;nv :source $HOME/.nvim/init.vim<CR>

" autocd
au BufNewFile,BufEnter * sil! lcd %:p:h
" autoupdate zsh aliases
au BufWritePost *zsh*alias* sil! !__update_vim_aliases__ &
au BufWritePost *.shell_functions*,.z* sil! !__recompile_zsh_scripts__ &
" cleanup fzfvim temp variables
sil au BufEnter,BufRead,BufEnter * if filereadable(expand('%:p')) | sil! exe '!/bin/rm -f $__VIM_PROG__ & /bin/rm -f $__VIM_ARG__ & echo %:p >$__VIM_LAST_FILE__ &' | endif

" execute cmd after vim exits
fu ExitCmd(dir, prog, arg)
	sil! exe '!echo '.a:dir.' >$__LF_DIR__ & echo '.a:prog.'>$__VIM_PROG__; echo '.a:arg.' >$__VIM_ARG__'
	x
endf

" cno <C-W> <S-Right>
" cno <C-B> <S-Right>
" cno <C-A> <C-Right>
" cno <C-I> <C-Left>
" cno <C-L> <Right>
" cno <C-H> <Left>

" '<'>

" fu SearchReplace(visual)
" 	cal inputsave()
" 	let l:input = input('s/')
" 	cal inputrestore()
" 	let l:find = substitute(l:input, '^.*/', '', '')
" 	let l:replace = substitute(l:input, '^.*/', '', '')
" 	let l:replace = substitute(l:input, '/.*$', '', '')
" 	let l:global = match(l:input, 'g$')
" 	exe ':' . (a:visual ? "'<,'>" : '%') . 's/\([^_0-9A-Zl-z]\|^\)' . l:find . '\([^0-9A-Zl-z]\|$\)/\1' . l:replace . '\2/' . ((l:global == -1) ? '' : 'g')
" endf

" vn <leader>s <Esc>:cal SearchReplace(1)<CR>
" nn <leader>s :cal SearchReplace(0)<CR>

vn <leader>s :s/\([^_0-9A-Za-z]\\|^\)\([^0-9A-Za-z]\\|$\)/\1\2/g<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
nn <leader>s :%s/\([^_0-9A-Za-z]\\|^\)\([^0-9A-Za-z]\\|$\)/\1\2/g<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
cno <C-R> <C-Right><Left><Left><Left><Left>

nn <leader>c :!compiler %:p<CR>

nn <space>l :cal ExitCmd('%:p:h', '$__LFCD__', '%:p')<CR>
nn <space>o :cal ExitCmd('%:p:h', '$__LFCD__', '%:p')<CR>

nn <C-f> :cal ExitCmd('%:p:h', '$__FZF__', '%:p:h')<CR>
nn <C-h> :cal ExitCmd('$HOME', '$__FZF__', '$HOME')<CR>

nn <space>f :cal ExitCmd('%:p:h', '$__FZFLIVE__', '%:p:h')<CR>
nn <space>h :cal ExitCmd('$HOME', '$__FZFLIVEHOME__', '$HOME')<CR>

nn <space>r :cal ExitCmd('%:p:h', '$__GREPVIM__', '%:p:h')<CR>
nn <space>i :cal ExitCmd('%:p', '$__GREPVIM__', '%:p')<CR>

" open cwd in new terminal
nn <space>s :!exec $TERMINAL &<CR><CR>

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
no <C-s> :w<CR>

" turn off vim macros
map q <Nop>

" quote $variable
nn qs lF$lciw<Esc>i""<Esc>i$<Esc>pf$xh
nn Qs F"xf"xh
nn QS Qs

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
if has('termguicolors')
	se termguicolors
en

" transparency
hi NormalFloat ctermbg=none guibg=none
hi VertSplit ctermbg=none guibg=none
hi FoldColumn ctermbg=none guibg=none
hi SignColumn ctermbg=none guibg=none
hi LineNr ctermbg=none guibg=none
hi CursorLineNr ctermbg=none guibg=none
hi Normal ctermbg=none guibg=none
hi EndOfBuffer guibg=none ctermbg=none

filet plugin indent on
se wildmode=longest,full,full
se maxmempattern=2000000 " use more ram
se cinoptions+=:0 " disable switch indent
se number relativenumber
se wrap!
" se linebreak
" se nohlsearch
se incsearch
se mouse=a
se encoding=utf-8
se nobackup
se nowritebackup
se updatetime=300
se signcolumn=yes
if has('nvim')
	se inccommand=nosplit " incremental search
en

" save as sudo
cnorea w!! execute 'sil! write !sudo tee % >/dev/null' <bar> edit!
" disable swap startup warning
au SwapExists * let v:swapchoice = "e" | echom "swap exists"

" C highlighting
au BufRead,BufNewFile *.c,*.h,*.hpp,*.cpp sil! hi PreProc ctermfg=35 guifg=#8ed5e5
sil! au BufRead,BufNewFile *.c,*.h,*.hpp,*.cpp sil! mat Operator /[\<\>\?\{\}\:\+\=\|\.\-\&\*,;!]/
sil! au BufRead,BufNewFile *.c,*.h,*.hpp,*.cpp sil! 2mat Special /[(){}]/
" disable autocomment
au FileType * setl formatoptions-=c formatoptions-=r formatoptions-=o
au BufNewFile,BufRead *.h se filetype=c
" 4-space tabs
au BufNewFile,BufRead *.dart se autoindent expandtab tabstop=4 shiftwidth=4
au BufNewFile,BufRead *.json se autoindent expandtab tabstop=4 shiftwidth=4
au BufNewFile,BufRead *.ejs,*.html se filetype=html autoindent expandtab tabstop=4 shiftwidth=4
" format current file
au FileType c,cpp nm ;cfm :sil! exec "!cfm %:p"<CR>
au FileType sh,bash,zsh nm ;cfm :sil! exec "!shfmt -w -fn %:p"<CR>

let g:__templateDir__ = expand($HOME).'/.nvim/templates'
if filereadable(g:__templateDir__.'/skeleton.c')
\ && filereadable(g:__templateDir__.'/skeleton.pl')
\ && filereadable(g:__templateDir__.'/skeleton.awk')
	au BufNewFile,BufRead *.c,*.cpp if __FileEmpty__() | 0r ~/.nvim/templates/skeleton.c | $delete _
	au BufNewFile,BufRead *.pl,*.pm if __FileEmpty__() | 0r ~/.nvim/templates/skeleton.pl
	au BufNewFile,BufRead *.awk if __FileEmpty__() | 0r ~/.nvim/templates/skeleton.awk
en

au BufWritePost *sxhkdrc !killall sxhkd; nohup sxhkd & rm nohup.out;

" visible cursor and parens
hi MatchParen guifg=white guibg=none

" undodir
let myVimDir = '$HOME/.vim'
" add if !myVimDir
if stridx(&runtimepath, expand(myVimDir)) == -1
	let &runtimepath.=','.myVimDir
en
if has('persistent_undo')
	let myUndoDir = expand(myVimDir . '/undodir')
	" Create dirs
	cal system('mkdir ' . myVimDir)
	cal system('mkdir ' . myUndoDir)
	let &undodir = myUndoDir
	se undofile
en

fu __FileEmpty__()
	if line('$') == 1 && empty(getline(1))
		return 1
	en
	return 0
endf

" hi CursorLine ctermbg=none guibg=#2c3836
" hi CursorColumn ctermbg=none guibg=#3c3836
" completion menu
" hi Pmenu ctermbg=none ctermfg=14 guibg=none guifg=#ffffff
" hi PmenuSel ctermfg=Black ctermbg=none gui=reverse
