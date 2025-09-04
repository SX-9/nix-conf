{ lib, config, pkgs, rice, ctp-opt, hostname, ... }: {
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
      package = pkgs.kitty;
      settings = {
        font_family = rice.font;
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
          font = "${rice.font} 12";
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
    wlogout = {
      enable = true;
      layout = [
        {
          label = "shutdown";
          action = "systemctl poweroff";
          text = "(S)hutdown";
          keybind = "s";
        }
        {
          label = "reboot";
          action = "systemctl reboot";
          text = "(R)eboot";
          keybind = "r";
        }
        {
          label = "hibernate";
          action = "systemctl hibernate";
          text = "(H)ibernate";
          keybind = "h";
        }
        {
          label = "suspend";
          action = "systemctl suspend";
          text = "Sus(p)end";
          keybind = "p";
        }
        {
          label = "logout";
          action = "hyprctl dispatch exit";
          text = "L(o)gout";
          keybind = "o";
        }
        {
          label = "lock";
          action = "loginctl lock-session";
          text = "(L)ock";
          keybind = "l";
        }
      ];
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
    fusuma = {
      extraPackages = with pkgs; [ ydotool systemd coreutils-full xorg.xprop ];
      enable = true;
    };
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
          before_sleep_cmd = "notify-send -u critical ${hostname} 'System is going to sleep' && hyprlock";
          after_sleep_cmd = "dunstctl close-all && pkill -USR2 hyprlock";
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
            timeout = 420;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
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
        font = "${rice.font} 8";
        width = 300;
        origin = "${if rice.bar.top then "top" else "bottom"}-right";
        offset = "${builtins.toString rice.gap.outer}x${builtins.toString (rice.gap.outer / 2)}";
        corner_radius = rice.borders.rounded;
        frame_width = rice.borders.size;
        notification_limit = 0;
        mouse_left_click = "do_action";
        mouse_middle_click = "close_current";
        mouse_right_click = "context";
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
      package = lib.mkForce pkgs.papirus-icon-theme;
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
      playerctl brightnessctl ydotool
      tailscale-systray networkmanagerapplet eog qt6ct kdePackages.qtstyleplugin-kvantum lxmenu-data 
      kitty bat btop ranger pcmanfm lxqt.pcmanfm-qt w3m
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
