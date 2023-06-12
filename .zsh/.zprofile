#!/bin/sh
(__update_paru_list__ &)
mkdir -p /tmp/__ram_bin__
__load_bin__() { cp -f $@ /tmp/__ram_bin__ 2>/dev/null ;}
(__load_bin__ /usr/bin/$TERMINAL &)
(__load_bin__ /usr/bin/$EDITOR &)

(__load_bin__ /usr/bin/find &)
(__load_bin__ /usr/bin/cat &)
(cp -f /usr/bin/gawk /tmp/__ram_bin__/awk &)
(__load_bin__ /usr/bin/grep &)
(__load_bin__ /usr/bin/sed &)

(__load_bin__ $HOME/.local/bin/scripts/rgrep &)

unset __load_bin__
startx
