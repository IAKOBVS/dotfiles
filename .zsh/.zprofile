#!/bin/sh
(__update_fzf__ &)
(__update_paru_list__ &)
mkdir -p /tmp/__ram_bin__
__load_bin__() { cp -rf $@ /tmp/__ram_bin__ 2>/dev/null ;}
(__load_bin__ /usr/bin/$TERMINAL &)
(__load_bin__ /usr/bin/$EDITOR &)
(__load_bin__ /usr/bin/zsh &)
(__load_bin__ /usr/bin/catvr &)
(__load_bin__ /usr/bin/find &)
(__load_bin__ /usr/bin/grep &)
(__load_bin__ /usr/bin/cat &)
unset __load_bin__
startx
