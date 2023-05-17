#!/bin/sh
test "$SSH_CLIENT" && return
xwallpaper --maximize /home/james/.local/share/wallpaper/bg.png &
picom -b --config $HOME/.config/picom.conf &
dwmblocks &
$TERMINAL &
__update_fzf__ &
__update_paru_list__ &
__cleanup_fzfvim__ &
(cd /tmp; nohup $HOME/.local/bin/remaps &)
sudo $HOME/c/nvtemp/nvtemp &
sudo nvidia-smi -pl 150 &
unclutter &
dunst &
xrdb $HOME/.Xresources &
checkaudioport | grep -q -F 'lineout' && pulseaudio-equalizer disable &
sudo updatedb &
# qbittorrent &
while :; do
	ssh-agent dwm
done
