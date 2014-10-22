# vim:ts=2:sw=2:et

PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

export EDITOR=vim
export GREP_OPTIONS='--color=auto'

# history
shopt -s histappend
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

# colored ls and aliases
if [ $(uname) == Darwin ]; then
  alias ls='ls -GF'
else
  alias ls='ls --color=auto -F'
fi
alias l='ls -lh'
alias la='ls -A'
alias ll='ls -lA'

# private bin
if [ -d "$HOME/bin" ]; then
  PATH="$HOME/bin:$PATH"
fi

# android ndk/sdk
if [ -x ~/android ]; then
  export PATH="$HOME/android/ndk:$HOME/android/sdk/tools:$HOME/android/sdk/platform-tools:$PATH"
fi

# homebrew
if [ -x ~/.linuxbrew ]; then
  export PATH="$HOME/.linuxbrew/bin:$PATH"
  export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
  export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"
fi

# add tab completion for many Bash commands
if which brew > /dev/null && [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
elif [ -f /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

# add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
if [ -e "$HOME/.ssh/config" ]; then
  complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2 | tr ' ' '\n')" scp sftp ssh;
fi
