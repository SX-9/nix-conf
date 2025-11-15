{ pkgs, swapfile, hostname, timezone, locale, legacy-boot, enable-dm, wol, zerotier, ... }: {
  system.stateVersion = "24.11";
  nixpkgs.config.allowUnfree = true;
  nix = {
    settings = {
      substituters = [
        "https://hyprland.cachix.org"
        "https://winapps.cachix.org"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "winapps.cachix.org-1:HI82jWrXZsQRar/PChgIx1unmuEsiQMQq+zt05CD36g="
      ];
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
    kernelModules = [ "rndis_host" "cdc_ether" ];
    supportedFilesystems = [ "ext4" "btrfs" "vfat" "ntfs" ];
    kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
    };
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
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=true"
      #"rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
  };
  swapDevices = if swapfile == 0 then [] else [
    {
      device = "/swapfile";
      size = swapfile;
    }
  ];

  virtualisation = {
    # waydroid.enable = true;
    docker.enable = true;
    # libvirtd = {
    #   enable = true;
    #   qemu = {
    #     package = pkgs.qemu_kvm;
    #     swtpm.enable = true;
    #     runAsRoot = false;
    #     ovmf = {
    #       enable = false;
    #       packages = [(pkgs.OVMF.override {
    #         secureBoot = true;
    #         tpmSupport = true;
    #       }).fd];
    #     };
    #   };
    # };
  };

  networking = {
    hostName = "${hostname}";
    networkmanager.enable = true;
    firewall.enable = false;
    nameservers = ["1.1.1.1" "1.0.0.1"];
    interfaces."${wol}".wakeOnLan.enable = wol != "";
  };

  systemd.services.enable-wol = {
    enable = wol != "";
    description = "Enable Wake-on-LAN on ${wol}";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.ethtool}/bin/ethtool -s ${wol} wol g";
      Restart = "on-failure";
    };
  };

  hardware.graphics = {
    enable = true;
    extraPackages = [ pkgs.vaapiVdpau ];
  };
  time.timeZone = timezone;
  i18n.defaultLocale = locale;
  environment.localBinInPath = true;

  services = {
    displayManager.gdm.enable = enable-dm;
    # desktopManager.gnome.enable = true;
    xserver = {
      # displayManager.startx.enable = !enable-dm;
      enable = true;
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
    sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
    };
    printing = {
      enable = true;
      drivers = with pkgs; [ hplip ];
    };
    zerotierone = {
      enable = true;
      joinNetworks = zerotier.networks;
    };
    tailscale.enable = true;
    cloudflare-warp.enable = true;
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
    pulseaudio.enable = false;
    openssh.enable = true;
    resolved.enable = true;
  };

  security = {
    rtkit.enable = true;
    sudo.configFile = ''
      Defaults insults
      Defaults passwd_tries = 5
    '';
  };

  fonts.packages = with pkgs; [
    corefonts
  ];

  programs = {
    gdk-pixbuf.modulePackages = [ pkgs.librsvg ];
    zsh.enable = true;
    nix-ld.enable = true;
    steam.enable = true;
    kdeconnect = {
      enable = true;
    };
  };
}
