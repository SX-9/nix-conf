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
        spotify
        vscode
        discord
        google-chrome
        libreoffice
        vlc
        slack
        zoom
        #davinci-resolve
        #gimp
        # ^^^ takes too long to build
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

        zsh-completions
        zsh-syntax-highlighting
      ];
    };
  };
}
