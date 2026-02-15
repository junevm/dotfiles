# ⚙️ Dotfiles

Personal Linux configuration managed with [chezmoi](https://www.chezmoi.io/) and [Task](https://taskfile.dev/).

## 📦 What's Included

- GNOME settings & extensions
- System packages (APT, Homebrew, Flatpak)
- Dotfiles (Fish shell, Git config, Starship)
- Wallpapers, scripts & cron jobs

## 🚀 Setup

### Restore on new machine

Run the following command to set up a new machine:

```bash
curl -fsSL https://github.com/junevm/dotfiles/raw/refs/heads/main/bootstrap.sh | bash
```

### Backup from current machine

Run the following command to back up your current configuration:

```bash
cd ~/.local/share/chezmoi && task backup
```

## 💡 Notes

- Target OS: Fedora
- Reboot after restore for full effect
