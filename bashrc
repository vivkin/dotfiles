# vim:ts=2:sw=2:et

# if not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# options
shopt -s autocd
shopt -s cdspell
shopt -s checkwinsize
shopt -s cmdhist
shopt -s dirspell
shopt -s histappend
shopt -s no_empty_cmd_completion

# history
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=10000
PROMPT_COMMAND="history -a;history -n"

# titile
update_terminal_title() {
  echo -ne "\e]0;${MSYSTEM:+$MSYSTEM }${PWD/#$HOME/\~}\a"
}

PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }update_terminal_title"

# current branch
git_branch_init() {
  GIT_UP_DIR=$PWD
  while ! [ -d "$GIT_UP_DIR/.git" ] && [ -n "$GIT_UP_DIR" ]; do
    GIT_UP_DIR=${GIT_UP_DIR%/*}
  done
  GIT_BRANCH=
  if [ -e "$GIT_UP_DIR/.git/HEAD" ]; then
    GIT_BRANCH=$(< "$GIT_UP_DIR/.git/HEAD")
    GIT_BRANCH=${GIT_BRANCH##*/}
  fi
}

PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }git_branch_init"

# staged, dirty and upstream tracking
git_status_update() {
  if [ -n "$GIT_BRANCH" ]; then
    GIT_STATUS=
    git diff --cached --quiet || GIT_STATUS+="+"
    git diff --quiet || GIT_STATUS+="*"
    read GIT_BRANCH_AHEAD GIT_BRANCH_BEHIND <<< $(git rev-list --left-right --count HEAD...@{u} 2> /dev/null)
    [[ $GIT_BRANCH_AHEAD > 0 ]] && GIT_STATUS+=" ⇡$GIT_BRANCH_AHEAD"
    [[ $GIT_BRANCH_BEHIND > 0 ]] && GIT_STATUS+=" ⇣$GIT_BRANCH_BEHIND"
  fi
}

if which git &> /dev/null && ! git config --get bash.prompt.disable &> /dev/null; then
  PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }git_status_update"
fi

# prompt
RED="\[\e[31m\]"
YELLOW="\[\e[33m\]"
BLUE="\[\e[34m\]"
CYAN="\[\e[36m\]"
WHITE="\[\e[37m\]"
GRAY="\[\e[90m\]"
RESET="\[\e[0m\]"

# show username@host if logged in through SSH
[[ -n "$SSH_TTY" ]] && PROMPT_HOST="${YELLOW}\u${GRAY}@\h"
# show username@host if root, with username in white
[[ $EUID == 0 ]] && PROMPT_HOST="${WHITE}\u${GRAY}@\h"
# show default prompt character on windows
[[ -n "$MSYSTEM" ]] && PROMPT_CHARACTER="\$"
# show current working directory, with $HOME abbreviated with a tilde
PS1="${PROMPT_HOST:+$PROMPT_HOST }${BLUE}\w\${GIT_BRANCH:+ ${GRAY}\$GIT_BRANCH\$GIT_STATUS} "
# show prompt symbol in red if previous command fails
PS1+="${CYAN}\$(if [ \$? != 0 ]; then echo -ne "${RED}"; fi)${PROMPT_CHARACTER:-❯}${RESET} "

# colored grep and ls
alias grep='grep --color=auto'
if [ $(uname) = Darwin ]; then
  alias ls='ls -GF'
else
  alias ls='ls --color=auto -F'
fi
alias l='ls -lh'
alias ll='ls -lA'

# shorter change dir
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# editor
if which nvim &> /dev/null; then
  alias vim=nvim
  export EDITOR=nvim
fi

# enable programmable completion features
if which brew &> /dev/null && [ -f $(brew --prefix)/share/bash-completion/bash_completion ]; then
  . $(brew --prefix)/share/bash-completion/bash_completion
elif [ -f /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi
