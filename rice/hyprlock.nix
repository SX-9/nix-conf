{ rice, username, hostname, ... }: {
  programs.hyprlock = {
    enable = true;
    settings = {

      general = {
        ignore_empty_input = true;
        hide_cursor = false;
      };

      animation = {
        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "quick,0.15,0,0.1,1"
          "overshot,0.05,0.9,0.1,1.1"
        ];

        animation = [
          "fade, 1, 3.5, easeOutQuint"
        ];
      };

      background = [
        {
          path = "screenshot";
          brightness = 0.25;
          blur_passes = 3;
          blur_size = 1;
        }
      ];

      label = [
        {
          text = "$TIME12";
          color = "$text";
          font_size = 64;
          position = "0, 32";
          shadow_passes = 1;
          shadow_boost = 0.5;
          halign = "center";
          valign = "center";
        }
        {
          text = "<span foreground=\"##$accentAlpha\">${username}</span>@${hostname}";
          color = "$subtext0";
          font_size = 16;
          position = "0, -32";
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
          outline_thickness = rice.borders.size;
          shadow_passes = 8;
          rounding = rice.borders.rounded;

          outer_color = if rice.borders.colored then "$accent" else "$overlay0";
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