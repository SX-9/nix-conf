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
    gnome-tweaks
    gnome-network-displays
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
    woeusb

    wineWowPackages.waylandFull
    wineWowPackages.stable
    winetricks
    android-tools
    scrcpy
    distrobox

    home-manager
    vim
    wget
    curl
    openssl_3
    htop
    btop
    ffmpeg
    nmap
    sysstat
    netcat
    p7zip
    stress
    wakeonlan
    coreutils-full
    traceroute

    nixd
    gh
    git
    go
    nodejs
    nodePackages.npm
    python311
    jdk23_headless
  ];
}
