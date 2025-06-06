{ pkgs, ... }: {
  boot.plymouth.enable = false;
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
      audio.enable = true;
      defaultWindowManager = "${pkgs.gnome-session}/bin/gnome-session";
    };
    udev.extraRules = ''
      SUBSYSTEM=="cpu", ACTION=="add", TEST=="online", ATTR{online}=="0", ATTR{online}="1"
    ''; # CPU hotplug
    qemuGuest.enable = true;
    openssh.settings.PermitRootLogin = "yes";
  };
  # environment.systemPackages = with pkgs; [];
}
