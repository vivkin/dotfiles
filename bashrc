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
export ANDROID_HOME=/usr/local/opt/android-sdk
export NDK_ROOT=/usr/local/opt/android-ndk
export EDITOR=vim

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

# options
shopt -s no_empty_cmd_completion

# history
shopt -s histappend
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=10000

# completion
if which brew &> /dev/null && [ -f $(brew --prefix)/share/bash-completion/bash_completion ]; then
  . $(brew --prefix)/share/bash-completion/bash_completion
elif [ -f /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

# set terminal window title
if [ -v "MSYSTEM" ]; then
  update_window_title() {
    echo -ne "\e]2;$MSYSTEM $USER@$HOSTNAME:$PWD\a"
  }
  PROMPT_COMMAND=update_window_title
fi
