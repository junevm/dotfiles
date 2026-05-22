# dotfiles

Desktop setup managed with [chezmoi](https://www.chezmoi.io/).

## Quick start

Prerequisites: `curl`, `sudo`, internet access.

Install for CachyOS (`main`):

```bash
sh -c "$(curl -fsSL https://gitlab.com/junevm/dotfiles/-/raw/main/bootstrap.sh)"
```

Install for Zorin (`zorin`):

```bash
sh -c "$(curl -fsSL https://gitlab.com/junevm/dotfiles/-/raw/zorin/bootstrap.sh)"
```

Optional custom repo URL (set branch with `DOTFILES_BRANCH`):

```bash
DOTFILES_BRANCH=main DOTFILES_REPO_URL=https://gitlab.example.com/junevm/dotfiles.git sh -c "$(curl -fsSL https://gitlab.com/junevm/dotfiles/-/raw/$DOTFILES_BRANCH/bootstrap.sh)"
```

## Daily use

```bash
cd ~/.local/share/chezmoi && mise run backup
```

## Notes

- Branch mapping: `main` = CachyOS, `zorin` = Zorin.
- Restore is idempotent and resumable.
- Reboot after restore for full effect.
