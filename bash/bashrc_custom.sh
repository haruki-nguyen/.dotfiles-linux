#!/bin/bash
 
# Add system updating script
source ~/.dotfiles/configs/linux-softwares/bash/update-system.sh

# Z directory jumper
source ~/.dotfiles/configs/linux-softwares/bash/z.sh

# Alias
alias md="mkdir -p"
alias t="touch"
alias refresh="source ~/.bashrc"
alias py="python3"

# Git alias
alias gits="git status"
alias gitl="git log --graph --oneline --decorate"
alias gitaa="git add ."
alias gita="git add"
alias gitc="git commit"
alias gitpr="git pull --rebase"
alias gitsync="git pull --rebase && git push"

# Add PATH
export PATH="/home/haruki/.local/bin:$PATH"

