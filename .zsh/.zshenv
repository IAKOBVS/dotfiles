PATH="$HOME/.local/bin/scripts:$PATH"
export PATH="/tmp/__ram_bin__:$PATH"
export TERM=alacritty
export TERMINAL=alacritty
export TERMINAL_PROG=alacritty
export EDITOR=nvim
export BROWSER=brave
export FZF_DEFAULT_OPTS='--height 80% --layout=reverse --border'
export GCM_CREDENTIAL_CACHE_OPTIONS='--timeout 99999999999999999999999999999999999999999999999999999999999999999999999999999'
export GTK_THEME=Adwaita:dark
export QT_STYLE_OVERRIDE=adwaita-dark

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
