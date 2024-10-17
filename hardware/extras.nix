# CUSTOM CONFIG FOR THINKPADS ONLY

{ pkgs, ... }: {
  boot = {
    kernelPackages = pkgs.linuxPackages_testing;
    initrd.availableKernelModules = [ "thinkpad_acpi" ];
  };
  systemd.services.thinkfan.preStart = "
    /run/current-system/sw/bin/modprobe -r thinkpad_acpi && /run/current-system/sw/bin/modprobe thinkpad_acpi
  ";
  services.thinkfan = {
    enable = true;
    levels = [
      [ "level auto"       0  79  ]
      [ "level full-speed" 80 89  ]
      [ "level disengaged" 90 150 ]
    ];
  };
}