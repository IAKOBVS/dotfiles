#!/bin/sh
[ "$SSH_CLIENT" ] && return
xwallpaper --maximize /home/james/.local/share/wallpaper/bg.png &
picom -b --config "$HOME"/.config/picom.conf &
dwmblocks &
$TERMINAL &
#shellcheck disable=SC2164
(cd /tmp; nohup "$HOME"/.local/bin/scripts/remaps & rm nohup.out &)
sudo "$HOME"/c/nvspeed/nvspeed &
# sudo nvidia-smi -pl 150 &
unclutter &
dunst &
xrdb "$HOME"/.Xresources &

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

checkaudioport | grep -q -F 'lineout' && pulseaudio-equalizer disable &
# jamesdsp -t &
# qbittorrent &
{ bluetoothctl & sleep 2 && killall bluetoothctl; } &
/usr/local/code/c/jstring/src/update-copyright &
/usr/local/code/c/jstring/src/fmt /usr/local/code/c/jstring/src/*.h &
paru -Sl | cut -f 2 -d ' ' > "$HOME"/.cache/paru/__list_of_packages__ &
sudo fan2go &
export __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1
# redshift &
auto-dark-mode &

while :; do
	ssh-agent dwm
done
