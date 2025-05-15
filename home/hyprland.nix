{ pkgs, inputs, username, hostname, ... }: let 
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
    hyprland = {
      accent = "sapphire";
    } // ctp;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hl.packages."${pkgs.system}".hyprland;
    xwayland.enable = true;
    plugins = with inputs.hlp.packages."${pkgs.system}"; [
      # hyprbars
    ];
    settings = {
      monitor = ",preferred,auto,auto";

      exec-once = [
        "hyprctl setcursor catppuccin-mocha-light-cursors 24"
        "gsettings set org.gnome.desktop.interface gtk-theme \"YOUR_DARK_GTK3_THEME\""
        "gsettings set org.gnome.desktop.interface color-scheme \"prefer-dark\""
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"

        # "nm-applet &"
        "tailscale-systray &"
        "waybar &"
        "swww-daemon &"
	      "rofi -show drun"
      ];

      env = [
        "XCURSOR_SIZE,24"
        "XCURSOR_THEME,catppuccin-mocha-light-cursors"
        "HYPRCURSOR_SIZE,24"
        "HYPRCURSOR_THEME,catppuccin-mocha-light-cursors"
        "GTK_APPLICATION_PREFER_DARK_THEME,1"
        "GTK_THEME,Adwaita:dark"
        "QT_QPA_PLATFORMTHEME,qt6ct"
      ];

      general = {
        gaps_in = 5;
        gaps_out = "10,10,10,10";
        border_size = 2;
        resize_on_border = true;
        allow_tearing = false;
        layout = "dwindle";

        "col.active_border" = "rgb(94e2d5)";
        "col.inactive_border" = "rgb(bac2de)";
      };

      plugin = {
        # hyprbars = {
        #   bar_height = 20;
        #   bar_part_of_window = true;
        #   bar_precedence_over_border = true;
        #   bar_text_align = "left";
        #   bar_color = "rgb(313244)";
        #   hyprbars-button = [
        #     "rgb(f38ba8), 10, Q, hyprctl dispatch killactive"
        #     "rgb(f9e2af), 10, W, hyprctl dispatch fullscreen 1"
        #   ];
        # };
      };

      decoration = {
        rounding = 10;
        rounding_power = 2;
        active_opacity = 1.0;
        inactive_opacity = 0.9;

        shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            color = "rgba(1a1a1aee)";
        };

        blur = {
            enabled = true;
            size = 3;
            passes = 1;
            vibrancy = 0.1696;
        };
      };

      animations = {
        enabled = true;

        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];

        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 1, 1.94, almostLinear, fade"
          "workspacesIn, 1, 5, easeOutQuint, slidefade 20%"
          "workspacesOut, 1, 1, easeOutQuint, slidefade 20%"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master.new_status = "master";
      gestures.workspace_swipe = true;

      misc = {
          force_default_wallpaper = 0;
          disable_hyprland_logo = true;
      };

      input = {
          kb_layout = "us";
          follow_mouse = 1;
          sensitivity = 0;
          touchpad.natural_scroll = true;
      };

      bind = [
        ", PRINT, exec, hyprshot -m region"
        "SUPER SHIFT, S, exec, hyprshot -m region"
        "SUPER, R, exec, rofi -show drun"
        "SUPER, T, exec, kitty"
        "SUPER, E, exec, nautilus"
        "SUPER, L, exec, hyprlock"
        "SUPER, Q, killactive,"
        "SUPER, W, fullscreen, 1"
        "SUPER, M, exit,"
        "SUPER, F, togglefloating,"
        "SUPER, G, togglesplit,"
        "SUPER, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"

        "ALT, TAB, cyclenext,"
        "ALT, TAB, bringactivetotop,"
        "ALT SHIFT, TAB, cyclenext, prev"
        "ALT SHIFT, TAB, bringactivetotop,"
        "SUPER, TAB, cyclenext,"
        "SUPER, TAB, bringactivetotop,"
        "SUPER SHIFT, TAB, cyclenext, prev"
        "SUPER SHIFT, TAB, bringactivetotop,"

        "SUPER, down, togglespecialworkspace, magic"
        "SUPER SHIFT, down, movetoworkspace, special:magic"

        "SUPER SHIFT, right, movetoworkspace, +1"
        "SUPER SHIFT, left, movetoworkspace, -1"
        "SUPER, right, workspace, e+1"
        "SUPER, left, workspace, e-1"
      ];

      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];

      bindl = [
        ", switch:on:Lid Switch, exec, hyprlock & systemctl suspend"
      ];

      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];

      windowrule = [
        "suppressevent maximize, class:.*"
        "suppressevent minimize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      ];
    };
  };

  programs = {
    waybar = {
      enable = true;
      settings = [
        {
          margin-top = 10;
          margin-left = 10;
          margin-right = 10;
          layer = "top";
          position = "top";

          modules-left = [
            "hyprland/workspaces"
            "hyprland/window"
          ];
          modules-center = [];
          modules-right = [
            "tray"
            "temperature"
            "cpu"
            "memory"
            "disk"
            "network"
            "pulseaudio"
            "battery"
            "power-profiles-daemon"
            "clock"
          ];
          "cpu" = {
            states = {
              critical = 85;
            };
            interval = 1;
            format = " {usage:2}%";
          };
          "memory" = {
            states = {
              critical = 85;
            };
            interval = 1;
            format = " {percentage}%";
          };
          "disk" = {
            states = {
              critical = 85;
            };
            interval = 5;
            format = " {percentage_used}%";
          };
          "network" = {
            format-ethernet = " {bandwidthDownOctets}";
            format-wifi = " {signalStrength}%";
            format-disconnected = "";
            tooltip = false;
            on-click = "kitty nmtui";
          };
          "temperature" = {
            critical-threshold = 80;
            format = " {temperatureC}°C";
            interval = 1;
          };
          "power-profiles-daemon" = {
            format = "{icon} {profile}";
            format-icons = {
              performance = "";
              power-saver = "";
              balanced = "";
            };
          };
          "hyprland/workspaces" = {
            format = "{name}";
            format-icons = {
              default = " ";
              active = " ";
              urgent = " ";
            };
            on-scroll-up = "hyprctl dispatch workspace e+1";
            on-scroll-down = "hyprctl dispatch workspace e-1";
          };
          "clock" = {
            format = "{:%b %d, %I:%M %p}";
          };
          "hyprland/window" = {
            max-length = 45;
            separate-outputs = false;
            rewrite = {
              "" = "${username}@${hostname}";
            };
          };
          "tray" = {
            spacing = 12;
          };
          "pulseaudio" = {
            format = "{icon} {volume}% {format_source}";
            format-bluetooth = "{volume}% {icon} {format_source}";
            format-bluetooth-muted = " {icon} {volume}% {format_source_muted}";
            format-muted = " {volume}% {format_source_muted}";
            format-source = "";
            format-source-muted = "";
            format-icons = {
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = [
                ""
                ""
                ""
              ];
            };
            on-click = "pavucontrol";
            on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          };
          "battery" = {
            states = {
              warning = 30;
              critical = 15;
            };
            format = "{icon} {capacity}%";
            format-charging = " {capacity}%";
            format-plugged = " {capacity}%";
            format-icons = [
              ""
              ""
              ""
              ""
              ""
            ];
            interval = 1;
            on-click = "";
          };
        }
      ];
      style = ''
        * {
          font-size: 12px;
          font-family: Font Awesome, monospace;
          font-weight: bold;
          color: @text;
          transition: none;
        }

        window#waybar { background: rgba(0,0,0,0); border: none; }

        #workspaces button {
          border-radius: 0px;
          margin: 0px;
          background: none;
          border: none;
        }

        #workspaces button:hover {
          border: none;
          outline: none;
          background: none;
          color: @text;
          background-size: 300% 300%;
          background: @surface0;
        }

        #workspaces button.active {
          background: @surface1;
        }

        .modules-left, .modules-right {
          background-color: @base;
          border: 2px solid @surface1;
          border-radius: 15px;
        }
        #workspaces, #cpu, #memory, #disk, #clock, #window, #tray, #pulseaudio, #battery, #network, #temperature, #power-profiles-daemon {
          margin: 0 10px;
        }
        .critical, .muted, .performance {
          color: @red;
        }
        .warning {
          color: @yellow;
        }
        .charging, .plugged, .power-saver {
          color: @green;
        }
      '';
    };
    kitty.enable = true;
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
  };

  services = {
    dunst.enable = true;
    swww.enable = true;
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
      playerctl brightnessctl hyprlock waybar dunst kitty qt6ct wl-clipboard cliphist tailscale-systray swww rofi-wayland
    ];
    pointerCursor = {
      gtk.enable = true;
      package = pkgs.catppuccin-cursors.mochaLight;
      name = "catppuccin-mocha-light-cursors";
      size = 24;
    };
  };
}
