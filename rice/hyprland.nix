{ inputs, pkgs, rice, flake-path, ctp-opt, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hl.packages."${pkgs.system}".hyprland;
    xwayland.enable = true;
    # plugins = with inputs.hlp.packages."${pkgs.system}"; [];
    settings = {
      monitor = ",preferred,auto,1.2";

      exec-once = [
        # "hyprctl setcursor catppuccin-mocha-light-cursors 24"
        "gsettings set org.gnome.desktop.interface gtk-theme \"YOUR_DARK_GTK3_THEME\""
        "gsettings set org.gnome.desktop.interface color-scheme \"prefer-dark\""
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"

        # "nm-applet &"
        "tailscale-systray &"
	      "rofi -show drun -show-icons -display-drun ''"
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
        gaps_in = 5;
        gaps_out = "10,10,10,10";
        border_size = rice.borders.size;
        resize_on_border = true;
        allow_tearing = false;
        layout = "dwindle";

        "col.active_border" = if rice.borders.colored then "$accent" else "$crust";
        "col.inactive_border" = if rice.borders.colored then "$overlay2" else "$crust";
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
        first_launch_animation = true;

        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "quick,0.15,0,0.1,1"
          "overshot,0.05,0.9,0.1,1.1"
        ];

        animation = [
          "global, 1, 10, default"
          "fade, 1, 3.03, quick"
          "border, 1, 10, quick"
          "layers, 1, 3.81, easeOutQuint, slidevert"
          "windows, 1, 4.79, easeOutQuint, popin 87%"
          "workspaces, 1, 5, easeOutQuint, slidefade 20%"
          "specialWorkspace, 1, 5, easeOutQuint, slidefadevert 20%"
        ];
      };

      dwindle.preserve_split = true;
      master.new_status = "master";
      gestures.workspace_swipe = true;

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        focus_on_activate = true;
        middle_click_paste = true;
        exit_window_retains_fullscreen = true;
        new_window_takes_over_fullscreen = 1;
        background_color = "$base";
        vfr = true;
      };

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad.natural_scroll = true;
      };

      layerrule = [
        "noanim, selection" # hyprshot overlay
        "animation fade, swww-daemon"
        "abovelock false, notifications"
        "abovelock false, waybar"
      ];

      windowrulev2 = [
        "suppressevent maximize, class:.*"
        "suppressevent minimize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"

        "float,title:^(Open|Print|Save|Rename).*,"
        "float,title:^(Preferences|Settings|Options|About).*,"
        "float,title:^(MainPicker|Volume Control|File Operation Progress)$,"

        "keepaspectratio on, title:^(Picture in picture)$"
        "pin, title:^(Picture in picture)$"
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
        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"

        "SUPER, right, workspace, e+1"
        "SUPER, left, workspace, e-1"
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
      ];

      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
        "SUPER SHIFT, mouse:273, resizewindow"
      ];

      bindl = [
        ", switch:on:Lid Switch, exec, loginctl lock-session & systemctl suspend"
        "SUPER, SPACE, exec, playerctl play-pause"
      ];

      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];
      
      bind = [
        "SUPER, N, exec, rofi-network-manager"
        "SUPER, M, exec, rofi -show power-menu -modi power-menu:rofi-power-menu"

        "SUPER, J, exec, notify-send -u critical Hyprland 'Caffein Mode' && notify-send '(SUPER+X to reset)' && systemctl --user stop hypridle"
        "SUPER, K, exec, notify-send -u critical Hyprland 'Focus Mode' && notify-send '(SUPER+X to reset)' && systemctl --user stop swww waybar && hyprctl --batch 'keyword decoration:inactive_opacity 1.0; keyword decoration:blur:enabled 0; keyword general:gaps_in 0; keyword general:gaps_out 0; keyword general:border_size 1; keyword decoration:rounding 0; keyword decoration:shadow:enabled false'"
        "SUPER, H, exec, notify-send Hyprland 'Animations Off' && hyprctl keyword animations:enabled 0"
        "SUPER, X, exec, dunstctl close-all && systemctl --user restart swww waybar hypridle && hyprctl reload"

        ", PRINT, exec, hyprshot -m region -o ~/Pictures/Screenshots"
        "SUPER SHIFT, S, exec, hyprshot -m region -o ~/Pictures/Screenshots"
        "SUPER, R, exec, rofi -show drun -show-icons -display-drun ''"
        "SUPER, V, exec, rofi -modi clipboard:cliphist-rofi-img -show clipboard -show-icons"
        # "SUPER, B, exec, rofi -show calc -modi calc -no-show-match -no-sort"

        "SUPER, A, exec, code ${flake-path}"
        "SUPER, T, exec, kitty"
        "SUPER, E, exec, thunar ~" # kitty ranger ~"
        "SUPER, C, exec, kitty btop"
        "SUPER, Y, exec, google-chrome-stable"

        "SUPER, Q, killactive,"
        "SUPER, W, fullscreen, 1"
        "SUPER, S, fullscreen, 0"
        "SUPER, D, pin"
        "SUPER, F, togglefloating,"
        "SUPER, G, togglesplit,"
        "SUPER, L, exec, loginctl lock-session"
        
        "SUPER, down, togglespecialworkspace, hidden"
        "SUPER SHIFT, down, movetoworkspace, special:hidden"
        "SUPER SHIFT, up, movetoworkspace, +0"

        "SUPER, P, submap, move"
        "SUPER, O, submap, resize"
        "SUPER, I, submap, focus"
        "SUPER, U, submap, swap"
      ];
    };
    extraConfig = ''
      submap = move
      binde = , right, movewindow, r
      binde = , left, movewindow, l
      binde = , up, movewindow, u
      binde = , down, movewindow, d
      bind = , catchall, submap, reset

      submap = resize
      binde = , right, resizeactive, 10 0
      binde = , left, resizeactive, -10 0
      binde = , up, resizeactive, 0 -10
      binde = , down, resizeactive, 0 10
      bind = , catchall, submap, reset

      submap = swap
      bind = , right, swapwindow, r
      bind = , left, swapwindow, l
      bind = , up, swapwindow, u
      bind = , down, swapwindow, d
      bind = , catchall, submap, reset

      submap = focus
      bind = , right, movefocus, r
      bind = , left, movefocus, l
      bind = , up, movefocus, u
      bind = , down, movefocus, d
      bind = , catchall, submap, reset

      submap = reset
    ''; # https://github.com/nix-community/home-manager/issues/6062
  };
}
