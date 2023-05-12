#!/usr/bin/dash
mkdir -p /tmp/__ram_bin__
$HOME/.local/bin/scripts/resr &
PATH="$HOME/.local/bin/scripts:$PATH"
PATH="/tmp/__ram_bin__:$PATH"
wait
startx
