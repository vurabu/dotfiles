HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt extendedglob nomatch notify autocd
bindkey -e
unsetopt appendhistory beep
zstyle :compinstall filename '/home/vurabu/.zshrc'
autoload -U compinit && compinit
autoload -U colors && colors

PROMPT="%{$fg[cyan]%}%1~ %{$fg[blue]%}%# %{$reset_color%}"

alias ls="ls --color=auto"
alias grep="grep --color=auto"

export PATH="$PATH:$HOME/.bin/:$HOME/.cabal/bin"
