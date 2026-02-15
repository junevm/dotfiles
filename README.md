# dotfiles

personal configurations for a clean fedora-based environment.

## included

- gnome settings & extensions
- system packages (apt, homebrew, flatpak)
- shell configs (fish, git, starship)
- wallpapers, scripts & cron jobs

## setup

### prerequisites

- [chezmoi](https://www.chezmoi.io/)
- [git](https://git-scm.com/downloads)
- [mise-en-place](https://mise.jdx.dev/)

### install

```bash
curl -fsSL https://github.com/junevm/dotfiles/raw/refs/heads/main/bootstrap.sh | bash
```

### sync

```bash
cd ~/.local/share/chezmoi && mise run backup
```

## notes

- target os: fedora
- reboot after restore for full effect
