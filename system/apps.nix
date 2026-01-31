{ pkgs, ... }: {
  nixpkgs.config.permittedInsecurePackages = [
    "ventoy-qt5-1.1.10"
  ];

  environment.systemPackages = with pkgs; [
    baobab
    file-roller
    gnome-network-displays
    gnome-disk-utility
    
    smartmontools
    lm_sensors
    ntfs3g
    virt-viewer
    dconf2nix
    pciutils
    gparted
    exfatprogs
    pavucontrol
    jq
    powertop
    smartmontools
    fastfetch
    ethtool
    dig
    dnslookup
    lsof
    gucharmap
    ncdu
    zip
    blueman
    shared-mime-info
    usbutils

    android-tools
    scrcpy
    distrobox

    ventoy-full-qt
    home-manager
    vim
    wget
    curl
    openssl_3
    htop
    nmap
    sysstat
    netcat
    p7zip
    stress
    wakeonlan
    coreutils-full
    traceroute
    lxappearance
    freerdp

    nix-index
    nixd
    nil
    nh
    git
  ];
}
