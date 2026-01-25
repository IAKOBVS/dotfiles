#!/bin/sh

# Don't run in SSH
[ "$SSH_CLIENT" ] && return

if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

# Don't remove steam cache
export __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1

# Set compositor for terminal transparency
export COMPOSITOR=xcompmgr
$COMPOSITOR &

# Set wallpaper
# xwallpaper --maximize /home/james/.local/share/wallpaper/bg.png &
feh --bg-fill /home/james/.local/share/wallpaper/bg.png &

# turn off webcam
sudo modprobe -r uvcvideo

# Terminal
$TERMINAL &

# change esc with caps lock
remaps

# GPU fan speed control
sudo nice -n 19 nvspeed &

# CPU fan speed control (managed by systemd)
# sudo fan2go &

# Nvidia overclocking
# sudo nvidia-smi -pl 150 &

# Hide mouse cursor
nice -n 19 unclutter --no-timeout --hide-on-key-press &

# Notification
nice -n 19 dunst &

# checkaudioport | grep -q -F 'lineout' && pulseaudio-equalizer disable &
# jamesdsp -t &

# Warm up bluetooth
# { bluetoothctl & sleep 2 && killall bluetoothctl; } &

# Cache installed packages
nice -n 19 paru -Sl | cut -f 2 -d ' ' >"$HOME"/.cache/paru/__list_of_packages__ &

# Cpu fan controller
sudo renice 19 -p $(pgrep fan2go) &

# Only save unique commands in zsh history
HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history"
([ -f "$HISTFILE" ] && nice -n 19 uniq -u "$HISTFILE" >"$HISTFILE.bak" && rm "$HISTFILE" && mv "$HISTFILE.bak" "$HISTFILE" &)
unset HISTFILE

# Put this in Steam Launch Options
# __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1 %command% -sdlaudiodriver pulse

# Set sxiv image background
xrdb $HOME/.Xresources &

{
	systemctl --user start pipewire.socket
	systemctl --user start pipewire.service
	systemctl --user start wireplumber.service

	# TODO: fix
	# Statusbar
	retry=10
	while [ $retry -gt 0 ]; do
		if ps -e -o comm | grep -q -F 'pipewire'; then
			nice -n 19 dwmblocks-fast
			break
		fi
		retry=$((retry - 1))
		sleep 1
	done
	unset retry
} &

while :; do
	dwm
done
