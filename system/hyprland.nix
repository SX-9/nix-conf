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

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  fonts.packages = with pkgs; [
    font-awesome
    nerd-fonts.droid-sans-mono
    fira-code
  ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };

  security.pam.services.gdm-password.enableGnomeKeyring = true;

  environment = {
    systemPackages = with pkgs; if use-hyprland then [ libnotify networkmanagerapplet hyprshot plasma5Packages.kdeconnect-kde ] else [];
    sessionVariables = if use-hyprland then {
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
    } else {};
  };
}