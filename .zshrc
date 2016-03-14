# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' group-name ''
zstyle ':completion:*' insert-unambiguous false
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'r:|[._-]=* r:|=*'
zstyle ':completion:*' menu select=3
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' verbose true
zstyle :compinstall filename '/home/leif/.zshrc'

autoload -Uz compinit
compinit
autoload -U colors
colors
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt extendedglob nomatch notify
unsetopt appendhistory beep
bindkey -v
# End of lines configured by zsh-newuser-install
eval "`dircolors DIR_COLORS`"
# If xterm or rxvt, set the title to dir
case "$TERM" in
xterm*|rxvt*)
  chpwd () { print -Pn "\033]0;%n@%m: %~\007" }
	;;
*)
	;;
esac

export PROMPT="%F{cyan}%m%f%#%(?..:%K{red}%?%k) "
export RPROMPT=%~%F{cyan}%T%f
alias ls='ls -F --color'
alias j='j7 -c'
