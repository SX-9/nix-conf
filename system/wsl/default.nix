{ lib, system, username, ... }: {
  nixpkgs.hostPlatform = lib.mkDefault system;
  system.stateVersion = "24.11";
  imports = [ ./apps.nix ];
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
    };
    optimise.automatic = true;
  };
  wsl = {
    enable = true;
    defaultUser = "${username}";
    startMenuLaunchers = true;
  };

  programs = {
    zsh.enable = true;
    nix-ld.enable = true;
  };
  virtualisation.docker.enable = true;
}