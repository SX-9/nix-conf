{ pkgs, hostname, legacy-boot, ... }: {
  system.stateVersion = "24.11";
  nixpkgs.config.allowUnfree = true;
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d -d";
    };
    optimise.automatic = true;
  };
  imports = [
    ../hardware/scan.nix
    ../rice/system.nix
    ./apps.nix
  ];

  boot = {
    supportedFilesystems = [ "ext4" "btrfs" "vfat" "ntfs" ];
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = !legacy-boot;
        configurationLimit = 3;
        sortKey = "z-nixos";
        editor = false;
      };
      grub = {
        enable = legacy-boot; #true;
        device = "/dev/sda";
        useOSProber = true;
        default = "saved";
        theme = "${pkgs.libsForQt5.breeze-grub}/grub/themes/breeze";
      };
    };
    plymouth = {
      enable = true;
      theme = "bgrt";
    };
    kernelParams = [
      #"quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      #"rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
  };
  swapDevices = [
    {
      device = "/swapfile";
      size = 2 * 1024;
    }
  ];

  virtualisation = {
    waydroid.enable = true;
    docker.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
        runAsRoot = false;
        ovmf = {
          enable = false;
          packages = [(pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd];
        };
      };
    };
  };

  networking = {
    hostName = "${hostname}";
    networkmanager.enable = true;
    firewall.enable = false;
    nameservers = ["1.1.1.1" "1.0.0.1"];
  };

  hardware.graphics = {
    enable = true;
    extraPackages = [ pkgs.vaapiVdpau ];
  };
  time.timeZone = "Asia/Jakarta";
  i18n.defaultLocale = "en_US.UTF-8";

  # GDM Temporary Fix: https://discourse.nixos.org/t/gnome-display-manager-fails-to-login-until-wi-fi-connection-is-established/50513/15
  systemd.services = {
    "getty@tty1".enable = false;
    "autovt@tty1".enable = false; 
  };

  services = {
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
      jack.enable = true;
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
    };
    printing = {
      enable = true;
      drivers = with pkgs; [ hplip ];
    };
    pulseaudio.enable = false;
    flatpak.enable = true;
    openssh.enable = true;
    tailscale.enable = true;
    resolved.enable = true;
  };

  security.rtkit.enable = true;

  fonts.packages = with pkgs; [
    corefonts
    vistafonts
  ];

  programs = {
    zsh.enable = true;
    nix-ld.enable = true;
    steam.enable = true;
    kdeconnect = {
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };
  };
}
