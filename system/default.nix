{ pkgs, config, swapfile, locale, legacy-boot, wol, enable-dm, zerotier, ... }: {
  imports = [
    ../hardware/scan.nix
    ../rice/system.nix
    ./base.nix
  ];

  boot = {
    kernelModules = [ "rndis_host" "cdc_ether" ];
    supportedFilesystems = [ "ext4" "btrfs" "vfat" "ntfs" "exfat" ];
    plymouth.enable = true;
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
    networkmanager.enable = true;
    firewall.enable = false;
    nameservers = ["1.1.1.1" "1.0.0.1"];
  };

  hardware.graphics = {
    enable = true;
    extraPackages = [ pkgs.libva-vdpau-driver ];
  };
  i18n.defaultLocale = locale;
  environment.localBinInPath = true;

  systemd.services."wol" = {
    enable = wol != "";
    description = "Wake-on-LAN for ${wol}";
    requires = [ "network.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.ethtool}/bin/ethtool -s ${wol} wol g";
      Type = "oneshot";
    };
    wantedBy = [ # just in case 
      "multi-user.target"
      "sleep.target"
      "suspend.target"
      "hibernate.target"
      "hybrid-sleep.target"
      "shutdown.target"
      "reboot.target"
      "halt.target"
    ];
  };

  services = {
    displayManager.gdm.enable = enable-dm;
    xserver = {
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
    cloudflare-warp.enable = true;
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
    blueman.enable = true;
    pulseaudio.enable = false;
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
    appimage = {
      enable = true;
      binfmt = true;
    };
    kdeconnect = {
      enable = true;
    };
  };
}
