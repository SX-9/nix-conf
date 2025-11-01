{ pkgs, inputs, ... }: {
  environment.systemPackages = (with pkgs; [
    baobab
    file-roller
    gnome-network-displays
    gnome-disk-utility
    papirus-icon-theme
    
    smartmontools
    lm_sensors
    ntfs3g
    virt-viewer
    dconf2nix
    pciutils
    gparted
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
    git
  # ]) ++ (with inputs.win.packages."${pkgs.system}"; [
  #   winapps
  #   winapps-launcher
  ]);
}
