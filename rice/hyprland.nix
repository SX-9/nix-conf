{ inputs, pkgs, rice, ctp-opt, ... }: {
  imports = [
    ./keybinds.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    package = pkgs.hyprland; # inputs.hl.packages."${pkgs.system}".hyprland;
    xwayland.enable = true;
    settings = {
      debug = {
        error_position = 1;
        disable_logs = true;
      };

      # monitor = [
      #   "eDP-1,preferred,auto,1"
      #   ",preferred,auto,1"
      # ];
      source = [
        "~/.config/hypr/monitors.conf"
        "~/.config/hypr/workspaces.conf"
      ]; # nwg-displays

      exec-once = [
        "hyprctl setcursor catppuccin-mocha-light-cursors 24"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"

        #"dunst &"
        #"hypridle &"
        #"swww-daemon &"
        "uwsm app -s s -- waybar &"
        "uwsm app -s b -- sunshine &"

        "uwsm app -s b -- blueman-applet &"
        "uwsm app -s b -- nm-applet &"
        "uwsm app -s b -- tailscale-systray &"
        #"keepassxc &"
      ];

      env = [
        "XCURSOR_SIZE,24"
        "XCURSOR_THEME,catppuccin-${ctp-opt.flavor}-light-cursors"
        "HYPRCURSOR_SIZE,24"
        "HYPRCURSOR_THEME,catppuccin-${ctp-opt.flavor}-light-cursors"

        "CLIPHIST_MAX_ITEMS,25"

        "GTK_APPLICATION_PREFER_DARK_THEME,1"
        "GTK_THEME,Adwaita:dark"
        "QT_QPA_PLATFORMTHEME,kvantum"
      ];

      general = {
        gaps_in = rice.gap.inner;
        gaps_out = rice.gap.outer;
        border_size = rice.borders.size;
        resize_on_border = true;
        allow_tearing = false;
        layout = "dwindle";

        "col.active_border" = if rice.borders.colored then "$accent" else "$overlay0";
        "col.inactive_border" = if rice.borders.colored then "$overlay2" else "$crust";
      };

      dwindle = {
        preserve_split = true;
        pseudotile = true;
      };

      decoration = {
        rounding = rice.borders.rounded;
        rounding_power = 2;
        active_opacity = 1.0;
        inactive_opacity = 0.9;

        shadow = {
          enabled = true;
          range = 6;
          render_power = 3;
          color_inactive = "rgba($crustAlpha99)";
          color = "rgba($crustAlphaee)";
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
        #first_launch_animation = false;

        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "quick,0.15,0,0.1,1"
          "overshot,0.05,0.9,0.1,1.1"
          "instant,0,0,1,1"
        ];

        animation = [
          "global, 1, 10, default"
          "fade, 1, 3, quick"
          "border, 1, 10, quick"
          "layers, 1, 5, easeOutQuint, slidevert"
          "windows, 1, 5, easeOutQuint, popin 87%"
          "workspaces, 1, 5, easeOutQuint, slidefade 20%"
          "specialWorkspace, 1, 5, easeOutQuint, slidefadevert ${if rice.bar.top then "" else "-"}20%"
          "zoomFactor, 1, 1, instant"
        ];
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        focus_on_activate = true;
        middle_click_paste = false;
        exit_window_retains_fullscreen = true;
        new_window_takes_over_fullscreen = 1;
        background_color = "$base";
        vfr = true;
      };

      input = {
        kb_layout = "us";
        kb_options = "caps:none";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad = {
          natural_scroll = true;
          middle_button_emulation = 0;
        };
      };

      layerrule = [
        "noanim, selection" # hyprshot overlay
        "animation fade, swww-daemon"
        "animation fade, logout_dialog"
        "abovelock false, waybar"
        "abovelock true, notifications"
        "abovelock true, selection"
        "abovelock true, logout_dialog"
      ];

      windowrulev2 = [
        "suppressevent maximize, class:.*"
        "suppressevent minimize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"

        "stayfocused,title:^(Hyprland Polkit Agent|Unlock Login Keyring|KeePassXC -.*)$,"
        "suppressevent fullscreen maximize,title:^(Hyprland Polkit Agent|Unlock Login Keyring|KeePassXC -.*)$,"
        "dimaround,title:^(Hyprland Polkit Agent|Unlock Login Keyring|KeePassXC -.*)$,"
        "float,title:^(Hyprland Polkit Agent|Unlock Login Keyring|KeePassXC -.*)$,"

        "float,title:^(Open|Print|Save|Rename|Move|Copy|Confirm).*,"
        "float,title:^(Preferences|Settings|Options|About|Passbolt).*,"
        "float,title:^(MainPicker|Volume Control|File Operation Progress|Network Connections|Choose an Application| )$,"

        "keepaspectratio on, title:^(Picture in picture)$"
        "pin, title:^(Picture in picture)$"
      ];
    };
  };
}
