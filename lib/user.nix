{ pkgs, username, ... }: {
  users = {
    motd = "Welcome to NixOS, ${username}!";
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
        
        portablemc
        ferium
        virt-manager
        appimage-run
        scrcpy

        zsh-completions
        zsh-syntax-highlighting
      ];
    };
  };
}