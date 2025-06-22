{
  flake-path = "~/Projects/nix-conf"; # set this to the cloned repo path

  hostname = "nixos";
  username = "satr14";

  timezone = "Asia/Jakarta";
  locale = "en_US.UTF-8";

  legacy-boot = false; # enables grub if true
  partition = false; # set to true to enable Disko partitioning when installing
  enable-dm = true; # enable display manager (for server use)

  swapfile = 4 * 1024; # swapfile size in MiB, set it to the same as RAM size for hibernation
  homelab = false; # enables all /homelab docker containers

  rice = {
    qs = false; # enable Quickshell
    enable = false; # if true, Hyprland will be enabled with GNOME as backup DE
    top-bar = true; # enable top bar, false will put the bar at the bottom
    gap = { # set the gap size in pixel
      outer = 10;
      inner = 5;
    };
    borders = {
      colored = false; # enable colored borders
      rounded = 6; # rounded corners in pixel
      size = 1; # border size in pixel
    };
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
