# Dotfiles

Desktop setup managed with [chezmoi](https://www.chezmoi.io/).

## Quick start

Prerequisites: `curl`, `sudo`, internet access.

Install for CachyOS (`main`):

```bash
sh -c "$(curl -fsSL https://github.com/junevm/dotfiles/raw/refs/heads/main/bootstrap.sh)"
```

## Daily use

```bash
cd ~/.local/share/chezmoi && mise run backup
```

## Notes

- Restore is idempotent and resumable.
- Reboot after restore for full effect.
