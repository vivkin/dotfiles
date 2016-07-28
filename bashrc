# vim:ts=2:sw=2:et

# if not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# local binaries
export PATH="~/.local/bin:$PATH"

#colors
update_terminal_title() {
  echo -ne "\e]0;${MSYSTEM:+$MSYSTEM }${PWD/#$HOME/\~}\a"
}

update_prompt_branch() {
  PROMPT_BRANCH=$(git symbolic-ref --short HEAD 2> /dev/null)
  if [ -n "${PROMPT_BRANCH}" ]; then
    git diff --no-ext-diff --quiet || PROMPT_BRANCH+="${PROMPT_GIT_DIRTY:-*}"
    git diff --no-ext-diff --cached --quiet || PROMPT_BRANCH+="${PROMPT_GIT_STAGED:-+}"
    local TRACKING=($(git rev-list --left-right --count HEAD...@{u} 2> /dev/null))
    if [ -n "${TRACKING}" ]; then
      [[ ${TRACKING[0]} != 0 ]] && PROMPT_BRANCH+=" ${PROMPT_GIT_AHEAD:-⇡}${TRACKING[0]}"
      [[ ${TRACKING[1]} != 0 ]] && PROMPT_BRANCH+=" ${PROMPT_GIT_BEHIND:-⇣}${TRACKING[1]}"
    fi
  fi
}

PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }update_terminal_title; update_prompt_branch"

RED="\[\e[31m\]"
YELLOW="\[\e[33m\]"
BLUE="\[\e[34m\]"
CYAN="\[\e[36m\]"
GRAY="\[\e[90m\]"
RESET="\[\e[39m\]"

# show username@host if logged in through SSH
[[ -v SSH_TTY ]] && PROMPT_HOST="${YELLOW}\u${GRAY}@\h"
# show username@host if root, with username in white
[[ $EUID == 0 ]] && PROMPT_HOST="${RED}\u${GRAY}@\h"
# show current working directory, with $HOME abbreviated with a tilde
PROMPT_CWD="${BLUE}\w${RESET}\${PROMPT_BRANCH:+ ${GRAY}\$PROMPT_BRANCH${RESET}}"
# show prompt symbol in red if previous command fails
PROMPT_END="\$([ \${?} = 0 ] && echo ${CYAN} || echo ${RED})${PROMPT_SYMBOL:-❯}${RESET}"
# all together
PS1="${PROMPT_HOST:+$PROMPT_HOST }${PROMPT_CWD} ${PROMPT_END} "

# colored grep and ls
alias grep='grep --color=auto'
if [ $(uname) = Darwin ]; then
  alias ls='ls -GF'
else
  alias ls='ls --color=auto -F'
fi
alias l='ls -lh'
alias la='ls -A'
alias ll='ls -lA'

# options
shopt -s cdspell
shopt -s cmdhist
shopt -s histappend
shopt -s no_empty_cmd_completion

# history
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=10000
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }history -a"

# enable programmable completion features
if which brew &> /dev/null && [ -f $(brew --prefix)/share/bash-completion/bash_completion ]; then
  . $(brew --prefix)/share/bash-completion/bash_completion
elif [ -f /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

BASE16_SHELL=$HOME/.config/base16-shell
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"
