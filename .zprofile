#!/bin/sh
mkdir -p /tmp/__ram_bin__
($HOME/.local/bin/scripts/resr &)
startx
wait
