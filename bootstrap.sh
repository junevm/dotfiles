#!/bin/bash
set -e

echo "🚀 Starting dotfiles bootstrap..."

# Install git if not present
if ! command -v git &> /dev/null; then
    echo "📦 Installing git..."
    sudo apt update && sudo apt install -y git
fi


# Initialize and apply chezmoi
echo "⚙️ Initializing chezmoi..."
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply --depth=1 https://github.com/junevm/dotfiles

# Change to chezmoi directory
cd ~/.local/share/chezmoi

# Install mise if not present
if ! command -v mise &> /dev/null; then
    echo "📦 Installing mise to temp location..."
    curl https://mise.run | MISE_INSTALL_PATH=/tmp/mise sh
fi

# Run restore with mise
echo "📋 Running restore..."
/tmp/mise run restore

echo "✅ Bootstrap complete! Please reboot your system."