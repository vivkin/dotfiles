# vim:ts=2:sw=2:et

# if not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# command promt
if [ $EUID == 0 ]; then
  ucolor="\033[31m"
else
  ucolor="\033[32m"
fi

if [ -v SSH_TTY ]; then
  hcolor="\033[31m"
else
  hcolor="\033[32m"
fi

ps1_git_branch() {
  local BRANCH=$(git branch --no-color 2> /dev/null | sed -n -e '/^*/s/^* //p')
  if [ -n "$BRANCH" ]; then
    local DIRTY
    local STAGED
    git diff --no-ext-diff --quiet || DIRTY='*'
    git diff --no-ext-diff --cached --quiet || STAGED='+'
    echo "[${BRANCH}${DIRTY}${STAGED}]"
  fi
}
export PS1="\[${ucolor}\]\u\[\033[00m\]@\[${hcolor}\]\h\[\033[00m\]:\[\033[34m\]\w\[\033[01;31m\]\$(ps1_git_branch)\[\033[00m\]\$ "

# colored ls and grep
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

# enable programmable completion features
if which brew &> /dev/null && [ -f $(brew --prefix)/share/bash-completion/bash_completion ]; then
  . $(brew --prefix)/share/bash-completion/bash_completion
elif [ -f /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

# set terminal window title
update_window_title() {
  local TITLE=${PWD/#$HOME/\~}
  echo -ne "\e]0;${MSYSTEM:+$MSYSTEM }${TITLE##*/}\a"
}
PROMPT_COMMAND=update_window_title
