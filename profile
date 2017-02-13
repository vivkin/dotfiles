# vim:ts=2:sw=2:et

# local binaries
export PATH="$HOME/.local/bin:$PATH"

# environment
export EDITOR=vim
export INPUTRC="$HOME/.config/readline/inputrc"
export LESSHISTFILE="$HOME/.cache/less/history"
export PYTHONDONTWRITEBYTECODE=1
export VIMINIT='let $MYVIMRC="$HOME/.config/vimrc" | source $MYVIMRC'

# make dirs for history
[[ -d "${LESSHISTFILE%/*}" ]] || mkdir -p "${LESSHISTFILE%/*}"

# source bashrc
[[ -n "$BASH_VERSION" ]] && . "$HOME/.config/bashrc"
