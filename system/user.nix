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
        "adbusers"
        "kvm"
      ];
      packages = with pkgs; [
        vscode
        discord
        slack
        brave

        libreoffice
        vlc
        moonlight-qt
        #inkscape
        #davinci-resolve
        #kdePackages.kdenlive

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

        zsh-completions
        zsh-syntax-highlighting

        gh
        go
        bun
        nodejs
        nodePackages.npm
        nodePackages.pnpm
        nodePackages.yarn
        python314
        jdk23_headless
      ];
    };
  };
}
