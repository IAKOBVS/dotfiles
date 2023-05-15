#!/bin/zsh
__NPROC__=$(nproc)
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

# Enable colors and change prompt:
autoload -U colors && colors	# Load colors
PS1="%B%{$fg[white]%}[%{$fg[white]%}%n%{$fg[white]%}@%{$fg[white]%}%M %{$fg[white]%}%~%{$fg[white]%}]%{$reset_color%}$%b "
setopt autocd		# Automatically cd into typed directory.
stty stop undef		# Disable ctrl-s to freeze terminal.
setopt interactive_comments

# History in cache directory:
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history"

# Load aliases and shortcuts if existent.
. $HOME/.zsh_aliases

# Basic auto/tab complete:
# autoload -U compinit
# compinit
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

bindkey -s '^f' 'fzfvim\n'
bindkey -s '^e' 'fzfvim --exact\n'
bindkey -s '^o' 'lfcd_\n'
bindkey -s '^r' 'rgvim_\n'

bindkey '^[[P' delete-char

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^v' edit-command-line
bindkey -M vicmd '^[[P' vi-delete-char
bindkey -M vicmd '^e' edit-command-line
bindkey -M visual '^[[P' vi-delete

(pgrep xcape > /dev/null || remaps > /dev/null)

__vim_prog__=$(mktemp -uq)
__vim_arg__=$(mktemp -uq)
__lf_cd__=$(mktemp -uq)
export __vim_prog__
export __vim_arg__
export __lf_cd__
(touch $__vim_prog__ &)
(touch $__vim_arg__ &)
(touch $__lf_cd__ &)
trap 'rm -f $__lf_cd__ >/dev/null 2>&1 && trap - HUP INT QUIT TERM PWR EXIT' HUP INT QUIT TERM PWR EXIT
trap 'rm -f $__vim_prog__ >/dev/null 2>&1 && trap - HUP INT QUIT TERM PWR EXIT' HUP INT QUIT TERM PWR EXIT
trap 'rm -f $__vim_arg__ >/dev/null 2>&1 && trap - HUP INT QUIT TERM PWR EXIT' HUP INT QUIT TERM PWR EXIT

fzfvim()
{
	file=$(fzfdef $1)
	echo $file
	test $file || return
	if [ -f "$file" ]; then
		vimcd $file
	else
		lfcd $file
	fi
}

lfcd () {
	lf -last-dir-path="$__lf_cd__" "$@"
	if [ -f "$__lf_cd__" ]; then
		__lf_dir__="$(cat "$__lf_cd__")"
		[ -d "$__lf_dir__" ] && [ "$__lf_dir__" != "$(pwd)" ] && cd "$__lf_dir__"
	fi
}

vimcd()
{
	case $1 in
	'')
		(fzf_update_dir $file &)
		__vim_cmd__=$EDITOR
		;;
	*)
		file=$(realpath "${@##* }")
		if [ -f $file ]; then
			cd ${file%/?*}
			__vim_cmd__=$EDITOR
		elif [ -d $file ]; then
			cd $file
			__vim_cmd__=lfcd
		fi
	esac
	$__vim_cmd__ $@ &&
	{
		__local_vim_prog__=$(<$__vim_prog__)
		__local_vim_arg__=$(<$__vim_arg__)
		(echo >$__vim_prog__ &)
		(echo >$__vim_arg__ &)
		clear
		$__local_vim_prog__ "$__local_vim_arg__"
	}
}

# Load syntax highlighting; should be last.
. /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
bindkey '^L' autosuggest-accept
. /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
