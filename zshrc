HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt extendedglob nomatch notify
unsetopt appendhistory beep
zstyle :compinstall filename '/home/vurabu/.zshrc'
autoload -U compinit && compinit

PROMPT="%{$fg[cyan]%}%1~ %{$fg[blue]%}%# %{$reset_color%}"

export PATH="$PATH:$HOME/.bin/:$HOME/.cabal/bin"
