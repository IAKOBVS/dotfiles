export PATH="$HOME/.local/bin/scripts:$HOME/.local/bin:$PATH"
export COMPOSITOR=fastcompmgr
export TERM=st
export TERMINAL=st
export TERMINAL_PROG=st
export EDITOR=nvim
export BROWSER=chromium
export FZF_DEFAULT_OPTS='--height 95% --layout=reverse --bind alt-j:preview-up,alt-k:preview-down --bind alt-h:backward-char,alt-l:forward-char'
export GTK_THEME=Adwaita:dark
export QT_STYLE_OVERRIDE=kvantum
# export __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1
export CUDA_DISABLE_PERF_BOOST=1
export FZF_DEFAULT_COMMAND="find \
		! -path '*.git*' \
		! -path '*.o' \
		! -path '*.png' \
		! -path '*.jpg' \
		! -path '*.jpeg' \
		! -path '*.mov' \
		! -path '*.virtualenv*' \
		! -path '*.o' \
		! -path '*.cargo*' \
		! -path '*.pass*' \
		! -path '*.key*' \
		! -path '*node_modules*' \
		! -path '*.key*'"
