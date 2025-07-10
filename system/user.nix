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
      ];
      packages = with pkgs; [
        vscode
        discord
        google-chrome
        firefox
        libreoffice
        vlc
        slack
        zoom
        inkscape

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
