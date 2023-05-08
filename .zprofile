#!/usr/bin/dash
mkdir -p /tmp/__ram_bin__
$HOME/.local/bin/alias/resr &
PATH="$PATH:${$(find ~/.local/bin -type d -printf %p:)%%:}"
wait
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
startx
