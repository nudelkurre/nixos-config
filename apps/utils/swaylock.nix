{ config, ... }:
{
    programs.swaylock = {
        enable = config.wayland.windowManager.sway.enable;
        settings = {
            color = "000000";
            font = "${config.fonts.name}";
            font-size = "${toString config.fonts.size}";
        };
    };
}
