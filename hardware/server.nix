{ pkgs, ... }: {
  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };
  services = {
    colord.enable = true; # fix for color glitch on chromium based apps
    xrdp = {
      enable = true;
      defaultWindowManager = "${pkgs.gnome-session}/bin/gnome-session";
    };
    openssh.settings.PermitRootLogin = "yes";
    qemuGuest.enable = true;
  };
  # environment.systemPackages = with pkgs; [];
}
