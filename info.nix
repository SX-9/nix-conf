{
  hostname = "nixos";
  username = "satr14";
  flake-path = "~/Projects/nix-conf"; # set this to the cloned repo path

  legacy-boot = false; # enables grub if true
  timezone = "Asia/Jakarta";
  locale = "en_US.UTF-8";

  partition = false; # set to true to enable Disko partitioning when installing
  use-hyprland = false; # if true, Hyprland will be enabled with GNOME as backup DE

  git = { # setup your git author
    user = "satr14";
    email = "90962949+SX-9@users.noreply.github.com";
  };
}