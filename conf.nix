{ pkgs, username, hostname, ... }: {
  imports = [
    ./hw-scan.nix
  ];

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
    optimise.automatic = true;
  };

  boot = {
    loader.grub = {
      enable = true;
      device = "/dev/sda";
      useOSProber = true;
      default = "saved";
      theme = "${pkgs.libsForQt5.breeze-grub}/grub/themes/breeze";
    };
    plymouth = {
      enable = true;
      theme = "bgrt";
    };
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 8 * 1024;
    }
  ];

  virtualisation = {
    waydroid.enable = true;
    docker.enable = true;
    libvirtd.enable = true;
  };

  networking = {
    hostName = "${hostname}";
    networkmanager.enable = true;
    firewall.enable = false;
    nameservers = ["1.1.1.1" "1.0.0.1"];
  };

  time.timeZone = "Asia/Jakarta";
  i18n.defaultLocale = "en_US.UTF-8";

  services = {
    power-profiles-daemon.enable = true;
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    printing.enable = true;
    openssh.enable = true;
    tailscale.enable = true;
    resolved.enable = true;
  };

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  users = {
    motd = "Welcome to NixOS, ${username}!";
    users."${username}" = {
      isNormalUser = true;
      description = "${username}";
      initialPassword = "${username}";
      shell = pkgs.zsh;
      extraGroups = [
        "networkmanager"
        "wheel"
        "dialout"
        "libvirtd"
        "docker"
      ];
      packages = with pkgs; [
        spotify
        vscode
        discord
        libreoffice
        ferium
        google-chrome
        scrcpy
        virt-manager
        appimage-run
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;
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
    
    zsh-completions
    zsh-syntax-highlighting
    
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

  programs = {
    nix-ld.enable = true;
    tmux.enable = true;
    zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      ohMyZsh = {
        enable = true;
        plugins = ["git"];
        theme = "refined";
      };
    };
    kdeconnect = {
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };
    steam.enable = true;
  };

  system.stateVersion = "24.05";
}
