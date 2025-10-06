{ pkgs, lib, resume-dev, ... }: {
  time.timeZone = lib.mkForce null;
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave";
    powertop.enable = true;
  };
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
        vaapiVdpau
        libvdpau-va-gl 
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
    logind.settings.Login.HandlePowerKey = "ignore"; # classmates keep pressing power button while im working :<
    power-profiles-daemon.enable = false;
    automatic-timezoned.enable = false;
    thermald.enable = true;
    fwupd.enable = true;
    udev.extraRules = ''
      #ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", ATTR{power/control}="auto"
      ACTION=="add", SUBSYSTEM=="pci", TEST=="power/control", ATTR{power/control}="auto"
    '';
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
        START_CHARGE_THRESH_BAT0 = "80";
        START_CHARGE_THRESH_BAT1 = "80";
        STOP_CHARGE_THRESH_BAT0 = "85";
        STOP_CHARGE_THRESH_BAT1 = "85";
        CPU_BOOST_ON_AC = "1";
        CPU_BOOST_ON_BAT = "0";
        CPU_HWP_DYN_BOOST_ON_AC = "1";
        CPU_HWP_DYN_BOOST_ON_BAT = "0";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        TLP_DEFAULT_MODE = "BAT";
        PLATFORM_PROFILE_ON_AC = "performance";
        PLATFORM_PROFILE_ON_BAT = "low-power";
        WIFI_PWR_ON_AC = "on";
        WIFI_PWR_ON_BAT = "on";
        CPU_MAX_PERF_ON_AC = "100";
        CPU_MAX_PERF_ON_BAT = "100";
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
