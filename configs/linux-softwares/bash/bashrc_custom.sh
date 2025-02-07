#!/bin/bash
 
# Add system updating script
source ~/.dotfiles/configs/linux-softwares/bash/update-system.sh

# Add search and replace script
source ~/.dotfiles/configs/linux-softwares/bash/search-replace.sh

# Prompt theme
# eval "$(starship init bash)"

# Z directory jumper
source ~/.dotfiles/configs/linux-softwares/bash/z.sh

# Alias
alias md="mkdir -p"
alias t="touch"
alias refresh="source ~/.bashrc"
alias py="python3"
alias open="explorer.exe"

# Git alias
alias gits="git status"
alias gitl="git log --graph --oneline --decorate"
alias gitaa="git add ."
alias gita="git add"
alias gitc="git commit"
alias gitpr="git pull --rebase"
alias gitsync="git pull --rebase && git push"
alias gitui="gitui -t catppuccin_mocha.ron"
alias gitcz="git cz"

# Add PATH
export PATH="/home/haruki/.cargo/bin:/home/haruki/.local/bin:$PATH"

