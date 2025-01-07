{pkgs, config, ...}:
{
  programs.hyprlock = {
    enable = config.wayland.windowManager.hyprland.enable;
    settings = {
      general = {
        hide_cursor = true;
      };
      background = {
        path = "screenshot";
        blur_passes = 3;
        blur_size = 5;
      };
      input-field = [
        {
          monitor = "${config.monitors.primary}";
          size = "500, 50";
          fail_text = "$FAIL ($ATTEMPTS)";
          placeholder_text = "Password: ";
          fade_on_empty = false;
          hide_input = false;
          outline_thickness = "5";

          position = "0, -60";
          halign = "center";
          valign = "center";
        }
      ];
      label = [
        {
          monitor = "${config.monitors.primary}";
          text = "$TIME";
          font_family = "${config.fonts.name}";
          font_size = "${toString (config.fonts.size + 25)}";

          shadow_passes = "2";

          position = "0, 100";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}