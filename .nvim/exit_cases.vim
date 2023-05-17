nn <C-f> :!sil echo %:p:h >$__LF_DIR__ &
	\ echo $__FZF__ > $__VIM_PROG__ ;
	\ echo %:p > $__VIM_ARG__<CR> ZZ
nn <C-h> :!sil echo %:p:h >$__LF_DIR__ &
	\ echo $__FZF__ > $__VIM_PROG__ ;
	\ echo $HOME > $__VIM_ARG__<CR> ZZ
nn <C-e> :!sil echo %:p:h >$__LF_DIR__ &
	\ echo $__FZFEXACT__ > $__VIM_PROG__ ;
	\ echo $HOME > $__VIM_ARG__<CR> ZZ
nn <C-o> :!sil echo %:p:h >$__LF_DIR__ &
	\ echo $__LFCD__ > $__VIM_PROG__ ;
	\ echo %:p > $__VIM_ARG__<CR> ZZ
nn <space>f :!sil echo %:p:h >$__LF_DIR__ &
	\ echo $__FZFLIVE__ > $__VIM_PROG__ ;
	\ echo %:p > $__VIM_ARG__<CR> ZZ
nn <space>h :!sil echo %:p:h >$__LF_DIR__ &
	\ echo $__FZFLIVE__ > $__VIM_PROG__ ;
	\ echo $HOME > $__VIM_ARG__<CR> ZZ
nn <space>e :!sil echo %:p:h >$__LF_DIR__ &
	\ echo $__FZFEXACTLIVE__ > $__VIM_PROG__ ;
	\ echo $HOME > $__VIM_ARG__<CR> ZZ
