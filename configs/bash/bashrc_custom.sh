#!/bin/bash

# Prompt theme
eval "$(starship init bash)"

# Z directory jumper
source ~/.dotfiles/configs/bash/z.sh

# Alias
alias gitui="gitui -t mocha.ron"

# Add PATH
export PATH="/home/haruki/.cargo/bin:$PATH"
