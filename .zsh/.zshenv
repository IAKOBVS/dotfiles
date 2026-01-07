export PATH="/tmp/__ram_bin__:$HOME/.local/bin/scripts:$HOME/.local/bin:$PATH"
export TERM=alacritty
export TERMINAL=alacritty
export TERMINAL_PROG=alacritty
export EDITOR=nvim
export BROWSER=brave
export FZF_DEFAULT_OPTS='--height 95% --layout=reverse --bind alt-j:preview-up,alt-k:preview-down --bind alt-h:backward-char,alt-l:forward-char'
export GTK_THEME=Adwaita:dark
export QT_STYLE_OVERRIDE=adwaita-dark
export __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1

if [ -f /bin/fd ]; then
	export FZF_DEFAULT_COMMAND="fd -j $(nproc) --hidden --glob \
		--exclude '*png' \
		--exclude '*jpg' \
		--exclude '*jpeg' \
		--exclude '*mov' \
		--exclude '*vscode*' \
		--exclude '*git*'\
		--exclude '*.virtualenv*'\
		--exclude '*.rev*'\
		--exclude '*.o'\
		--exclude '*.cargo*'\
		--exclude '*.pass*'\
		--exclude '*.key*'"
else
	export FZF_DEFAULT_COMMAND="find \
		! -path '*png' \
		! -path '*jpg' \
		! -path '*jpeg' \
		! -path '*mov' \
		! -path '*vscode*' \
		! -path '*git*'\
		! -path '*.virtualenv*'\
		! -path '*.rev*'\
		! -path '*.o'\
		! -path '*.cargo*'\
		! -path '*.pass*'\
		! -path '*.key*'"
fi
