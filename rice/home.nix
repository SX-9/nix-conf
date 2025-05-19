{ pkgs, ... }: {
  catppuccin = {
    hyprland.accent = "sky";
    hyprlock = {
      accent = "sapphire";
      useDefaultConfig = false;
    };
  };

  imports = [
    ./hyprlock.nix
    ./hyprland.nix
    ./waybar.nix
  ];

  programs = {
    kitty = {
      enable = true;
      settings = {
        background_opacity = 0.9;
      };
    };
    rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      terminal = "${pkgs.kitty}/bin/kitty";
      # location = "top";
      # yoffset = 10;
    };
    ranger = {
      enable = true;
      aliases = {
        "sh" = "shell zsh";
        "code" = "shell code .";
        "vim" = "shell vim";
        "img" = "shell eog .";
      };
    };
    btop = {
      enable = true;
      settings.update_ms = 100;
    };
    vim.enable = true;
    bat.enable = true;
  };

  services = {
    swww.enable = true;
    hyprpolkitagent.enable = true;
    # polkit-gnome.enable = true;
    kdeconnect = {
      enable = true;
      indicator = true;
    };
    hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "hyprlock";
          unlock_cmd = "pkill -USR1 hyprlock";
        };
        listener = [
          {
            timeout = 120;
            on-timeout = "brightnessctl s 10%-";
            on-resume = "brightnessctl s +10%";
          }
          {
            timeout = 300;
            on-timeout = "hyprlock";
          }
          {
            timeout = 600;
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };
    dunst = {
      enable = true;
      settings.global = {
        width = 300;
        offset = "10x10";
        corner_radius = 10;
        frame_width = 2;
      };
    };
  };

  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
    };
  };

  gtk = {
    enable = true;
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };

  home = {
    packages = with pkgs; [
      playerctl brightnessctl
      qt6ct tailscale-systray networkmanagerapplet eog
      kitty bat btop ranger w3m gnome-calculator
      hyprlock hyprshot waybar wl-clipboard dunst swww cliphist
      rofi-network-manager rofi-power-menu rofi-wayland # rofi-calc # https://discourse.nixos.org/t/trouble-installing-rofi-plugin-rofi-calc/3847
    ];
    pointerCursor = {
      gtk.enable = true;
      package = pkgs.catppuccin-cursors.mochaLight;
      name = "catppuccin-mocha-light-cursors";
      size = 24;
    };
  };
}
