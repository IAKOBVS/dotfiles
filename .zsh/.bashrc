[[ $- != *i* ]] && return

set -o vi
export PS1
PS1='[\u@\H \W $(git branch 2>/dev/null | grep '"'"' ^* '"'"' | colrm 1 2)] '

HISTSIZE=10000
HISTFILESIZE=10000
HISTFILE=~/.cache/zsh/history

. $HOME/.zsh/.zsh_aliases
. $HOME/.zsh/.shell_functions

bind -x '"\C-f": "fzflive"'
bind -x '"\C-o": "lfcd"'
bind -x '"\C-r": "grepvim"'

# . /usr/share/blesh/ble.sh

# [[ ${BLE_VERSION-} ]] && ble-attach

# # ble-0.4+
# ble-bind -m vi_nmap --cursor 2
# ble-bind -m vi_imap --cursor 5
# ble-bind -m vi_omap --cursor 4
# ble-bind -m vi_xmap --cursor 2
# ble-bind -m vi_cmap --cursor 0

# # ble-0.2 and 0.3
# bleopt keymap_vi_nmap_cursor:=2
# bleopt keymap_vi_imap_cursor:=5
# bleopt keymap_vi_omap_cursor:=4
# bleopt keymap_vi_xmap_cursor:=2
# bleopt keymap_vi_cmap_cursor:=0

# bleopt exec_errexit_mark=
