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
    gnome3.gnome-tweaks
    papirus-icon-theme
    
    libsForQt5.breeze-grub
    lm_sensors
    ntfs3g
    dconf2nix
    pciutils
    toybox
    gparted
    pavucontrol
    ventoy-bin-full
    
    android-tools
    distrobox
  ];
}
