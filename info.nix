{
  flake-path = "~/Projects/nix-conf"; # set this to the cloned repo path

  hostname = "nixos";
  username = "satr14";

  timezone = "Asia/Jakarta";
  locale = "en_US.UTF-8";

  legacy-boot = false; # enables grub if true
  partition = false; # set to true to enable Disko partitioning when installing
  enable-dm = true; # enable display manager (for server use)

  rice = {
    enable = false; # if true, Hyprland will be enabled with GNOME as backup DE
  };

  ctp-opt = { # configure Catppuccin theme
    primary = "sky";
    accent = "blue";
    flavor = "mocha";
  };

  git = { # setup your git author
    user = "satr14";
    email = "90962949+SX-9@users.noreply.github.com";
  };
}
