#!/bin/sh

# Don't run in SSH
[ "$SSH_CLIENT" ] && return

export COMPOSITOR=fastcompmgr
export AUR_HELPER=yay
export LOG_DIR=$HOME/.cache

if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

# CPU fan speed control
sudo cfan >>$LOG_DIR/cfan.log 2>>$LOG_DIR/cfan.log &

# GPU fan speed control
sudo nvspeed >>$LOG_DIR/nvspeed.log 2>>$LOG_DIR/nvspeed.log &

# Set compositor for terminal transparency
$COMPOSITOR 2>$LOG_DIR/fastcompmgr.log &

# Set wallpaper
# xwallpaper --maximize /home/james/.local/share/wallpaper/bg.png &
feh --bg-fill /home/james/.local/share/wallpaper/bg.png &

# turn off webcam
sudo modprobe -r uvcvideo

# Terminal
$TERMINAL &

# change esc with caps lock
remaps

# Nvidia max out power limit
sudo nvidia-smi -pl $(nvidia-smi -q -d POWER | awk '/Max Power Limit/ && !/N\/A/ { print $5 }')

# Hide mouse cursor
unclutter --no-timeout --hide-on-key-press &

# Notification
dunst &

# checkaudioport | grep -q -F 'lineout' && pulseaudio-equalizer disable &
# jamesdsp -t &

# Warm up bluetooth
# { bluetoothctl & sleep 2 && killall bluetoothctl; } &

# Cache installed packages
nice -n 19 $AUR_HELPER -Sl | cut -f 2 -d ' ' >"$HOME"/.cache/$AUR_HELPER/__list_of_packages__ &

# Only save unique commands in zsh history
HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history"
([ -f "$HISTFILE" ] && nice -n 19 uniq -u "$HISTFILE" >"$HISTFILE.bak" && rm "$HISTFILE" && mv "$HISTFILE.bak" "$HISTFILE" &)
unset HISTFILE

# Set sxiv image background
xrdb $HOME/.Xresources &

if ps -e -o comm | grep -q -F 'systemd'; then
	systemctl --user start pipewire.service
	systemctl --user start pipewire-pulse.service
	systemctl --user start wireplumber.service
else
	pipewire &
	pipewire-pulse &
	wireplumber &
fi

{
	# Statusbar
	retry=5
	while [ $retry -gt 0 ]; do
		dwmblocks-fast >>$LOG_DIR/dwmblocks-fast.log 2>> $LOG_DIR/dwmblocks-fast.log && exit
		# Retry
		retry=$((retry - 1))
		sleep 1
		for pid in $(ps -e -o comm --no-headers | grep -F -e 'dwmblocks-fast'); do
			kill -15 "$pid"
		done
	done
	unset retry
	echo "dwmblocks-fast: can not run program"
	exit 1 
} &

discord &
thunderbird &
nv-tearfree-on

while :; do
	dwm
done
