# Hide the fish greeting
set fish_greeting ""

# edit files with the default application
alias edit="gio open" 
alias fan="msifancontrol"

# Add paths
fish_add_path ~/Android/Sdk/platform-tools
fish_add_path ~/.pub-cache/bin
fish_add_path ~/.local/bin
fish_add_path ~/go/bin

# Environment variables
set -gx HOMEBREW_NO_AUTO_UPDATE 1
set -gx SSH_AUTH_SOCK "$HOME/.var/app/com.bitwarden.desktop/data/.bitwarden-ssh-agent.sock"

# Allow local docker containers to connect to X server
xhost +local:docker &>/dev/null

# Initialize Homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Initialize Starship
starship init fish | source
