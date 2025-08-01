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
    powertop
    smartmontools
    woeusb
    fastfetch
    ethtool
    dig
    dnslookup
    lsof
    gucharmap

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
    ffmpeg
    nmap
    sysstat
    netcat
    p7zip
    stress
    wakeonlan
    coreutils-full
    traceroute
    lxappearance

    nixd
    git
  ];
}
