#!/bin/sh

if [ -z "$XDG_CONFIG_HOME" ]; then
	echo "Please source profile first"
	exit
fi

mkdir -pv $XDG_DATA_HOME/nvim/{backup,swap,undo,view} && echo "Bootstrapped vim dirs"
mkdir -pv "${HISTFILE##*/}" "${LESSHISTFILE##*/}" && echo "Bootstrapped history dirs"
ln -fhsv {$XDG_CONFIG_HOME/,~/.}profile && echo "Bootstrapped profile"
[[ $(uname) == "Darwin" ]] && ln -fhsv {$XDG_CONFIG_HOME/,~/Library/LaunchAgents/}org.freedesktop.xdg.plist && echo "Bootstrapped launchd"
