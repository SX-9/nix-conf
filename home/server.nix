{ ... }: {
  imports = [
    ./base.nix
  ];

  dconf.settings = {

    "org/gnome/shell" = {
      disable-user-extensions = false;
      disabled-extensions = ["window-list@gnome-shell-extensions.gcampax.github.com" "windowsNavigator@gnome-shell-extensions.gcampax.github.com" "workspace-indicator@gnome-shell-extensions.gcampax.github.com" "gsconnect@andyholmes.github.io" "drive-menu@gnome-shell-extensions.gcampax.github.com" "freon@UshakovVasilii_Github.yahoo.com" "dash-to-panel@jderose9.github.com" "screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com" "places-menu@gnome-shell-extensions.gcampax.github.com" "user-theme@gnome-shell-extensions.gcampax.github.com" "apps-menu@gnome-shell-extensions.gcampax.github.com"];
      enabled-extensions = ["tailscale-status@maxgallup.github.com" "impatience@gfxmonk.net" "order-extensions@wa4557.github.com" "AlphabeticalAppGrid@stuarthayhurst" "clipboard-history@alexsaveau.dev" "system-monitor@gnome-shell-extensions.gcampax.github.com" "top-bar-organizer@julian.gse.jsts.xyz" "status-area-horizontal-spacing@mathematical.coffee.gmail.com"];
      favorite-apps = ["org.gnome.Nautilus.desktop" "org.gnome.SystemMonitor.desktop" "org.gnome.Console.desktop" "google-chrome.desktop" "discord.desktop" "code.desktop"];
    };

    "org/gnome/shell/extensions/system-monitor" = {
      show-cpu = true;
      show-download = false;
      show-memory = true;
      show-swap = false;
      show-upload = false;
    };
    
  };
}
