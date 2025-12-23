{ pkgs, username, ... }: {
  users = {
    users."${username}" = {
      linger = true;
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
        "uinput"
        "ydotool"
        "adbusers"
        "kvm"
      ];
    };
  };
}
