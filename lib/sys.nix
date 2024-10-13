{ pkgs, hostname, ... }: {
  system.stateVersion = "24.05";
  nixpkgs = {
    config = {
      packageOverrides = pkgs: {
        unstable = import (builtins.fetchTarball {
          url = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
        }) {};
      };
      allowUnfree = true;
    };
  };
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
    ../hw/scan.nix
    ./apps.nix
  ];

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

  programs = {
    nix-ld.enable = true;
    tmux.enable = true;
    zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        "zshrc" = "vim ~/.zshrc && omz reload";
        "sys" = "sudo systemctl";
        "user" = "systemctl --user";
        "sys-log" = "journalctl --folloe -b -u";
        "user-log" = "journalctl --follow -b --user-unit";
        "tsip" = "tailscale ip -4";
        "rmall" = "rm -rf ./* ./.*";
        "fetch-update" = "wget https://raw.githubusercontent.com/SX-9/fetch.sh/master/fetch.sh -O ~/.fetch.sh && chmod +x ~/.fetch.sh";
      };
      shellInit = ''
        if [[ $TERM_PROGRAM != 'vscode' ]]; then
          echo && ~/.fetch.sh color 2> /dev/null
        fi
      '';
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
}
