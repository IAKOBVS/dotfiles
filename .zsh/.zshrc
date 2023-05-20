#!/bin/zsh
export __NPROC__=$(nproc 2>/dev/null || sysctl -n hw.logicalcpu 2>/dev/null || getconf _NPROCESSORS_ONLN 2>/dev/null)

. $HOME/.zsh/.zsh_aliases 2>/dev/null
. $HOME/.zsh/.shell_functions 2>/dev/null
cd

if [ -f /bin/fd ]; then
	export FZF_DEFAULT_COMMAND="fd -j $__NPROC__ --hidden --glob \
		--exclude '*png' \
		--exclude '*jpg' \
		--exclude '*jpeg' \
		--exclude '*mov' \
		--exclude '*vscode*' \
		--exclude '*git*'\
		--exclude '*.virtualenv*'\
		--exclude '*.rev*'\
		--exclude '*.o'\
		--exclude '*.cargo*'\
		--exclude '*.pass*'\
		--exclude '*.key*'"
else
	export FZF_DEFAULT_COMMAND="find \
		! -path '*png' \
		! -path '*jpg' \
		! -path '*jpeg' \
		! -path '*mov' \
		! -path '*vscode*' \
		! -path '*git*'\
		! -path '*.virtualenv*'\
		! -path '*.rev*'\
		! -path '*.o'\
		! -path '*.cargo*'\
		! -path '*.pass*'\
		! -path '*.key*'"
fi

# Enable colors and change prompt:
# autoload -U colors && colors	# Load colors
PS1="%B%{$fg[white]%}[%{$fg[white]%}%n%{$fg[white]%}@%{$fg[white]%}%M %{$fg[white]%}%~%{$fg[white]%}]%{$reset_color%}$%b "
setopt autocd		# Automatically cd into typed directory.
stty stop undef		# Disable ctrl-s to freeze terminal.
setopt interactive_comments

# History in cache directory:
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history"

# Basic auto/tab complete:
# autoload -U compinit
# compinit
# zstyle ':completion:*' menu select
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

bindkey -s '^f' 'fzfvim $PWD\n'
bindkey -s '^e' 'fzfexact\n'
bindkey -s '^h' 'cd ~; fzfvim $PWD\n'
bindkey -s '^o' 'lfcd\n'
bindkey -s '^r' 'grepvim\n'

bindkey '^[[P' delete-char

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^v' edit-command-line
bindkey -M vicmd '^[[P' vi-delete-char
bindkey -M vicmd '^e' edit-command-line
bindkey -M visual '^[[P' vi-delete

(pgrep xcape > /dev/null || remaps > /dev/null &)

# Load syntax highlighting; should be last.
. /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh 2>/dev/null
bindkey '^L' autosuggest-accept
. /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh 2>/dev/null
