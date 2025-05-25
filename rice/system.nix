{ lib, pkgs, inputs, use-hyprland, ... }: {
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  programs = {
    xfconf.enable = true;
    kdeconnect.enable = lib.mkForce false; # enabled in home-manager
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
    hyprland = {
      enable = use-hyprland;
      xwayland.enable = true;
      package = inputs.hl.packages."${pkgs.system}".hyprland;
      portalPackage = inputs.hl.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    };
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  fonts.packages = with pkgs; [
    font-awesome
    nerd-fonts.droid-sans-mono
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [
      inputs.hl.packages.${pkgs.system}.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  security.pam.services.gdm-password.enableGnomeKeyring = true;
  services = {
    gvfs.enable = true;
    tumbler.enable = true;
    gnome.gnome-keyring.enable  = true;
    logind.extraConfig = ''
      HandlePowerKey=ignore
    '';
  };

  environment = {
    systemPackages = with pkgs; if use-hyprland then [ libsecret libnotify kdePackages.kdeconnect-kde ] else [];
    sessionVariables = if use-hyprland then {
      XDG_RUNTIME_DIR = "/run/user/$UID"; # https://discourse.nixos.org/t/login-keyring-did-not-get-unlocked-hyprland/40869/10
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
    } else {};
  };
}