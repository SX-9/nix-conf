{ pkgs, ... }: {
  imports = [
    ../global/apps.nix
  ];
  environment.systemPackages = with pkgs; [
    gnomeExtensions.dash-to-panel
    gnomeExtensions.alphabetical-app-grid
    gnomeExtensions.gsconnect
    gnomeExtensions.impatience
    gnomeExtensions.status-area-horizontal-spacing
    gnomeExtensions.tailscale-status
    gnomeExtensions.clipboard-history
    gnomeExtensions.freon
    gnome-tweaks
    papirus-icon-theme
    
    libsForQt5.breeze-grub
    smartmontools
    lm_sensors
    ntfs3g
    dconf2nix
    pciutils
    gparted
    pavucontrol
    jq
    cava
    ventoy-full
    parsec-bin
    powertop
    smartmontools

    wineWowPackages.waylandFull
    wineWowPackages.stable
    winetricks
    android-tools
    scrcpy
    distrobox
  ];
}
