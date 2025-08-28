{ hostname, ... }: {
  services.fusuma.settings = {
    swipe = {
      "4".down.sendkey = "LEFTMETA+L";
      "4".up.sendkey = "LEFTMETA+M";
      "3".up.sendkey = "LEFTMETA+W";
      "3".down.sendkey = "LEFTMETA+DOWN";
    };
    hold = {
      "3".sendkey = "LEFTMETA+SPACE";
      "4".sendkey = "LEFTMETA+C";
    };
  };
  wayland.windowManager.hyprland = {
    settings = {
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
        "SUPER, mouse:274, killactive"
      ];

      bindl = [
        ", switch:on:Lid Switch, exec, systemctl suspend"
        ", PRINT, exec, hyprshot -m region -o ~/Pictures/Screenshots"
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
        "SUPER, M, exec, wlogout"

        "SUPER, J, exec, notify-send -u critical ${hostname} 'Caffein Mode' && notify-send '(SUPER+X to reset)' && systemctl --user stop hypridle"
        "SUPER, K, exec, notify-send -u critical ${hostname} 'Focus Mode' && notify-send '(SUPER+X to reset)' && systemctl --user stop swww waybar && hyprctl --batch 'keyword decoration:inactive_opacity 1.0; keyword decoration:blur:enabled 0; keyword general:gaps_in 0; keyword general:gaps_out 0; keyword general:border_size 1; keyword decoration:rounding 0; keyword decoration:shadow:enabled false'"
        "SUPER, B, submap, disabled-all-keybinds"
        "SUPER, H, exec, notify-send ${hostname} 'Animations Off' && hyprctl keyword animations:enabled 0"
        "SUPER, X, exec, dunstctl close-all && hyprctl reload && hyprctl dispatch submap reset && systemctl --user restart swww waybar hypridle"
        "SUPER, Z, exec, dunstctl close-all"

        "SUPER SHIFT, S, exec, hyprshot -m region -o ~/Pictures/Screenshots"
        "ALT, PRINT, exec, hyprshot -m output -o ~/Pictures/Screenshots"

        "SUPER, R, exec, rofi -show drun -show-icons -display-drun ''"
        "SUPER, V, exec, rofi -modi clipboard:cliphist-rofi-img -show clipboard -show-icons"
        # "SUPER, B, exec, rofi -show calc -modi calc -no-show-match -no-sort"

        "SUPER, A, exec, code"
        "SUPER, T, exec, kitty"
        "SUPER, E, exec, thunar ~" # kitty ranger ~"
        "SUPER, C, exec, [float; size 75%] kitty btop"
        "SUPER, Y, exec, brave"
        "SUPER, D, exec, steam steam://open/bigpicture"

        "SUPER, Q, killactive,"
        "SUPER, W, fullscreen, 1"
        "SUPER, S, fullscreen, 0"
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

      submap = disabled-all-keybinds
      bind = , ESC, submap, reset

      submap = reset
    ''; # https://github.com/nix-community/home-manager/issues/6062
  };
}