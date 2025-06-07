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
          brightness = 0.2;
          blur_passes = 5;
          blur_size = 1;
        }
      ];
      label = [
        {
          text = "cmd[update:60000] echo \"<span>$(date +\"%I:%M %p\")</span>\"";
          color = "$text";
          font_size = 70;
          position = "0, 30";
          shadow_passes = 1;
          shadow_boost = 0.5;
          halign = "center";
          valign = "center";
        }
        {
          text = "󰌾 Howdy, <span foreground=\"##$accentAlpha\">$USER</span>!";
          color = "$subtext0";
          font_size = 15;
          position = "0, -30";
          shadow_passes = 1;
          shadow_boost = 0.5;
          halign = "center";
          valign = "center";
        }
      ];
      input-field = [
        {
          size = "200, 50";
          position = "0, 10";
          valign = "bottom";
          halign = "center";

          dots_center = true;
          fade_on_empty = false;
          outline_thickness = 2;
          shadow_passes = 8;
          rounding = 10;

          outer_color = "$accent";
          inner_color = "$crust";
          font_color = "$text";
          placeholder_text = "Type your password";
          
          capslock_color = "$yellow";
          check_color = "$green";
          fail_color = "$red";
          fail_text = " $FAIL ($ATTEMPTS)";
        }
      ];
    };
  };
}