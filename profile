# vim:ts=2:sw=2:et

# local binaries
export PATH="$HOME/.local/bin:$PATH"

# xdg
export XDG_CACHE_HOME=$HOME/.cache
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_RUNTIME_DIR=$TMPDIR

# environment
export HISTFILE="$XDG_CACHE_HOME/bash/history"
export ICEAUTHORITY="$XDG_RUNTIME_DIR/ICEauthority"
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
export LESSHISTFILE="$XDG_CACHE_HOME/less/history"
export PYTHONDONTWRITEBYTECODE=1
export VIMINIT='let $MYVIMRC="$XDG_CONFIG_HOME/nvim/init.vim" | source $MYVIMRC'
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"

# source bashrc
[[ -v BASH ]] && . "$XDG_CONFIG_HOME/bashrc"
