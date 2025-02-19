# Setting Up Fedora with i3wm

1. **Download the Script**: Save the script to a file, e.g., `fedora-installer.sh`.

2. **Make the Script Executable**:

    ```bash
    chmod +x fedora-installer.sh
    ```

3. **Run the Script**:

    ```bash
    ./fedora-installer.sh
    ```

4. **Follow Prompts**:

    - Add the SSH key to GitHub when prompted.
    - Install Tmux plugins with `<prefix> + I` after the script completes.
    - Run `:MasonInstallAll` and `:Lazy sync` manually to complete NvChad setup.

5. **Refresh environment and create symolic links**: run `refresh` command.

6. **Restart Terminal**: After the script finishes, restart your terminal.

7. **Additional Steps**:

    - Manually install the JetBrainsMono Nerd font if desired.
    - Change the wallpaper in LightDM, follow these steps:

         Edit the greeter's configuration file:  

         ```sh
         sudo nano /etc/lightdm/lightdm-gtk-greeter.conf
         ```  

         Add or modify the following line to set your desired background image:  

         ```
         background=/path/to/your/wallpaper.jpg
         ```  

         Replace `/path/to/your/wallpaper.jpg` with the actual path to your image. Note that the background image has to be placed inside the `/usr/share/backgrounds` folder.

