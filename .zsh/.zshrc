#!/bin/zsh

. $HOME/.zsh/.zsh_aliases 2>/dev/null
. $HOME/.zsh/.shell_functions 2>/dev/null

getBranch() {
    git rev-parse --abbrev-ref HEAD 2> /dev/null
}

# cleanup unused tmp files
if command -v pgrep >/dev/null; then
	(test -z "$(pgrep 'fzfvim-cleanup')" >/dev/null && fzfvim-cleanup &)
else
	(test -z "$(ps -ef | awk '{ if ($8 ~ /fzfvim-cleanup/) {exist=1; exit; } } END { print exist; }')" >/dev/null && fzfvim-cleanup &)
fi

setopt PROMPT_SUBST

# Enable colors and change prompt:
autoload -U colors && colors	# Load colors
PS1="%B%{$fg[white]%}[%{$fg[white]%}%n%{$fg[white]%}@%{$fg[white]%}%M %{$fg[white]%}%~%{$fg[white]%} \$(getBranch)]%{$reset_color%}$%b "
setopt autocd		# Automatically cd into typed directory.
stty stop undef		# Disable ctrl-s to freeze terminal.
setopt interactive_comments

# History in cache directory:
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history"
([ -f $HISTFILE ] && sed -i '/poweroff/d; /reboot/d' $HISTFILE &)

# Basic auto/tab complete:
autoload -U compinit
compinit
zstyle ':completion:*' menu select

zmodload zsh/complist
_comp_options+=(globdots) # Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # block
        viins|main) echo -ne '\e[5 q';; # beam
    esac
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init

bindkey '^[[P' delete-char

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line
bindkey -M vicmd '^[[P' vi-delete-char
bindkey -M vicmd '^e' edit-command-line
bindkey -M visual '^[[P' vi-delete

bindkey -s '^f' 'fzflive $PWD\n'
# bindkey -s '^e' 'fzfexact\n'
bindkey -s '^o' 'lfcd\n'
bindkey -s '^r' 'grepvim\n'
(pgrep xcape > /dev/null || remaps > /dev/null &)

ZSH_AUTOSUGGEST_MANUAL_REBIND=0

# Load syntax highlighting; should be last.
. /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
bindkey '^L' autosuggest-accept

export _JAVA_AWT_WM_NONREPARENTING=1

# . /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh 2>/dev/null
