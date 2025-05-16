{
  hostname = "nixos";
  username = "satr14";
  legacy-boot = false;
  partition = false; # set to true to enable disko partitioning

  use-hyprland = false; # Hyprland will be enabled with GNOME as secondary DE

  git = {
    user = "satr14";
    email = "90962949+SX-9@users.noreply.github.com";
  };
}