{ ... }: {
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        ignore_empty_input = true;
        hide_cursor = true;
      };
      background = [
        {
          path = "screenshot";
          brightness = 0.5;
          blur_passes = 3;
          blur_size = 2;
        }
      ];
      label = [
        {
          text = "cmd[update:60000] echo \"<span>$(date +\"%I:%M %p\")</span>\"";
          color = "$text";
          font_size = 75;
          position = "0, 15";
          shadow_passes = 1;
          shadow_boost = 0.5;
          halign = "center";
          valign = "center";
        }
      ];
      input-field = [
        {
          size = "200, 50";
          position = "0, 30";
          valign = "bottom";
          halign = "center";

          dots_center = true;
          fade_on_empty = false;
          outline_thickness = 2;
          shadow_passes = 8;
          rounding = 10;

          outer_color = "$accent";
          inner_color = "$surface0";
          font_color = "$text";
          placeholder_text = "󰌾 Welcome back <span foreground=\"##$accentAlpha\">$USER</span>!";
          
          capslock_color = "$yellow";
          check_color = "$green";
          fail_color = "$red";
          fail_text = " $FAIL ($ATTEMPTS)";
        }
      ];
    };
  };
}