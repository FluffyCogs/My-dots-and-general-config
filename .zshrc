export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="tetos"
HYPHEN_INSENSITIVE="true"
DISABLE_AUTO_TITLE="true"

# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(zsh-syntax-highlighting zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh


export EDITOR='nvim'

alias cls=clear
alias fixtime="sudo ntpdate pool.ntp.org"
alias please='sudo $(fc -ln -1)'
alias ..="cd .."
alias ls="ls -a --color"
alias dfc="git --git-dir=$HOME/.dotfiles --work-tree=$HOME" # dotfiles config

fastfetch
