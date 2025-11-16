nnoremap ;nv :source $HOME/.nvim/init.vim<CR>

" autocd
autocmd BufNewFile,BufEnter * silent! lcd %:p:h
" autoupdate zsh aliases
autocmd BufWritePost *zsh*alias* silent! !__update_vim_aliases__ &
autocmd BufWritePost *.shell_functions*,.z* silent! !__recompile_zsh_scripts__ &
" cleanup fzfvim temp variables
silent autocmd BufEnter,BufRead,BufEnter * if filereadable(expand('%:p')) | silent! execute '!/bin/rm -f $__VIM_PROG__ & /bin/rm -f $__VIM_ARG__ & echo %:p >$__VIM_LAST_FILE__ &' | endif

" execute cmd after vim exits
function ExitCmd(dir, prog, arg)
	silent! execute '!echo '.a:dir.' >$__LF_DIR__ & echo '.a:prog.'>$__VIM_PROG__; echo '.a:arg.' >$__VIM_ARG__'
	xit
endfunction

function SearchReplace(visual)
	call inputsave()
	let l:input = input('s/')
	call inputrestore()
	if l:input == '' || l:input !~ '^.\{1,\}/'
		return
	endif
	let l:replace = substitute(l:input, '^[^/]*/', '', '')
	let l:replace = substitute(l:replace, '/[^/]*$', '', '')
	let l:g = (l:input =~ '/[^/]*/g$') ? 'g' : ''
	let l:find = substitute(l:input, '/.*$', '', '')
	execute ':' . (a:visual ? "'<,'>" : '%') . 's/\([^"''%_0-9A-Za-z]\|^\)' . l:find . '\([^"''%_0-9A-Za-z]\|$\)/\1' . l:replace . '\2/' . l:g
endfunction

vnoremap <space>s <Esc>:call SearchReplace(1)<CR>
nnoremap <space>s :call SearchReplace(0)<CR>

nnoremap <leader>c :!tcc -run %:p<CR>
nnoremap ;cc :!gcc -O3 -march=native %:p; ./a.out<CR>

nnoremap <space>l :call ExitCmd('%:p:h', '$__LFCD__', '%:p')<CR>
nnoremap <space>o :call ExitCmd('%:p:h', '$__LFCD__', '%:p')<CR>

nnoremap <C-f> :call ExitCmd('%:p:h', '$__FZF__', '%:p:h')<CR>
nnoremap <C-h> :call ExitCmd('$HOME', '$__FZF__', '$HOME')<CR>

nnoremap <space>f :call ExitCmd('%:p:h', '$__FZFLIVE__', '%:p:h')<CR>
nnoremap <space>h :call ExitCmd('$HOME', '$__FZFLIVEHOME__', '$HOME')<CR>

nnoremap <space>r :call ExitCmd('%:p:h', '$__GREPVIM__', '%:p:h')<CR>
nnoremap <space>c :call ExitCmd('%:p', '$__GREPVIM__', '--max-depth=1')<CR>

" open cwd in new terminal
nnoremap <space>t :!exec $TERMINAL &<CR><CR>

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
noremap <C-s> :w<CR>

" turn off vim macros
map q <Nop>

" quote $variable
nnoremap qs lF$lciw<Esc>i""<Esc>i$<Esc>pf$xh
nnoremap Qs F"xf"xh
nnoremap QS Qs

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

colo murphy
if has('termguicolors')
	set termguicolors
endif

" transparency
highlight NormalFloat ctermbg=none guibg=none
highlight VertSplit ctermbg=none guibg=none
highlight FoldColumn ctermbg=none guibg=none
highlight SignColumn ctermbg=none guibg=none
highlight LineNr ctermbg=none guibg=none
highlight CursorLineNr ctermbg=none guibg=none
highlight Normal ctermbg=none guibg=none
highlight EndOfBuffer guibg=none ctermbg=none

filet plugin indent on
set wildmode=longest,full,full
set maxmempattern=2000000 " use more ram
set cinoptions+=:0 " disable switch indent
set number relativenumber
set wrap!
if 0
	set linebreak
	set nohlsearch
endif
set incsearch
set mouse=a
set encoding=utf-8
set nobackup
set nowritebackup
set updatetime=300
set signcolumn=yes
if has('nvim')
	set inccommand=nosplit " incremental search
endif

" save as sudo
cnorea w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!
" disable swap startup warning
autocmd SwapExists * let v:swapchoice = "e" | echomsg "swap exists"

" C highlighting
autocmd BufRead,BufNewFile *.c,*.h,*.hpp,*.hh,*.cpp,*.cc silent! highlight PreProc ctermfg=35 guifg=#8ed5e5
silent! autocmd BufRead,BufNewFile *.c,*.h,*.hpp,*.hh,*.cpp,*.cc silent! match Operator /[\<\>\?\:\+\=\|\.\-\&\*,;!]/
silent! autocmd BufRead,BufNewFile *.c,*.h,*.hpp,*.hh,*.cpp,*.cc silent! 2match Special /[(){}]/
" disable autocomment
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
autocmd BufNewFile,BufRead *.h set filetype=c
" 4-space tabs
autocmd BufNewFile,BufRead *.dart set autoindent expandtab tabstop=4 shiftwidth=4
autocmd BufNewFile,BufRead *.json set autoindent expandtab tabstop=4 shiftwidth=4
autocmd BufNewFile,BufRead *.ejs,*.html set filetype=html autoindent expandtab tabstop=4 shiftwidth=4
" format current file
autocmd FileType c,cpp,java,javascript,typescript,json,cs nmap ;cfm :w!<CR>:silent! exec "!cfm %:p"<CR>
autocmd FileType sh,bash,zsh nmap ;cfm :w!<CR>:silent! exec "!shfmt -w -fn %:p"<CR>
autocmd FileType perl nmap ;cfm :w!<CR>:silent !pfmt %:p<CR>
autocmd FileType go nmap ;cfm :w!<CR>:silent !gfmt %:p<CR>
autocmd FileType c,cpp,perl nmap ;bu :silent !./build &<CR>
autocmd FileType c,cpp nmap ;ga :silent !gasm %:p &<CR>
autocmd FileType c,cpp nmap ;vga :silent !vgasm %:p &<CR>
autocmd FileType c,cpp nmap ;coe :silent !coe %:p<CR>
autocmd FileType c,cpp nmap ;fa gg<S-V>G:Tabularize /\\$<CR><C-o>
autocmd FileType text set wrap linebreak spell

let g:__templateDir__ = expand($HOME).'/.nvim/templates'
if filereadable(g:__templateDir__.'/skeleton.c')
\ && filereadable(g:__templateDir__.'/skeleton.pl')
\ && filereadable(g:__templateDir__.'/skeleton.awk')
	autocmd BufNewFile,BufRead *.c,*.cc,*.cpp if __FileEmpty__() | 0r ~/.nvim/templates/skeleton.c | $delete _
	autocmd BufNewFile,BufRead *.pl,*.pm if __FileEmpty__() | 0r ~/.nvim/templates/skeleton.pl
	autocmd BufNewFile,BufRead *.awk if __FileEmpty__() | 0r ~/.nvim/templates/skeleton.awk
endif

autocmd BufWritePost *sxhkdrc !killall sxhkd; nohup sxhkd & rm nohup.out;

" visible cursor and parens
highlight MatchParen guifg=white guibg=none

" undodir
let myVimDir = '$HOME/.vim'
" add if !myVimDir
if stridx(&runtimepath, expand(myVimDir)) == -1
	let &runtimepath.=','.myVimDir
endif
if has('persistent_undo')
	let myUndoDir = expand(myVimDir . '/undodir')
	" Create dirs
	call system('mkdir ' . myVimDir)
	call system('mkdir ' . myUndoDir)
	let &undodir = myUndoDir
	set undofile
endif

function __FileEmpty__()
	if line('$') == 1 && empty(getline(1))
		return 1
	endif
	return 0
endfunction

if 0
	highlight CursorLine ctermbg=none guibg=#2c3836
	highlight CursorColumn ctermbg=none guibg=#3c3836
	" completion menu
	highlight Pmenu ctermbg=none ctermfg=14 guibg=none guifg=#ffffff
	highlight PmenuSel ctermfg=Black ctermbg=none gui=reverse
endif
