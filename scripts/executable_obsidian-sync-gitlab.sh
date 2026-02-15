#!/bin/bash

# Determine target user (do not consider sudo); prefer LOGNAME, fallback to whoami
TARGET_USER="${LOGNAME:-$(whoami)}"
HOME_DIR="$(getent passwd "$TARGET_USER" | cut -d: -f6 || eval echo "~$TARGET_USER")"
VAULT_DIR="${HOME_DIR}/syncthing/.vault"

cd "$VAULT_DIR" || { echo "Vault directory not found: $VAULT_DIR"; exit 1; }

# Add all changes
git add .

# Commit with timestamp
git commit -m "Auto backup [$(date '+%B %-d, %Y %H:%M:%S')]" || echo "Nothing to commit"

# Push current branch to all remotes (GitHub, GitLab)
git remote | xargs -L1 -I R git push R

