#!/bin/sh
mkdir -p /tmp/__ram_bin__
__load_bin__() { cp -rf $@ /tmp/__ram_bin__ 2>/dev/null; }
(__load_bin__ /usr/bin/$TERMINAL &)
(__load_bin__ /usr/bin/$EDITOR &)
unset __load_bin__
startx
