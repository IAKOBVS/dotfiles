#!/bin/sh

# Don't run in SSH
[ "$SSH_CLIENT" ] && return

if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

export COMPOSITOR=xcompmgr
export AUR_HELPER=yay
XINITRC_LOG_DIR="$HOME/.cache"
export UEBERZUG_LOG_FILE="$XINITRC_LOG_DIR"/ueberzug.log

# GPU fan speed control
rm "$XINITRC_LOG_DIR/nvspeed.log"
sudo nvspeed >>"$XINITRC_LOG_DIR/nvspeed.log" 2>>"$XINITRC_LOG_DIR/nvspeed.log" &

# CPU fan speed control
rm "$XINITRC_LOG_DIR/cfan.log"
sudo cfan >>"$XINITRC_LOG_DIR/cfan.log" 2>>"$XINITRC_LOG_DIR/cfan.log" &

# Optimize kernel scheduler
rm "$XINITRC_LOG_DIR/scx_lavd.log"
sudo scx_lavd >>"$XINITRC_LOG_DIR/scx_lavd.log" 2>>"$XINITRC_LOG_DIR/scx_lavd.log" &

# Trim SSD
rm "$XINITRC_LOG_DIR/fstrim.log"
sudo fstrim -av >>"$XINITRC_LOG_DIR/fstrim.log" 2>>"$XINITRC_LOG_DIR/fstrim.log" &

# Turn off wifi
nmcli radio wifi off &

# Set compositor for terminal transparency
rm "$XINITRC_LOG_DIR/$COMPOSITOR.log"
$COMPOSITOR -n >>"$XINITRC_LOG_DIR/$COMPOSITOR.log" 2>>"$XINITRC_LOG_DIR/$COMPOSITOR.log" &

# Set wallpaper
# xwallpaper --maximize /home/james/.local/share/wallpaper/bg.png &
feh --bg-fill /home/james/.local/share/wallpaper/bg.png &
# feh --bg-fill /home/james/Downloads/wallpaper-black.png &

# turn off webcam
# sudo modprobe -r uvcvideo &

# Terminal
$TERMINAL &

# change esc with caps lock
remaps &

# Nvidia max out power limit
sudo nvidia-smi -pl "$(nvidia-smi -q -d POWER | awk '/Max Power Limit/ && !/N\/A/ { print; exit; }' | sed 's/^.*:[ \t]*\([0-9.]*\).*$/\1/')" &
# Nvidia max out target temperature
# sudo nvidia-smi -gtt "$(nvidia-smi -q -d TEMPERATURE | awk '/GPU Slowdown Temp/ {print $(NF-1)}')" &

# Hide mouse cursor
unclutter --hide-on-key-press &

# Notification
dunst &

# checkaudioport | grep -q -F 'lineout' && pulseaudio-equalizer disable &
# jamesdsp -t &

# Warm up bluetooth
# { bluetoothctl & sleep 2 && killall bluetoothctl; } &

# Cache packages
nice -n 19 $AUR_HELPER -Sl | cut -f 2 -d ' ' >"$HOME/.cache/$AUR_HELPER/__list_of_packages__" &

# Only save unique commands in zsh history
HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history"
if [ -f "$HISTFILE" ]; then
	nice -n 19 uniq -u "$HISTFILE" >"$HISTFILE.bak" &&
		rm "$HISTFILE" &&
		mv "$HISTFILE.bak" "$HISTFILE"
fi &

# Set sxiv image background
xrdb "$HOME/.Xresources" &

{
	# Sync time with ntp
	sudo ntpd -g -q && sudo hwclock --systohc
	rm "$XINITRC_LOG_DIR/dwmblocks-fast.log"
	dwmblocks-fast >>"$XINITRC_LOG_DIR/dwmblocks-fast.log" 2>>"$XINITRC_LOG_DIR/dwmblocks-fast.log"
} &


discord &
thunderbird &
nv-tearfree-on &

([ -d "$HOME/.cache/lf" ] && rm -rf "$HOME/.cache/lf"
[ -d "$HOME/.cache/ctpv" ] && rm -rf "$HOME/.cache/ctpv"
[ -d "$HOME/.cache/ueberzugpp" ] && rm -rf "$HOME/.cache/ueberzugpp")


# Cache file size
# nice -n 19 ionice -c 3 du -shc $HOME/* &

# Defragment
(
	rm "$XINITRC_LOG_DIR/e4defrag.log"
	set -eu
	SCORE_FILE="$XINITRC_LOG_DIR/e4defrag-score.log"
	for partition in $(lsblk -rno MOUNTPOINT,FSTYPE,ROTA | awk '$2=="ext4" && $3=="1" {print $1}'); do
		nice -n 19 ionice -c 3 sudo e4defrag -c "$partition" | awk '/Fragmentation score/ {print $3}' > "$SCORE_FILE"
		if [ "$(cat "$SCORE_FILE")" -gt 30 ]; then
			nice -n 19 ionice -c 3 sudo e4defrag "$partition" >>"$XINITRC_LOG_DIR/e4defrag.log" 2>>"$XINITRC_LOG_DIR/e4defrag.log"
			sudo drop-caches
		fi
	done
	unset partition
	unset SCORE_FILE
) &

mv "$XINITRC_LOG_DIR/$AUR_HELPER/__list_of_packages__" "$XINITRC_LOG_DIR/$AUR_HELPER/__list_of_packages__.bak"
$AUR_HELPER -Q > "$XINITRC_LOG_DIR/$AUR_HELPER/__list_of_packages__" &

while :; do
	rm "$XINITRC_LOG_DIR/dwm.log"
	dwm >>"$XINITRC_LOG_DIR/dwm.log" 2>>"$XINITRC_LOG_DIR/dwm.log"
done
