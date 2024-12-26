{ pkgs, hostname, ... }: {
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
    };
    optimise.automatic = true;
  };
  imports = [
    ../../hardware/scan.nix
    ./apps.nix
  ];

  boot = {
    supportedFilesystems = [ "ext4" "btrfs" "vfat" "ntfs" ];
    loader = {
      efi.canTouchEfiVariables = true;
      #systemd-boot.enable = true;
      grub = {
        enable = true;
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

  time.timeZone = "Asia/Jakarta";
  i18n.defaultLocale = "en_US.UTF-8";

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
    xrdp = {
      enable = true;
      defaultWindowManager = "${pkgs.gnome3.gnome-session}/bin/gnome-session";
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    printing = {
      enable = true;
      drivers = with pkgs; [ hplipWithPlugin ];
    };
    openssh.enable = true;
    tailscale.enable = true;
    resolved.enable = true;
  };

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

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
