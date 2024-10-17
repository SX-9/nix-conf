{ pkgs, username, ... }: {
  users = {
    users."${username}" = {
      isNormalUser = true;
      description = "${username}";
      initialPassword = "${username}";
      shell = pkgs.zsh;
      extraGroups = [
        "wheel"
        "dialout"
        "docker"
      ];
      packages = with pkgs; [
        appimage-run
        scrcpy

        zsh-completions
        zsh-syntax-highlighting
      ];
    };
  };
}