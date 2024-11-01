# CUSTOM CONFIG FOR THINKPADS ONLY

{ pkgs, ... }: {
  boot = {
    kernelParams = [ "thinkpad_acpi.fan_control=1" ];
    kernelPackages = pkgs.linuxPackages_testing;
    initrd.availableKernelModules = [ "thinkpad_acpi" ];
    extraModprobeConfig = "options thinkpad_acpi experimental=1 fan_control=1";
  };
  systemd.services.thinkfan.preStart = "
    /run/current-system/sw/bin/modprobe -r thinkpad_acpi && /run/current-system/sw/bin/modprobe thinkpad_acpi
  ";
  services = {
    power-profiles-daemon.enable = true;
    fwupd.enable = true;
    thermald.enable = true;
    tlp = {
      enable = false;
      settings = {
        STOP_CHARGE_THRESH_BAT0 = "75";
        START_CHARGE_THRESH_BAT0 = "90";
        CPU_BOOST_ON_AC = "1";
        TLP_DEFAULT_MODE = "BAT";
        PLATFORM_PROFILE_ON_AC = "performance";
        PLATFORM_PROFILE_ON_BAT = "low-power";
      };
    };
    thinkfan = {
      enable = true;
      levels = [
        [ "level auto"       0  80  ]
        [ "level full-speed" 80 90  ]
        [ "level disengaged" 90 150 ]
      ];
      sensors = [
        { type = "hwmon"; query = "/sys/devices/platform/coretemp.0/hwmon"; }
      ];
    };
  };
}
