#!/usr/bin/dash
mkdir -p /tmp/__ram_bin__
$HOME/.local/bin/alias/resr &
PATH="$PATH:${$(find ~/.local/bin -type d -printf %p:)%%:}"
wait
startx
