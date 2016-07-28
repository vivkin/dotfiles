# vim:ts=2:sw=2:et

# if not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# local binaries
export PATH="~/.local/bin:$PATH"

#colors
COLOR_RED="$(tput setaf 1)"
COLOR_GREEN="$(tput setaf 2)"
COLOR_YELLOW="$(tput setaf 3)"
COLOR_BLUE="$(tput setaf 4)"
COLOR_MAGENTA="$(tput setaf 5)"
COLOR_CYAN="$(tput setaf 6)"
COLOR_WHITE="$(tput setaf 7)"
COLOR_GRAY="$(tput setaf 8)"
COLOR_BOLD="$(tput bold)"
COLOR_UNDERLINE="$(tput sgr 0 1)"
COLOR_INVERT="$(tput sgr 1 0)"
COLOR_RESET="$(tput sgr0)"

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

# show username@host if logged in through SSH
[[ -v SSH_TTY ]] && PROMPT_HOST="\[${COLOR_YELLOW}\]\u\[${COLOR_GRAY}\]@\h"
# show username@host if root, with username in white
[[ $EUID == 0 ]] && PROMPT_HOST="\[${COLOR_RED}\]\u\[${COLOR_GRAY}\]@\h"
# show current working directory, with $HOME abbreviated with a tilde
PROMPT_CWD="\[${COLOR_BLUE}\]\w\[${COLOR_RESET}\]\${PROMPT_BRANCH:+ \[${COLOR_GRAY}\]\$PROMPT_BRANCH\[${COLOR_RESET}\]}"
# show prompt symbol in red if previous command fails
PROMPT_END="\$([ \${?} = 0 ] && echo \[\${COLOR_CYAN}\] || echo \[\${COLOR_RED}\])${PROMPT_SYMBOL:-❯}\[${COLOR_RESET}\]"
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
