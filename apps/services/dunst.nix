{ config, lib, sharedSettings, ... }:
let
    main_monitor = builtins.head (lib.filter (output: output.name == config.monitors.primary) config.monitors.outputs);
    variant = sharedSettings.colors.variant;
in
{
    services.dunst = {
        enable = true;
        settings = {
            global = {
                alignment = "center";
                always_run_script = true;
                browser = "${config.programs.firefox.package}/bin/firefox --private-window";
                class = "Dunst";
                corner_radius = config.desktop.corner-radius;
                ellipsize = "middle";
                font = "${config.fonts.name} ${toString config.fonts.size}";
                format = "<b>%s</b>\\n%b";
                frame_color = sharedSettings.colors.main;
                frame_width = 2;
                height = "(0, ${toString (builtins.floor (main_monitor.height / 3))})";
                hide_duplicate_count = false;
                history_length = 7;
                horizontal_padding = 8;
                icon_path = "/usr/share/icons/gnome/16x16/status/:/usr/share/icons/gnome/16x16/devices/";
                icon_position = "left";
                idle_threshold = 0;
                ignore_newline = false;
                indicate_hidden = true;
                line_height = 0;
                markup = "full";
                max_icon_size = 64;
                monitor = main_monitor.name;
                mouse_left_click = "close_current";
                mouse_middle_click = "do_action";
                mouse_right_click = "close_all";
                origin = "top-right";
                padding = 8;
                separator_color = "frame";
                separator_height = 2;
                shrink = false;
                show_age_threshold = -1;
                show_indicators = false;
                sort = "urgency_descending";
                stack_duplicates = true;
                sticky_history = false;
                title = "Dunst";
                transparency = 0;
                width = "(${toString (builtins.floor (main_monitor.width / 6))}, ${toString (builtins.floor (main_monitor.width / 4))})";
                word_wrap = true;
            };
            urgency_critical = {
                background = sharedSettings.colors."${variant}".red;
                foreground = sharedSettings.colors."${variant}".base;
                frame_color = sharedSettings.colors.main;
                timeout = 0;
            };
            urgency_low = {
                background = sharedSettings.colors."${variant}".base;
                foreground = sharedSettings.colors."${variant}".text;
                timeout = 20;
            };
            urgency_normal = {
                background = sharedSettings.colors."${variant}".base;
                foreground = sharedSettings.colors.main;
                timeout = 30;
            };
        };
    };
}
