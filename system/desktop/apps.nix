{ pkgs, ... }: {
  imports = [
    ../global/apps.nix
  ];
  environment.systemPackages = with pkgs; [
    gnomeExtensions.dash-to-panel
    gnomeExtensions.alphabetical-app-grid
    gnomeExtensions.gsconnect
    gnomeExtensions.impatience
    gnomeExtensions.status-area-horizontal-spacing
    gnomeExtensions.tailscale-status
    gnomeExtensions.clipboard-history
    gnomeExtensions.freon
    gnome-tweaks
    papirus-icon-theme
    (wrapOBS {
      plugins = with obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
      ];
    })
    
    libsForQt5.breeze-grub
    smartmontools
    lm_sensors
    ntfs3g
    dconf2nix
    hplipWithPlugin
    pciutils
    toybox
    gparted
    pavucontrol
    ventoy-bin-full
    jq
    cava
    ventoy-full

    android-tools
    distrobox
  ];
}
