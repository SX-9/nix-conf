{ ... }: {
  imports = [
    ./dconf.nix
  ];

  dconf.settings = {

    "org/gnome/settings-daemon/plugins/power" = {
      idle-dim = true;
      power-button-action = "nothing";
      power-saver-profile-on-low-battery = true;
    };
    
  };
}