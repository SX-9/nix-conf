{ lib, pkgs, inputs, rice, enable-dm, ... }: {
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  programs = {
    ydotool.enable = true;
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
      enable = rice.enable;
      xwayland.enable = true;
      package = if rice.enable then inputs.hl.packages."${pkgs.system}".hyprland else pkgs.hyprland;
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
    displayManager = {
      gdm.enable = lib.mkForce false;
      sddm = {
        enable = if rice.enable then enable-dm else false;
        wayland.enable = true;
        theme = "sddm-stray";
        package = pkgs.kdePackages.sddm;
        extraPackages = with pkgs.kdePackages; [
          qtmultimedia
          qtsvg
        ];
      };
    };
  };

  environment = {
    systemPackages = with pkgs; if rice.enable then [ libsecret libnotify kdePackages.kdeconnect-kde inputs.dm.packages.${pkgs.system}.default ] else [];
    sessionVariables = if rice.enable then {
      XDG_RUNTIME_DIR = "/run/user/$UID"; # https://discourse.nixos.org/t/login-keyring-did-not-get-unlocked-hyprland/40869/10
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
    } else {};
  };
}
