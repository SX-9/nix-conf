{ pkgs, inputs, useHyprland, ... }: {
  programs.hyprland = {
    enable = useHyprland;
    package = inputs.hl.packages."${pkgs.system}".hyprland;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };

  environment = {
    systemPackages = with pkgs; [ waybar dunst libnotify swww kitty networkmanagerapplet rofi-wayland ];
    sessionVariables = if useHyprland then {
      # WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
    } else {};
  };
}