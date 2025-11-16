#!/bin/bash
. $HOME/.zsh/.bashrc
[ -f /opt/miniforge/etc/profile.d/conda.sh ] && source /opt/miniforge/etc/profile.d/conda.sh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/miniforge/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/miniforge/etc/profile.d/conda.sh" ]; then
        . "/opt/miniforge/etc/profile.d/conda.sh"
    else
        export PATH="/opt/miniforge/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

