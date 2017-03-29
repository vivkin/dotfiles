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
HISTFILE="$HOME/.cache/bash/history"
HISTFILESIZE=100000
HISTSIZE=100000
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }history -a; history -n"
[[ -d "${HISTFILE%/*}" ]] || mkdir -p "${HISTFILE%/*}"
export HISTIGNORE="&:[ ]*:bg:cd:cd -:cd ..:clear:env:exit:fg:history:l:ll:ls"

# titile
update_terminal_title() {
  echo -ne "\e]0;${MSYSTEM:+$MSYSTEM }${PWD/#$HOME/\~}\a"
}

#PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }update_terminal_title"

# current branch
git_branch_init() {
  GIT_WORK_TREE=$PWD
  while ! [ -d "$GIT_WORK_TREE/.git" ] && [ -n "$GIT_WORK_TREE" ]; do
    GIT_WORK_TREE=${GIT_WORK_TREE%/*}
  done
  GIT_BRANCH=
  if [ -e "$GIT_WORK_TREE/.git/HEAD" ]; then
    GIT_BRANCH=$(< "$GIT_WORK_TREE/.git/HEAD")
    GIT_BRANCH=${GIT_BRANCH##*/}
  fi
}

PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }git_branch_init"

# staged, dirty and upstream tracking
git_status_update() {
  GIT_STATUS=
  if [ -n "$GIT_BRANCH" ] && ! git config --get bash.prompt.disable &> /dev/null; then
    git diff --cached --quiet || GIT_STATUS+="+"
    git diff --quiet || GIT_STATUS+="*"
    read GIT_BRANCH_AHEAD GIT_BRANCH_BEHIND <<< $(git rev-list --left-right --count HEAD...@{u} 2> /dev/null)
    [[ $GIT_BRANCH_AHEAD > 0 ]] && GIT_STATUS+=" ⇡$GIT_BRANCH_AHEAD"
    [[ $GIT_BRANCH_BEHIND > 0 ]] && GIT_STATUS+=" ⇣$GIT_BRANCH_BEHIND"
  fi
}

PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }$(which git &> /dev/null && echo git_status_update)"

# prompting
bash_prompt_init() {
  local RESET="\[\e[0m\]"
  local RED="\[\e[31m\]"
  local GREEN="\[\e[32m\]"
  local YELLOW="\[\e[33m\]"
  local BLUE="\[\e[34m\]"
  local MAGNETA="\[\e[35m\]"
  local CYAN="\[\e[36m\]"
  local WHITE="\[\e[37m\]"
  local GRAY="\[\e[90m\]"

  # show username@host if logged in through SSH
  PS1="${SSH_TTY:+$GREEN\u@\h$RESET:}"
  # show current working directory, current branch and status
  PS1+="$BLUE\w\${GIT_BRANCH:+ $YELLOW(\$GIT_BRANCH\$GIT_STATUS)}\n"
  # show prompt symbol in red if previous command fails
  PS1+="$RESET\$([ \$? != 0 ] && echo -ne $MAGNETA)${PROMPT_CHARACTER:-❯}$RESET "
}

bash_prompt_init

# colored grep and ls
alias grep='grep --color=auto'
if [ $(uname) = Darwin ]; then
  alias ls='ls -GF'
else
  alias ls='ls --color=auto -F'
fi
alias l='ls -lh'
alias ll='ls -lA'

# go to previous dir
alias -- -='cd -'

# make dir and cd to it
md() {
	mkdir -p "$1" && cd "$1"
}

# find by name
ff() {
  find "$PWD" -name "$1"
}

# enable programmable completion features
if which brew &> /dev/null && [ -f $(brew --prefix)/share/bash-completion/bash_completion ]; then
  . $(brew --prefix)/share/bash-completion/bash_completion
elif [ -f /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi
