#!/usr/bin/dash
mkdir -p /tmp/__ram_bin__
$HOME/.local/bin/alias/resr &
PATH="$HOME/.local/bin/scripts:$PATH"
wait
startx
