{ pkgs, lib, resume-dev, ... }: {
  time.timeZone = lib.mkForce null;
  powerManagement.enable = true;
  security.protectKernelImage = false; # https://discourse.nixos.org/t/hibernate-doesnt-work-anymore/24673/7
  hardware = {
    enableRedistributableFirmware = true; # T480 WiFi firmware fix
    graphics.extraPackages = with pkgs; [ vaapiIntel intel-media-driver intel-ocl ];
  };
  boot = {
    kernelParams = if resume-dev == "" then [] else ["resume=${resume-dev}"];
    resumeDevice = "${resume-dev}";

    kernelPackages = pkgs.linuxPackages;
    kernel.sysctl."vm.laptop_mode" = 5;
    initrd.availableKernelModules = [ "thinkpad_acpi" ];
  };
  services = {
    logind.powerKey = "ignore"; # classmates keep pressing power button while im working :<
    power-profiles-daemon.enable = false;
    automatic-timezoned.enable = true;
    thermald.enable = true;
    fwupd.enable = true;
    upower = {
      enable = true;
      percentageCritical = 15;
      percentageAction = 10;
      usePercentageForPolicy = true;
      allowRiskyCriticalPowerAction = true;
      criticalPowerAction = "HybridSleep";
    };
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
