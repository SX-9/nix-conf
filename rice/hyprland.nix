{ inputs, pkgs, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hl.packages."${pkgs.system}".hyprland;
    xwayland.enable = true;
    plugins = with inputs.hlp.packages."${pkgs.system}"; [
      hyprexpo
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
	      "rofi -show drun"
      ];

      env = [
        "XCURSOR_SIZE,24"
        "XCURSOR_THEME,catppuccin-mocha-light-cursors"
        "HYPRCURSOR_SIZE,24"
        "HYPRCURSOR_THEME,catppuccin-mocha-light-cursors"

        "CLIPHIST_MAX_ITEMS,100"

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
        hyprexpo = {
          columns = 2;
          gap_size = 5;
          bg_col = "rgb(11111b)";
          workspace_method = "first current";

          enable_gesture = true;
          gesture_fingers = 3;
          gesture_distance = 300;
          gesture_positive = false;
        };
      };

      decoration = {
        rounding = 10;
        rounding_power = 2;
        active_opacity = 1.0;
        inactive_opacity = 0.9;

        shadow = {
          enabled = true;
          range = 8;
          render_power = 3;
          color = "rgba(1a1a1a99)";
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
        first_launch_animation = true;

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
        ", PRINT, exec, hyprshot -m region -o ~/Pictures/Screenshots"
        "SUPER SHIFT, S, exec, hyprshot -m region -o ~/Pictures/Screenshots"
        "SUPER, R, exec, rofi -show drun"
        "SUPER, M, exec, rofi -show power-menu -modi power-menu:rofi-power-menu"
        "SUPER, N, exec, rofi-network-manager"
        "SUPER, V, exec, rofi -modi clipboard:cliphist-rofi-img -show clipboard -show-icons"

        "SUPER, T, exec, kitty"
        "SUPER, Y, exec, kitty vim"
        "SUPER, E, exec, thunar ~" # kitty ranger ~"
        "SUPER, C, exec, kitty btop"
        "SUPER, L, exec, hyprlock"

        "SUPER, Q, killactive,"
        "SUPER, W, fullscreen, 1"
        "SUPER, S, fullscreen, 0"

        "SUPER, F, togglefloating,"
        "SUPER, G, togglesplit,"
        "SUPER CTRL, up, swapwindow, u"
        "SUPER CTRL, down, swapwindow, d"
        "SUPER CTRL, left, swapwindow, l"
        "SUPER CTRL, right, swapwindow, r"
        

        "SUPER, down, togglespecialworkspace, magic"
        "SUPER SHIFT, down, movetoworkspace, special:magic"

        "SUPER, SPACE, hyprexpo:expo, toggle"
      ];

      binde = [
        "ALT, TAB, cyclenext,"
        "ALT, TAB, bringactivetotop,"
        "ALT SHIFT, TAB, cyclenext, prev"
        "ALT SHIFT, TAB, bringactivetotop,"
        "SUPER, TAB, cyclenext,"
        "SUPER, TAB, bringactivetotop,"
        "SUPER SHIFT, TAB, cyclenext, prev"
        "SUPER SHIFT, TAB, bringactivetotop,"

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
}