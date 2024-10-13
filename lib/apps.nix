{ pkgs, ... }: {
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
    
    vim
    wget
    curl
    libsForQt5.breeze-grub
    lm_sensors
    openssl_3_3
    ntfs3g
    home-manager
    dconf2nix
    
    gparted
    htop
    nixd
    vlc
    pciutils
    toybox

    gh
    git
    nodejs
    nodePackages.npm
    python311
    jdk22_headless
    android-tools
    distrobox
  ];
}