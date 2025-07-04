{ config, pkgs, rice, ctp-opt, ... }: {
  catppuccin = {
    hyprland.accent = ctp-opt.primary;
    hyprlock.useDefaultConfig = false;
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
        background_opacity = 0.8;
        background_blur = 4;
        window_padding_width = 8;
        cursor_shape = "beam";
        cursor_trail = 10;
        copy_on_select = true;
      };
    };
    rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      terminal = "${pkgs.kitty}/bin/kitty";
      # location = "top";
      # yoffset = 10;
      theme = let inherit (config.lib.formats.rasi) mkLiteral; in {
        "entry".placeholder = "Search...";
        "scrollbar".border-radius = rice.borders.rounded;
        # "element-icon".size = mkLiteral "2em";
        "*" = {
          normal-foreground = mkLiteral "@text";
          alternate-normal-foreground = mkLiteral "@text";
          foreground = mkLiteral "@${ctp-opt.accent}";
          border-color = mkLiteral (if rice.borders.colored then "@foreground" else "@overlay0");
        };
        "window" = {
          border-radius = rice.borders.rounded;
          border = rice.borders.size;
          # fullscreen = true;
        };
        "listview" = {
          columns = 2; # 3;
          lines = 9; # 3;
          fixed-columns = false;
        };
        "element" = {
          border-radius = rice.borders.rounded;
          padding = mkLiteral "4px";
          spacing = mkLiteral "8px";
          # orientation = mkLiteral "vertical";
        };
      };
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
      settings = {
        update_ms = 100;
        shown_boxes = "proc cpu";
      };
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      plugins = with pkgs.vimPlugins; [
        bufferline-nvim
        nvim-web-devicons
        nvim-treesitter
        nvim-lspconfig
        telescope-file-browser-nvim
        nvim-tree-lua
        nvim-cmp
        barbar-nvim
        indent-blankline-nvim
      ];
    };
    zsh.shellAliases = {
      "cd-gvfs" = "cd /run/user/$(id -u)/gvfs";
      "ssh" = "TERM=xterm-256color ssh";
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
          before_sleep_cmd = "hyprlock && notify-send -u critical Hyprland 'System is going to sleep'";
          after_sleep_cmd = "pkill -USR2 hyprlock && dunstctl close-all";
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
            on-resume = "pkill -USR2 hyprlock";
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
        origin = "${if rice.bar.top then "top" else "bottom"}-right";
        offset = "${builtins.toString rice.gap.outer}x${builtins.toString (rice.gap.outer / 2)}";
        corner_radius = rice.borders.rounded;
        frame_width = rice.borders.size;
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
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style = {
      name = "kvantum";
      package = pkgs.catppuccin-kvantum.override {
        variant = ctp-opt.flavor;
        accent = ctp-opt.accent;
      };
    };
  };

  home = {
    packages = with pkgs; [
      playerctl brightnessctl
      tailscale-systray networkmanagerapplet eog qt6ct kdePackages.qtstyleplugin-kvantum
      kitty bat btop ranger w3m gnome-calculator gnome-clocks
      hyprlock hyprshot waybar hypridle wl-clipboard dunst swww cliphist wayvnc
      rofi-network-manager rofi-power-menu rofi-wayland # rofi-calc # https://discourse.nixos.org/t/trouble-installing-rofi-plugin-rofi-calc/3847
    ];
    pointerCursor = {
      gtk.enable = true;
      package = pkgs.catppuccin-cursors."${ctp-opt.flavor}Light";
      name = "catppuccin-${ctp-opt.flavor}-light-cursors";
      size = 24;
    };
  };
}
