{ lib, pkgs, ... }: {
  boot.plymouth.enable = lib.mkForce false;
  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };
  services = {
    sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };
    xrdp = {
      enable = true;
      audio.enable = true;
      defaultWindowManager = "${pkgs.gnome-session}/bin/gnome-session";
    };
    colord.enable = true; # fix for color glitch on chromium based apps
    udev.extraRules = ''
      SUBSYSTEM=="cpu", ACTION=="add", TEST=="online", ATTR{online}=="0", ATTR{online}="1"
    ''; # CPU hotplug
    qemuGuest.enable = true;
    openssh.settings.PermitRootLogin = "yes";
  };
  # environment.systemPackages = with pkgs; [];
}
