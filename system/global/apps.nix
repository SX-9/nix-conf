{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
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
