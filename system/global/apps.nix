{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    home-manager
    vim
    wget
    curl
    openssl_3_3
    htop
    ffmpeg
    nmap
    
    nixd
    gh
    git
    nodejs
    nodePackages.npm
    python311
    jdk23_headless
  ];
}
