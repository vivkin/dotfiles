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

# show username@host if logged in through SSH
[[ -v SSH_TTY ]] && PROMPT_USERNAME="\[${COLOR_YELLOW}\]\u\[${COLOR_GRAY}\]@\h"

# show username@host if root, with username in white
[[ $EUID == 0 ]] && PROMPT_USERNAME="\[${COLOR_RED}\]\u\[${COLOR_GRAY}\]@\h"

ps1_git_branch() {
  PROMPT_BRANCH=$(git branch --no-color 2> /dev/null | sed -n -e '/^*/s/^* //p')
  if [ -n "$PROMPT_BRANCH" ]; then
    git diff --no-ext-diff --quiet || PROMPT_BRANCH="${PROMPT_BRANCH}*"
    git diff --no-ext-diff --cached --quiet || PROMPT_BRANCH="${PROMPT_BRANCH}+"
  fi
}

PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }ps1_git_branch"
PROMPT_SYMBOL="\`if [ \$? = 0 ]; then echo \[\${COLOR_CYAN}\]; else echo \[\${COLOR_RED}\]; fi\`❯\[\${COLOR_RESET}\]"
PS1="${PROMPT_USERNAME:+$PROMPT_USERNAME }\[${COLOR_BLUE}\]\w\[${COLOR_RESET}\]\${PROMPT_BRANCH:+ \[$COLOR_GRAY\]\$PROMPT_BRANCH\[$COLOR_RESET\]} ${PROMPT_SYMBOL} "
PS2="${PROMPT_SYMBOL} "

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
shopt -s cmdhist
shopt -s cdspell

# history
shopt -s histappend
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

# set terminal window title
update_window_title() {
  local TITLE=${PWD/#$HOME/\~}
  echo -ne "\e]0;${MSYSTEM:+$MSYSTEM }${TITLE##*/}\a"
}
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }update_window_title"
