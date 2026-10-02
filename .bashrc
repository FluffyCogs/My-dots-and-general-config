#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

. "$HOME/.local/bin/env"

source /usr/share/nvm/init-nvm.sh
export PATH=/home/fluffycogs/.local/bin:$PATH

# disable annoying bell
bind "set bell-style none"

export EDITOR='nvim'

alias cls=clear
alias fixtime="sudo ntpdate pool.ntp.org"
alias please='sudo $(fc -ln -1)'
alias ..="cd .."
alias ls="ls -a --color"
alias dfc="git --git-dir=$HOME/.dotfiles --work-tree=$HOME" # dotfiles config

fastfetch
