#!/bin/sh

# Don't run in SSH
[ "$SSH_CLIENT" ] && return

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# Don't remove steam cache
export __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1

# Set wallpaper
xwallpaper --maximize /home/james/.local/share/wallpaper/bg.png &
# Compositor for transparency
picom -b --config "$HOME"/.config/picom.conf &
# Statusbar
dwmblocks-fast &
# Terminal
$TERMINAL &
#shellcheck disable=SC2164
(cd /tmp; nohup "$HOME"/.local/bin/scripts/remaps & rm nohup.out &)
# GPU fan speed control
sudo "$HOME"/c/nvspeed/nvspeed &
# CPU fan speed control (managed by systemd)
# sudo fan2go &
# Nvidia overclocking
# sudo nvidia-smi -pl 150 &
# Hide mouse cursor
unclutter &
# Notification
dunst &
# Xresources
# xrdb "$HOME"/.Xresources &

# checkaudioport | grep -q -F 'lineout' && pulseaudio-equalizer disable &
# jamesdsp -t &
# qbittorrent &
{ bluetoothctl & sleep 2 && killall bluetoothctl; } &
paru -Sl | cut -f 2 -d ' ' > "$HOME"/.cache/paru/__list_of_packages__ &
fzfvim-cleanup &

while :; do
	ssh-agent dwm
done
