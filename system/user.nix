{ pkgs, username, ... }: {
  users = {
    users."${username}" = {
      isNormalUser = true;
      description = "${username}";
      initialPassword = "${username}";
      shell = pkgs.zsh;
      extraGroups = [
        "networkmanager"
        "wheel"
        "dialout"
        "libvirtd"
        "docker"
        "input"
        "ydotool"
      ];
      packages = with pkgs; [
        vscode
        discord
        google-chrome
        brave
        firefox
        libreoffice
        vlc
        slack
        zoom
        zoom-us
        moonlight-qt
        inkscape
        davinci-resolve

        (wrapOBS {
          plugins = with obs-studio-plugins; [
            wlrobs
            obs-backgroundremoval
            obs-pipewire-audio-capture
          ];
        })
        
        portablemc
        ferium
        virt-manager
        appimage-run
        gemini-cli

        zsh-completions
        zsh-syntax-highlighting

        gh
        go
        bun
        deno
        nodejs
        nodePackages.npm
        python314
        jdk23_headless
      ];
    };
  };
}
