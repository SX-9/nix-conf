{ pkgs, ... }: {
  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };
  services = {
    xrdp = {
      enable = true;
      defaultWindowManager = "${pkgs.gnome-session}/bin/gnome-session";
    };
    openssh.settings.PermitRootLogin = "yes";
    qemuGuest.enable = true;
  };
  # environment.systemPackages = with pkgs; [];
}
