{ lib, pkgs, ... }: {
  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };
  services = {
    xrdp = {
      enable = true;
      defaultWindowManager = "${pkgs.kdePackages.plasma-workspace}/bin/startplasma-x11";
    };
    xserver = {
      desktopManager.gnome.enable = lib.mkForce false;
      displayManager.gdm.enable = lib.mkForce false;  
    };
    desktopManager.plasma6.enable = true;
    openssh.settings.PermitRootLogin = "yes";
  };
  environment.systemPackages = with pkgs; [
    kdePackages.plasma-workspace
  ];
}
