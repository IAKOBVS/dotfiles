#!/bin/sh
test "$SSH_CLIENT" && return
xwallpaper --maximize /home/james/.local/share/wallpaper/bg.png &
picom -b --config $HOME/.config/picom.conf &
$TERMINAL &
(cd /tmp; nohup $HOME/.local/bin/remaps &)
sudo "$HOME"/c/nvtemp/nvtemp &
unclutter &
dwmblocks &
dunst &
sudo updatedb &
xrdb $HOME/.Xresources &
sudo nvidia-smi -pl 150 &
checkaudioport | grep -q -F 'lineout' && pulseaudio-equalizer disable &
ufzf &
__update_paru_list__ &
__fzfvim_cleanup__ &
__update_vim_aliases__ &
# qbittorrent &
while :; do
	ssh-agent dwm
done
