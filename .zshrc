# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored
zstyle :compinstall filename '/home/atm/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
unsetopt beep
bindkey -e

# End of lines configured by zsh-newuser-install

# Functionals Add-ons
source .config/zsh/zsh-autosuggestions.zsh

# Alias
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ll='ls -la'
alias cat='bat'

PROMPT="%K{103}%n%k%K{31}%~%k%F{14}> %f"
