# (mostly) Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ ... }: {
  dconf.settings = {

    "org/gnome/mutter" = {
      center-new-windows = true;
      dynamic-workspaces = true;
      edge-tiling = true;
    };

    "org/gnome/desktop/interface" = {
      clock-format = "12h";
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
      gtk-enable-primary-paste = false;
      show-battery-percentage = true;
      toolkit-accessibility = false;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      natural-scroll = true;
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/peripherals/mouse" = {
      natural-scroll = false;
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = ":minimize,maximize,close";
    };

    "org/gnome/desktop/wm/keybindings" = {
      panel-run-dialog = ["<Super>r"];
      switch-applications = ["<Alt>Tab"];
      switch-applications-backward = ["<Shift><Alt>Tab"];
      switch-to-workspace-1 = [];
      switch-to-workspace-last = [];
      switch-to-workspace-left = ["<Control><Super>Left"];
      switch-to-workspace-right = ["<Control><Super>Right"];
    };
    
    "org/gnome/shell/keybindings" = {
      show-screenshot-ui = ["<Shift><Super>s"];
      toggle-message-tray = [];
    };

    "org/gnome/shell/app-switcher" = {
      current-workspace-only = true;
    };

    "org/gnome/shell/extensions/clipboard-history" = {
      toggle-menu = [ "<Super>v" ];
    };

    "org/gnome/shell/extensions/dash-to-panel" = {
      animate-appicon-hover = true;
      animate-appicon-hover-animation-type = "SIMPLE";
      appicon-margin = 0;
      appicon-padding = 6;
      appicon-style = "NORMAL";
      available-monitors = [ 0 ];
      dot-position = "BOTTOM";
      dot-style-unfocused = "DASHES";
      hotkeys-overlay-combo = "TEMPORARILY";
      intellihide = false;
      isolate-monitors = true;
      isolate-workspaces = true;
      leftbox-padding = -1;
      overview-click-to-exit = true;
      panel-anchors = ''
        {"0":"MIDDLE"}
      '';
      panel-element-positions = ''
        {"0":[{"element":"showAppsButton","visible":true,"position":"stackedTL"},{"element":"activitiesButton","visible":false,"position":"stackedTL"},{"element":"leftBox","visible":false,"position":"stackedTL"},{"element":"taskbar","visible":true,"position":"stackedTL"},{"element":"centerBox","visible":false,"position":"stackedBR"},{"element":"rightBox","visible":true,"position":"stackedBR"},{"element":"systemMenu","visible":true,"position":"stackedBR"},{"element":"dateMenu","visible":true,"position":"stackedBR"},{"element":"desktopButton","visible":false,"position":"stackedBR"}]}
      '';
      panel-lengths = ''
        {"0":100}
      '';
      panel-positions = ''
        {"0":"BOTTOM"}
      '';
      panel-sizes = ''
        {"0":48}
      '';
      primary-monitor = 0;
      status-icon-padding = -1;
      taskbar-locked = true;
      trans-dynamic-anim-target = 1.0;
      trans-dynamic-behavior = "MAXIMIZED_WINDOWS";
      trans-panel-opacity = 0.7000000000000001;
      trans-use-custom-opacity = true;
      trans-use-dynamic-opacity = true;
      tray-padding = -1;
      window-preview-title-position = "TOP";
    };

    "org/gnome/shell/extensions/freon" = {
      hot-sensors = [ "__average__" ];
    };

    "org/gnome/shell/extensions/net/gfxmonk/impatience" = {
      speed-factor = 0.0;
    };

    "org/gnome/shell/extensions/order-icons" = {
      order-icons-center = [];
      order-icons-left = [];
      order-icons-right = [ "system-monitor@gnome-shell-extensions.gcampax.github.com" "tailscale" "keyboard" "a11y" "dwellClick" "screenSharing" "screenRecording" ];
    };

    "org/gnome/shell/extensions/status-area-horizontal-spacing" = {
      hpadding = 0;
    };

  };
}
