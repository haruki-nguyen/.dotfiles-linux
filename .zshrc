# If you come from bash you might have to change your $PATH.
# Prioritize Linux paths over Windows paths to avoid UNC path issues
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/bin:$HOME/.local/bin:$PATH"

# Function to safely convert WSL paths for Windows applications
wslpath_safe() {
  if command -v wslpath >/dev/null 2>&1; then
    wslpath -w "$1" 2>/dev/null || echo "$1"
  else
    echo "$1"
  fi
}

# Simple cursor workaround for UNC path issues
cursor() {
  if [[ $# -eq 0 ]] || [[ "$1" == "." ]]; then
    echo "UNC path workaround: Opening cursor manually required"
    echo "Current directory: $PWD"
    echo "" 
    echo "Please do one of the following:"
    echo "  1. Open Cursor manually and use File -> Open Folder"
    echo "  2. Copy and paste this path: $PWD"
    echo "  3. Or try this command: open_vscode"
    echo ""
    echo "The UNC path issue prevents direct opening from WSL."
    return 1
  else
    # For other arguments, pass them through to the real cursor
    /mnt/c/Users/nmdex/scoop/shims/cursor "$@"
  fi
}

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git history-substring-search)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# THIS ZSHRC IS FOR UBUNTU
# Aliases
alias md="mkdir -p"
alias t="touch"
alias refresh="source ~/.zshrc && cd ~/.dotfiles-linux && stow . && cd -"
alias py="python3"
alias cd="z"
alias update_system="zsh ~/.config/zsh/update-system.zsh"

# Git aliases
alias gits="git status"
alias gitl="git log --graph --oneline --decorate"
alias gitaa="git add ."
alias gita="git add"
alias gitc="git commit"
alias gitpr="git pull --rebase"
alias gitsync="git pull --rebase && git push"

# VS Code aliases that avoid UNC path issues
alias code.="code ."
alias vscode="code"
# Alternative function for opening VS Code without UNC path issues
open_vscode() {
  if [[ $# -eq 0 ]]; then
    # Use current directory, but handle UNC paths gracefully
    local current_dir="$PWD"
    echo "Opening VS Code in: $current_dir"
    code "$current_dir" 2>/dev/null || {
      echo "Failed to open VS Code, trying alternative method..."
      (cd "$current_dir" && code . 2>/dev/null) || {
        echo "Please open VS Code manually or check installation"
      }
    }
  else
    code "$@"
  fi
}
# SSH Agent Configuration
# Auto-start SSH agent and load keys
if [ -z "$SSH_AUTH_SOCK" ]; then
  # Check if ssh-agent is already running
  if [ -f ~/.ssh-agent-env ]; then
    source ~/.ssh-agent-env > /dev/null
    if ! kill -0 $SSH_AGENT_PID 2>/dev/null; then
      # Agent is not running, start a new one
      eval "$(ssh-agent -s)" > ~/.ssh-agent-env
      source ~/.ssh-agent-env > /dev/null
      ssh-add ~/.ssh/id_ed25519 2>/dev/null
    fi
  else
    # No agent environment file, start a new agent
    eval "$(ssh-agent -s)" > ~/.ssh-agent-env
    source ~/.ssh-agent-env > /dev/null
    ssh-add ~/.ssh/id_ed25519 2>/dev/null
  fi
fi

# Enable zoxide
if command -v zoxide > /dev/null 2>&1; then
eval "$(zoxide init zsh)"
else
  echo "[WARN] zoxide not found in PATH. Please install zoxide for 'cd' alias to work."
fi
