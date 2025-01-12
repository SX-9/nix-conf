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
        
        portablemc
        ferium
        virt-manager
        appimage-run
        scrcpy
        cava

        zsh-completions
        zsh-syntax-highlighting
      ];
    };
  };
}
