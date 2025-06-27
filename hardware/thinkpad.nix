# CUSTOM CONFIG FOR THINKPADS ONLY

{ pkgs, ... }: {
  hardware = {
    enableRedistributableFirmware = true; # T480 WiFi firmware fix
    graphics.extraPackages = with pkgs; [ vaapiIntel intel-media-driver intel-ocl ];
  };
  boot = {
    kernelPackages = pkgs.linuxPackages;
    kernel.sysctl."vm.laptop_mode" = 5;
    initrd.availableKernelModules = [ "thinkpad_acpi" ];
  };
  services = {
    logind.extraConfig = "HandlePowerKey=ignore"; # classmates keep pressing power button while im working :<
    power-profiles-daemon.enable = false;
    fwupd.enable = true;
    thermald.enable = true;
    tlp = {
      enable = true;
      settings = { # BAT1 = external battery, BAT0 = internal battery
        STOP_CHARGE_THRESH_BAT0 = "85";
        START_CHARGE_THRESH_BAT0 = "80";
        STOP_CHARGE_THRESH_BAT1 = "85";
        START_CHARGE_THRESH_BAT1 = "80";
        CPU_BOOST_ON_AC = "1";
        TLP_DEFAULT_MODE = "BAT";
        PLATFORM_PROFILE_ON_AC = "performance";
        PLATFORM_PROFILE_ON_BAT = "low-power";
      };
    };
    thinkfan = {
      enable = true;
      levels = [
        [ "level auto"       0  60  ]
        [ "level full-speed" 60 70  ]
        [ "level disengaged" 70 150 ]
      ];
      # sensors = [
      #   { type = "hwmon"; query = "/sys/devices/platform/coretemp.0/hwmon"; }
      # ];
    };
  };
}
