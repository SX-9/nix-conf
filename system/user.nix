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
        gimp

        # davinci-resolve
        # ^^^ too poor to afford discrete GPU for this :(

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
