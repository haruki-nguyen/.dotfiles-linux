#!/bin/bash
 
# Add system updating script
source ~/.dotfiles/configs/bash/update-system.sh

# Add search and replace script
source ~/.dotfiles/configs/bash/search-replace.sh

# Prompt theme
eval "$(starship init bash)"

# Z directory jumper
source ~/.dotfiles/configs/bash/z.sh

# Alias
alias md="mkdir -p"
alias t="touch"
alias bashs="source ~/.bashrc"

alias g="git"
alias gs="git status"
alias gl="git log --graph --oneline --decorate"
alias gaa="git add ."
alias ga="git add"
alias gcm="git commit -m"
alias gc="git commit"
alias gpl="git pull"
alias gps="git push"

# Add PATH
export PATH="/home/haruki/.cargo/bin:$PATH"

# Auto start
export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
ibus-daemon -drx

