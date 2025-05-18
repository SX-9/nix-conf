{ pkgs, ... }: let 
  ctp = {
    flavor = "mocha";
    enable = true;
  };
in {
  catppuccin = {
    waybar = ctp;
    rofi = ctp;
    kitty = ctp;
    dunst = ctp;
    btop = ctp;
    bat = ctp;
    hyprland = {
      accent = "sapphire";
    } // ctp;
  };

  imports = [
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
    hyprlock = {
      settings = {
        background = [
          {
            path = "screenshot";
            blur_passes = 3;
            blur_size = 8;
          }
        ];

      };
      enable = true;
    };
    rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
    };
    ranger = {
      enable = true;
      aliases = {
        "sh" = "shell zsh";
        "code" = "shell code .";
        "vim" = "shell vim";
        "gedit" = "shell gnome-text-editor";
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
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
          lock_cmd = "hyprlock";
          unlock_cmd = "pkill -USR1 hyprlock";
        };
        listener = [
          {
            timeout = 120;
            on-timeout = "hyprlock";
          }
          {
            timeout = 300;
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
      kitty bat btop ranger 
      hyprlock hyprshot waybar wl-clipboard dunst swww cliphist
      rofi-screenshot rofi-wayland rofi-network-manager rofi-power-menu w3m
    ];
    pointerCursor = {
      gtk.enable = true;
      package = pkgs.catppuccin-cursors.mochaLight;
      name = "catppuccin-mocha-light-cursors";
      size = 24;
    };
  };
}
