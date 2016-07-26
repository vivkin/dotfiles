# vim:ts=2:sw=2:et

# if not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# local binaries
export PATH="~/.local/bin:$PATH"

#colors
RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
YELLOW="$(tput setaf 3)"
BLUE="$(tput setaf 4)"
MAGENTA="$(tput setaf 5)"
CYAN="$(tput setaf 6)"
WHITE="$(tput setaf 7)"
GRAY="$(tput setaf 8)"
BOLD="$(tput bold)"
UNDERLINE="$(tput sgr 0 1)"
INVERT="$(tput sgr 1 0)"
NOCOLOR="$(tput sgr0)"

prompt_pure_username=" ${GREEN}\u${NOCOLOR}@\h"
prompt_pure_directory=" ${BLUE}\w${NOCOLOR}"

# show username@host if logged in through SSH
[[ -v SSH_TTY ]] && prompt_pure_username=" ${YELLOW}\u${GRAY}@\h"

# show username@host if root, with username in white
[[ $EUID == 0 ]] && prompt_pure_username=" ${RED}\u${GRAY}@\h"

ps1_prompt_symbol() {
  if [ $? != 0 ]; then 
    #echo "${RED}❯"
    prompt_pure_symbol=" ${RED}❯${NOCOLOR}"
  else
    #echo "${MAGENTA}❯"
    prompt_pure_symbol=" ${MAGENTA}❯${NOCOLOR}"
  fi
}

ps1_git_branch() {
  local BRANCH=$(git branch --no-color 2> /dev/null | sed -n -e '/^*/s/^* //p')
  if [ -n "$BRANCH" ]; then
    local DIRTY
    local STAGED
    git diff --no-ext-diff --quiet || DIRTY='*'
    git diff --no-ext-diff --cached --quiet || STAGED='+'
    prompt_pure_branch=" ${GRAY}${BRANCH}${DIRTY}${STAGED}${NOCOLOR}"
  fi
}

PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }ps1_prompt_symbol; ps1_git_branch"
PS1="${prompt_pure_username}${prompt_pure_directory}\${prompt_pure_branch}\${prompt_pure_symbol} "
PS2="\${prompt_pure_symbol} "

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
