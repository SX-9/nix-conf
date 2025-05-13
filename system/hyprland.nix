{ pkgs, inputs, use-hyprland, ... }: {
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  programs.hyprland = {
    enable = use-hyprland;
    package = inputs.hl.packages."${pkgs.system}".hyprland;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };

  environment = {
    systemPackages = with pkgs; [ libnotify networkmanagerapplet hyprshot ];
    sessionVariables = if use-hyprland then {
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
    } else {};
  };
}