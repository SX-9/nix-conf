{ username, ... }: {
  home = {
    stateVersion = "24.05";
    username = "${username}";
    homeDirectory = "/home/${username}";
  };
}