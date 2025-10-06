{ username, hostname, ctp-opt, rice, ... }: {
  programs.waybar = {
    enable = true;
    settings = [
      {
        layer = "top";
        position = if rice.bar.top then "top" else "bottom";
        margin-top = if rice.bar.top then rice.gap.outer else 0;
        margin-bottom = if rice.bar.top then 0 else rice.gap.outer;
        margin-right = rice.gap.outer;
        margin-left = rice.gap.outer;

        modules-left = [
          "custom/start"
          "hyprland/workspaces"
          "hyprland/window"
        ];
        modules-center = if rice.bar.minimal then [] else [
          "custom/dunst"
          "clock"
          "tray"
          "hyprland/submap"
        ];
        modules-right = if rice.bar.minimal then [
          "tray"
          "pulseaudio"
          "network"
          "battery"
          "clock"
          "custom/dunst"
        ] else [
          "temperature"
          "cpu"
          "memory"
          "disk"
          "pulseaudio"
          "network"
          "battery"
        ];
        "cpu" = {
          states = {
            critical = 85;
          };
          interval = 1;
          format = " {usage:2}% {avg_frequency}GHz";
          on-click = "hyprctl dispatch exec '[float; size 75%]' kitty btop";
        };
        "memory" = {
          states = {
            critical = 85;
          };
          interval = 1;
          format = " {used:0.1f}GiB";
          on-click = "hyprctl dispatch exec '[float; size 75%]' kitty btop";
        };
        "disk" = {
          states = {
            critical = 85;
          };
          interval = 5;
          format = " {used}";
          on-click = "hyprctl dispatch exec '[float; size 75%]' kitty btop";
        };
        "network" = {
          interval = 1;
          format-ethernet = " {ifname}";
          format-wifi = " {signalStrength}%";
          format-disconnected = "";
          format-disabled = "";
          tooltip = false;
          on-click = "nm-connection-editor";
          on-click-right = "pkexec systemctl restart systemd-resolved NetworkManager tailscaled cloudflare-warp && notify-send ${hostname} 'Network Restarted'";
        };
        "temperature" = {
          hwmon-path =  "/sys/class/hwmon/hwmon2/temp1_input";
          critical-threshold = 80;
          format = " {temperatureC}°C";
          interval = 1;
          on-click = "hyprctl dispatch exec '[float; size 75%]' kitty btop";
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
          on-scroll-down = "hyprctl dispatch workspace e+1";
          on-scroll-up = "hyprctl dispatch workspace e-1";
        };
        "custom/dunst" = {
          format = "{}";
          exec = "echo \"$([ $(dunstctl is-paused) = 'false' ] && echo '' || echo '') $(dunstctl count history)\"";
          on-click = "dunstctl set-paused toggle";
          on-click-right = "dunstctl history-clear";
          on-scroll-up = "dunstctl history-pop";
          on-scroll-down = "dunstctl close";
          interval = 1;
        };
        "hyprland/window" = {
          icon = true;
          max-length = 55;
          separate-outputs = false;
          rewrite = {
            "" = "${username}@${hostname}";
            "~" = "${username}@${hostname}";
            "btop" = "${username}@${hostname}";
          };
          on-click-right = "hyprctl dispatch fullscreen 0";
          on-click-middle = "hyprctl dispatch killactive";
          on-click = "hyprctl dispatch fullscreen 1";
          on-scroll-up = "hyprctl dispatch cyclenext";
          on-scroll-down = "hyprctl dispatch cyclenext prev";
        };
        "hyprland/submap" = {
          format = " {}";
          on-click = "hyprctl dispatch submap reset";
        };
        "clock" = {
          format = "{:%b %d, %I:%M:%S %p}";
          interval = 1;
       };
        "tray" = {
          spacing = 12;
        };
        "taskbar" = {
          icon-size = 10;
          icon-theme = "Papirus-Dark";
          on-click = "activate";
          on-click-right = "fullscreen";
          on-click-middle = "close";
          on-scroll-up = "maximize";
          on-scroll-down = "minimize";
        };
        "pulseaudio" = {
          format = " {volume}%{format_source}";
          format-muted = " {volume}%{format_source_muted}";
          format-source = "";
          format-source-muted = " ";
          on-click = "pavucontrol";
          on-click-middle = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
          on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        };
        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}% {power}W";
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
        "custom/start" = {
          format = "";
          on-click-middle = "wlogout";
          on-click-right = "hyprctl dispatch togglespecialworkspace hidden";
          on-click = "rofi -show drun -show-icons -display-drun ''";
        };
      }
    ];
    style = ''
      * {
        font-size: 12px;
        font-family: Font Awesome, ${rice.font};
        font-weight: bold;
        color: @text;
        transition: none;
        transition: all, 0.25s ease-out;
      }

      window#waybar, .modules-left, .modules-center, .modules-right { border-radius: ${builtins.toString rice.borders.rounded}px; }
      .modules-left, .modules-center, .modules-right { padding: 0 5px; }
      window#waybar${if rice.bar.fragmented then ":not(.empty):not(.floating)" else ""}, .modules-left, ${if rice.bar.minimal then "" else ".modules-center,"} .modules-right {
        background-color: @crust;
        border: ${builtins.toString rice.borders.size}px solid @surface0;
      }
      ${if rice.bar.fragmented then "
      window#waybar:not(.empty):not(.floating) .modules-right, window#waybar:not(.empty):not(.floating) .modules-center{
        border-left: none;
      }
      window#waybar:not(.empty):not(.floating) .modules-left, window#waybar:not(.empty):not(.floating) .modules-center {
        border-right: none;
      }
      " else ""}
      window#waybar${if rice.bar.fragmented then ":not(.empty):not(.floating)" else ""} .modules-center {
        border-radius: 0px;
      }
      window#waybar${if rice.bar.fragmented then ":not(.empty):not(.floating)" else ""} .modules-left {
        border-radius: ${builtins.toString rice.borders.rounded}px 0px 0px ${builtins.toString rice.borders.rounded}px;
      }
      window#waybar${if rice.bar.fragmented then ":not(.empty):not(.floating)" else ""} .modules-right {
        border-radius: 0px ${builtins.toString rice.borders.rounded}px ${builtins.toString rice.borders.rounded}px 0px;
      }
      window#waybar {
        background: rgba(0,0,0,0);
        border: ${builtins.toString rice.borders.size}px solid transparent;
      }

      #window, #submap { padding: 0px 5px; }
      #submap, #workspaces, #cpu, #memory, #disk, #clock, #window, #tray, #pulseaudio, #battery, #network, #temperature, #power-profiles-daemon, #custom-exit, #custom-start, #custom-dunst { padding: 0px 5px; margin: 0px 5px; }

      #workspaces button {
        border-radius: 0px;
        margin: 0px;
        background: none;
        border: none;
      }

      #workspaces button:hover, #custom-start:hover, #window:hover {
        border: none;
        outline: none;
        background: none;
        color: @text;
        background-size: 300% 300%;
        background: @base;
      }

      #workspaces button.active, #submap {
        background: @surface0;
      }

      #custom-start {
        padding: 0px 5px;
        color: @${ctp-opt.primary};
        font-size: 16px;
        font-weight: normal;
      }

      .critical, .muted, .performance { color: @red; }
      .warning, .urgent, .disabled, .disconnected { color: @yellow; }
      .charging, .plugged, .power-saver { color: @green; }
    '';
  };
}