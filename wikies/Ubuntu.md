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

4. **Post-Install Checklist**:

   * Add SSH key to GitHub if prompted.
   * Tmux: press `<prefix> + I` to install plugins.
   * Set JetBrainsMono Nerd Font as system/default terminal font.
   * Set Unikey in Settings → Keyboard → Input Sources → Vietnamese (Unikey).

5. **Manual Steps (Optional)**:

   * GNOME tweaks: change wallpaper, set icon theme (WhiteSur), etc.
   * Recommended GNOME extensions: Dash to Dock, Blur My Shell, Vitals, Clipboard Indicator, Rounded Window Corners Reborn, Just Perfection.
   * For CopyQ autostart, create:

     ```bash
     nano ~/.config/autostart/copyq.desktop
     ```

     With:

     ```ini
     [Desktop Entry]
     Type=Application
     Exec=env QT_QPA_PLATFORM=xcb copyq
     Hidden=false
     NoDisplay=false
     X-GNOME-Autostart-enabled=true
     Name=CopyQ
     ```

   * Enable non-LTS upgrades:

     ```bash
     sudo nano /etc/update-manager/release-upgrades
     # Set Prompt=normal
     ```
