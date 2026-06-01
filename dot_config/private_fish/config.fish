# Hide the fish greeting
set fish_greeting ""

# edit files with the default application
alias mr="mise run"
alias docker="podman"
alias ls="eza"

# Add paths
fish_add_path ~/Android/Sdk/platform-tools
fish_add_path ~/.pub-cache/bin
fish_add_path ~/.local/bin
fish_add_path ~/go/bin

# Environment variables
set -gx CHROME_EXECUTABLE "/usr/bin/brave-browser"
set -gx SSH_AUTH_SOCK "$HOME/.var/app/com.bitwarden.desktop/data/.bitwarden-ssh-agent.sock" # if bitwarden installed via flatpak
# set -gx SSH_AUTH_SOCK "$HOME/.bitwarden-ssh-agent.sock" # if bitwarden installed via native package manager

# Allow local docker containers to connect to X server
if command -q xhost
	xhost +local:docker &>/dev/null
end

# Initialize tools
starship init fish | source

# activate mise
if status is-interactive
  mise activate fish | source
else
  mise activate fish --shims | source
end
