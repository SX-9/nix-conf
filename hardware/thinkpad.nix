{ pkgs, lib, resume-dev, ... }: {
  time.timeZone = lib.mkForce null;
  powerManagement.enable = true;
  security.protectKernelImage = false; # https://discourse.nixos.org/t/hibernate-doesnt-work-anymore/24673/7
  hardware = {
    enableRedistributableFirmware = true; # T480 WiFi firmware fix
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        vaapiIntel
        intel-media-driver
        intel-ocl 
        intel-compute-runtime
      ];
    };
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
    automatic-timezoned.enable = false;
    thermald.enable = true;
    fwupd.enable = true;
    tzupdate = {
      enable = true;
      timer.enable = true;
    };
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
        [ "level auto"        0  55  ]
        [ 3                  55  65  ]
        [ 7                  65  75  ]
        [ "level full-speed" 75  100 ]
      ];
      # sensors = [
      #   { type = "hwmon"; query = "/sys/devices/platform/coretemp.0/hwmon"; }
      # ];
    };
  };
}
