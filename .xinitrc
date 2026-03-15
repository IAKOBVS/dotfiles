#!/bin/sh

# Don't run in SSH
[ "$SSH_CLIENT" ] && return

if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

export COMPOSITOR=picom
export AUR_HELPER=yay
export LOG_DIR="$HOME/.cache"

# Sync time with ntp
sudo ntpd -g -q &

# Turn off wifi
nmcli radio wifi off &

# CPU fan speed control
sudo cfan >>"$LOG_DIR/cfan.log" 2>>"$LOG_DIR/cfan.log" &

# GPU fan speed control
sudo nvspeed >>"$LOG_DIR/nvspeed.log" 2>>"$LOG_DIR/nvspeed.log" &

# Set compositor for terminal transparency
$COMPOSITOR 2>>"$LOG_DIR/$COMPOSITOR.log" &

# Set wallpaper
# xwallpaper --maximize /home/james/.local/share/wallpaper/bg.png &
feh --bg-fill /home/james/.local/share/wallpaper/bg.png &
# feh --bg-fill /home/james/Downloads/wallpaper-hd-1080.png &

# turn off webcam
sudo modprobe -r uvcvideo

# Terminal
$TERMINAL &

# change esc with caps lock
remaps

# Nvidia max out power limit
sudo nvidia-smi -pl "$(nvidia-smi -q -d POWER | awk '/Max Power Limit/ && !/N\/A/ { print; exit; }' | sed 's/^.*:[ \t]*\([0-9.]*\).*$/\1/')"

# Hide mouse cursor
unclutter --no-timeout --hide-on-key-press &

# Notification
dunst &

# checkaudioport | grep -q -F 'lineout' && pulseaudio-equalizer disable &
# jamesdsp -t &

# Warm up bluetooth
# { bluetoothctl & sleep 2 && killall bluetoothctl; } &

# Cache installed packages
(nice -n 19 $AUR_HELPER -Sl | cut -f 2 -d ' ' >"$HOME/.cache/$AUR_HELPER/__list_of_packages__" &)

# Only save unique commands in zsh history
HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history"
([ -f "$HISTFILE" ] && nice -n 19 uniq -u "$HISTFILE" >"$HISTFILE.bak" && rm "$HISTFILE" && mv "$HISTFILE.bak" "$HISTFILE" &)
unset HISTFILE

# Set sxiv image background
xrdb "$HOME/.Xresources" &

nice -n 19 dwmblocks-fast >>"$LOG_DIR/dwmblocks-fast.log" 2>>"$LOG_DIR/dwmblocks-fast.log" &

discord &
thunderbird &
nv-tearfree-on

while :; do
	dwm
done
