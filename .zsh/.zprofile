#!/bin/sh

# Don't run in SSH
[ "$SSH_CLIENT" ] && return

exec startx
