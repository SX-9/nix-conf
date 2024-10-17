{ lib, pkgs, system, username, ... }: {
  nixpkgs.hostPlatform = lib.mkDefault system;
  system.stateVersion = "24.05";
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
    nix-ld = {
      enable = true;
      package = pkgs.nix-ld-rs; # only for NixOS 24.05
    };
  };
  virtualisation.docker.enable = true;
}