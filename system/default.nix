{ pkgs, swapfile, hostname, timezone, locale, legacy-boot, enable-dm, wol, ... }: {
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
  time.timeZone = timezone;
  i18n.defaultLocale = locale;

  systemd.services = (if wol == "" then {} else {
    "enable-wol" = {
      description = "Reenable wake on lan every boot";
      after = [ "network.target" ];
      serviceConfig = {
        Type = "simple";
        RemainAfterExit = "true";
        ExecStart = "${pkgs.ethtool}/sbin/ethtool -s ${wol} wol g";
      };
      wantedBy = [ "default.target" ];
    };
  }) // (if enable-dm then {
    "getty@tty1".enable = false;
    "autovt@tty1".enable = false; 
  } else {});
  # ^^ GDM Temporary Fix: https://discourse.nixos.org/t/gnome-display-manager-fails-to-login-until-wi-fi-connection-is-established/50513/15

  services = {
    displayManager.gdm.enable = enable-dm;
    desktopManager.gnome.enable = true;
    xserver = {
      displayManager.startx.enable = !enable-dm;
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
    zsh.enable = true;
    nix-ld.enable = true;
    steam.enable = true;
    kdeconnect = {
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };
  };
}
