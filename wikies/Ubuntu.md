# Ubuntu Quick Setup

## 1. Run the Installer

1. Download `ubuntu-installer.sh`.
2. Make it executable:

   ```bash
   chmod +x ubuntu-installer.sh
   ```

3. Run it:

   ```bash
   ./ubuntu-installer.sh
   ```

---

## 2. What Gets Installed

- **Core tools**: tmux, zip, nodejs, npm, python3-pip, python3.12-venv, ffmpeg, llvm, wget, unzip, git, btop, gthumb, curl, stow, gdm-settings, alacritty, ibus-unikey, keepassxc, gnome-browser-connector, gnome-tweaks, gnome-shell-extension-manager, zsh, zoxide.
- **Google Chrome, Discord, RQuickShare** (latest .deb).
- **Alacritty** set as default terminal.
- **Zsh & Oh My Zsh** as default shell.
- **Ulauncher** launcher.
- **Flatpak** (with ProtonVPN, Obsidian, GdmSettings).
- **Snap apps**: VS Code, Postman, LibreOffice.
- **JetBrainsMono Nerd Font**.
- **GitHub SSH key** (generates if missing, copies to clipboard).
- **Dotfiles**: Clones and stows your configs.
- **Tmux Plugin Manager**.
- **Syncthing** (starts user service, creates `~/Documents/My Data`).
- **Cleans up** your Downloads folder.

---

## 3. After Install

- Add SSH key to GitHub: [GitHub SSH Keys](https://github.com/settings/keys)
- In tmux, press `<prefix> + I` to install plugins.
- Set JetBrainsMono Nerd Font in your terminal.
- Add Vietnamese (Unikey) input in keyboard settings.
- Restart your terminal.

---

## 4. Optional

- Use GNOME Tweaks for appearance.
- Try GNOME extensions: Vitals, Clipboard Indicator, Rounded Window Corners, Just Perfection.
- To autostart CopyQ, create `~/.config/autostart/copyq.desktop`:

  ```ini
  [Desktop Entry]
  Type=Application
  Exec=env QT_QPA_PLATFORM=xcb copyq
  X-GNOME-Autostart-enabled=true
  Name=CopyQ
  ```

- To enable non-LTS upgrades:

  ```bash
  sudo nano /etc/update-manager/release-upgrades
  # Set Prompt=normal
  ```
