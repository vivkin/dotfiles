# Add tab completion for many Bash commands
if which brew > /dev/null && [ -f "$(brew --prefix)/etc/bash_completion" ]; then
	source "$(brew --prefix)/etc/bash_completion";
elif [ -f /etc/bash_completion ]; then
	source /etc/bash_completion;
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2 | tr ' ' '\n')" scp sftp ssh;

export PS1="\[\e[37m\]\u@\h \w\$\[\e[0m\] "
export HISTCONTROL=ignoreboth

alias ls='ls -GF'
alias ll='ls -lh'

PATH=~/android/ndk:~/android/sdk/tools:~/android/sdk/platform-tools:~/android/apache-ant-1.9.2/bin:$PATH
ANT_HOME=~/android/apache-ant-1.9.2
