{ config, pkgs, swapfile, hostname, timezone, locale, legacy-boot, wol, enable-dm, zerotier, ... }: {
  imports = [ ./apps.nix ];

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