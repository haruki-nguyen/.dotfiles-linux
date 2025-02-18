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

7. **Optional**: Manually install the JetBrainsMono Nerd font if desired.

