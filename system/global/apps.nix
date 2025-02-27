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

    nixd
    gh
    git
    nodejs
    nodePackages.npm
    python311
    jdk23_headless
  ];
}
