{ hostname, timezone, ... }: {
  system.stateVersion = "24.11";
  imports = [ ./apps.nix ];

  nixpkgs.config.allowUnfree = true;
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d -d";
    };
    optimise.automatic = true;
  };

  networking.hostName = "${hostname}";
  time.timeZone = timezone;
  services = {
    openssh.enable = true;
    tailscale.enable = true;
  };
}