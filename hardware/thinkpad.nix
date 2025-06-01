# CUSTOM CONFIG FOR THINKPADS ONLY

{ pkgs, ... }: {
  boot = {
    kernelPackages = pkgs.linuxPackages;
    kernel.sysctl."vm.laptop_mode" = 5;
    initrd.availableKernelModules = [ "thinkpad_acpi" ];
  };
  environment = {
    systemPackages = [ pkgs.zcfan ]; # thinkfan replacement for now
    etc."zcfan.conf" = {
      mode = "0644";
      text = ''
        max_temp 80
        max_level 7

        med_temp 70
        med_level 4

        low_temp 60
        low_level 1

        temp_hysteresis 10
      '';
    };
  };
  systemd.services.zcfan = {
    enable = true;
    description = "ZCFan - ThinkPad Fan Control";
    wantedBy = [ "multi-user.target" ];
    preStart = "
      /run/current-system/sw/bin/modprobe -rv thinkpad_acpi && /run/current-system/sw/bin/modprobe -v thinkpad_acpi fan_control=1 experimental=1
    ";
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.zcfan}/bin/zcfan";
      Restart = "always";
      RestartSec = "5s";
    };
  };
  services = {
    power-profiles-daemon.enable = true;
    fwupd.enable = true;
    thermald.enable = true;
    logind.extraConfig = "HandlePowerKey=ignore";
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
      enable = false; # https://github.com/NixOS/nixpkgs/issues/395739
      levels = [
        [ "level auto"       0  70  ]
        [ "level full-speed" 70 80  ]
        [ "level disengaged" 80 150 ]
      ];
      sensors = [
        { type = "hwmon"; query = "/sys/devices/platform/coretemp.0/hwmon"; }
      ];
    };
  };
}
