#!/bin/sh
[ "$SSH_CLIENT" ] && return
xwallpaper --maximize /home/james/.local/share/wallpaper/bg.png &
picom -b --config "$HOME"/.config/picom.conf &
dwmblocks &
$TERMINAL &
#shellcheck disable=SC2164
(cd /tmp; nohup "$HOME"/.local/bin/scripts/remaps &)
sudo "$HOME"/c/nvspeed/nvspeed &
# sudo nvidia-smi -pl 150 &
unclutter &
dunst &
xrdb "$HOME"/.Xresources &
checkaudioport | grep -q -F 'lineout' && pulseaudio-equalizer disable &
# jamesdsp -t &
# qbittorrent &
{ bluetoothctl & sleep 2 && killall bluetoothctl; } &
/usr/local/code/c/jstring/src/update-copyright &
/usr/local/code/c/jstring/src/fmt /usr/local/code/c/jstring/src/*.h &
paru -Sl | cut -f 2 -d ' ' > "$HOME"/.cache/paru/__list_of_packages__ &
export __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1
while :; do
	ssh-agent dwm
done
