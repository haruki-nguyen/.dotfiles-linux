# Setting Up Ubuntu Environment

1. **Download the Script**: Save it as `ubuntu-installer.sh`.

2. **Make It Executable**:

   ```bash
   chmod +x ubuntu-installer.sh
   ```

3. **Run the Script**:

   ```bash
   ./ubuntu-installer.sh
   ```

4. **Follow Prompts**:

   - Add your SSH key to GitHub when prompted.
   - Press `<prefix> + I` in Tmux to install plugins after script completes.
   - Manually run `:MasonInstallAll` and `:Lazy sync` in NvChad.

5. **Fonts**: Set JetBrainsMono Nerd Font for the system.

6. **Optional Manual Steps**:
   - Change GNOME wallpaper via `gnome-tweaks`.
   - Extensions: Dash to Dock, Blur My Shell, Vitals, Clipboard Indicator, Rounded Window Corners Reborn, Just Perfection.
   - Create a .desktop entry for CopyQ:

        ```bash
        nano ~/.config/autostart/copyq.desktop
        ```

        Then add this:

        ```txt
        [Desktop Entry]
        Type=Application
        Exec=env QT_QPA_PLATFORM=xcb copyq
        Hidden=false
        NoDisplay=false
        X-GNOME-Autostart-enabled=true
        Name=CopyQ
        ```

   - Set `Prompt=normal` in `/etc/update-manager/release-upgrades`: for upgrading to non-LTS Ubuntu releases.
