{ pkgs, lib, resume-dev, ... }: {
  time.timeZone = lib.mkForce null;
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };
  security.protectKernelImage = false; # https://discourse.nixos.org/t/hibernate-doesnt-work-anymore/24673/7
  hardware = {
    enableRedistributableFirmware = true; # T480 WiFi firmware fix
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-compute-runtime
        libva-vdpau-driver
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
    logind.settings.Login = {
      HandleLidSwitch = "suspend";
      HandlePowerKey = "ignore";
    };
    fstrim.enable = true;
    thermald.enable = true;
    throttled.enable = true;
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
    auto-cpufreq = {
      enable = true;
      settings = {
        charger = {
          governor = "performance";
          energy_performance_preference = "balance_performance";
          turbo = "auto";
        };
        battery = {
          governor = "powersave";
          energy_performance_preference = "balance_power";
          turbo = "never";
          enable_thresholds = "true";
          start_threshold = "80";
          stop_threshold = "85";
        };
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
