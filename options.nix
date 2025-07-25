{
  flake-path = "~/Projects/nix-conf"; # set this to the cloned repo path

  hostname = "nixos";
  username = "satr14";

  timezone = "Asia/Jakarta";
  locale = "en_US.UTF-8";

  legacy-boot = false; # enables grub if true
  partition = false; # set to true to enable Disko partitioning when installing
  enable-dm = true; # enable display manager (for server use)

  wol = "enp0s31f6"; # set to iface name to enable Wake-on-LAN
  swapfile = 0; # * 1024; # swapfile size in MB, set to 0 to disable
  resume-dev = ""; # set to swap partition to enable hibernation, e.g. /dev/disk/by-uuid/1721721a-bb5a-4166-a077-9500d30be2ac

  homelab = {
    enable = true; # set to true before setting the options below
    docker-services = false; # enables all /homelab docker containers 
    root-ssh = true; # enables root ssh access
    rdp = true; # enables xrdp for remote desktop access with GNOME
  };

  rice = {
    enable = false; # if true, Hyprland will be enabled with GNOME as backup DE
    font = "monospace"; # global font for rice GUIs, leave empty to use monospace
    bar = {
      top = true; # false will put the bar at the bottom
      fragmented = true; # enable fragmented bar, false will make it a single block
      minimal = false; # less verbose bar
    };
    gap = { # set the gap size in pixel
      outer = 8;
      inner = 4;
    };
    borders = {
      colored = false; # enable colored borders
      rounded = 0; # rounded corners in pixel
      size = 1; # border size in pixel
    };
  };

  ctp-opt = { # configure Catppuccin theme
    primary = "sky";
    accent = "sapphire";
    flavor = "mocha";
  };

  mc.email = "user@example.com"; # set your Minecraft email for portablemc
  git = { # setup your git author
    user = "satr14";
    email = "90962949+SX-9@users.noreply.github.com";
  };
}
