# Android Development Setup for WSL2

1. Install Java 17:

    ```bash
    sudo apt update
    sudo apt install openjdk-17-jdk
    ```

2. Set Java 17 as default

   - Configure Java alternatives:

     ```bash
     sudo update-alternatives --config java
     ```

   - Set `JAVA_HOME`:

     ```bash
     export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
     export PATH=$JAVA_HOME/bin:$PATH
     ```

   - Add to `~/.bashrc` or `~/.zshrc`:

     ```bash
     echo 'export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64' >> ~/.bashrc
     echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.bashrc
     source ~/.bashrc
     ```

3. Install Android SDK:

   - Download the "command line tools" from [Android Studio's website](https://developer.android.com/studio#command-tools) and extract them:

     ```bash
     mkdir ~/android-sdk
     unzip commandlinetools-linux-*.zip -d ~/android-sdk
     ```

   - Organize the files:

     ```bash
     mkdir ~/android-sdk/cmdline-tools/latest
     mv ~/android-sdk/cmdline-tools/* ~/android-sdk/cmdline-tools/latest/
     ```

6. Install the necessary SDK tools:

   ```bash
   ~/android-sdk/cmdline-tools/latest/bin/sdkmanager --install "platform-tools" "build-tools;30.0.3" "platforms;android-30"
   ```

7. Set up environment variables:

   - Add to `~/.bashrc` or `~/.zshrc`:

     ```bash
     export ANDROID_HOME=~/android-sdk
     export PATH=$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH
     ```

   - Reload:

     ```bash
     source ~/.bashrc
     ```

8. Install Expo and Run App:

   - Install Expo CLI:

     ```bash
     npm install -g expo-cli
     ```

   - Start your Expo project:

     ```bash
     npx expo start --tunnel
     ```

