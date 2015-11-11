# vim:ts=2:sw=2:et

if [ "${USER}" == "root" ]; then
  ucolor="\033[31m"
else
  ucolor="\033[32m"
fi

if [ "${SSH_TTY}" ]; then
  hcolor="\033[31m"
else
  hcolor="\033[32m"
fi

export PS1="\[${ucolor}\]\u\[\033[00m\]@\[${hcolor}\]\h\[\033[00m\]:\[\033[34m\]\w\[\033[00m\]\$ "
export GCC_COLORS=1
export ANDROID_HOME=/usr/local/opt/android-sdk
export NDK_ROOT=/usr/local/opt/android-ndk
export MONO_GAC_PREFIX="/usr/local"
export GOPATH=$HOME/go

# editor
if which mvim &> /dev/null; then
  export EDITOR=mvim
  alias e="open -a MacVim"
else
  export EDITOR=vim
  alias e="$EDITOR"
fi

# colored ls and aliases
if [ $(uname) == Darwin ]; then
  alias ls='ls -GF'
else
  alias ls='ls --color=auto -F'
fi
alias l='ls -lh'
alias la='ls -A'
alias ll='ls -lA'
alias grep='grep --color=auto'

# history
shopt -s histappend
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

# add tab completion for many Bash commands
if which brew &> /dev/null && [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
elif [ -f /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

# add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
if [ -e "~/.ssh/config" ]; then
  complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2 | tr ' ' '\n')" scp sftp ssh;
fi
