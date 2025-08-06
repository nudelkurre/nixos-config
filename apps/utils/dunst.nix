{config, ...}:
{
    services.dunst = {
        enable = ! config.disable.dunst;
        settings = {
            global = {
                alignment = "center";
                always_run_script = "true";
                browser = "/usr/bin/firefox --private-window";
                class = "Dunst";
                corner_radius = 15;
                ellipsize = "middle";
                font = "${config.fonts.name} ${toString config.fonts.size}";
                format = "<b>%s</b>\\n%b";
                frame_color = "#000000";
                frame_width = 1;
                height = "(0, 500)";
                hide_duplicate_count = "false";
                history_length = 20;
                horizontal_padding = 8;
                icon_path = "/usr/share/icons/gnome/16x16/status/:/usr/share/icons/gnome/16x16/devices/";
                icon_position = "left";
                idle_threshold = 0;
                ignore_newline = "no";
                indicate_hidden = "yes";
                line_height = 0;
                markup = "full";
                max_icon_size = 32;
                monitor = config.monitors.primary;
                mouse_left_click = "close_current";
                mouse_middle_click = "do_action";
                mouse_right_click = "close_all";
                origin = "top-right";
                padding = 8;
                separator_color = "frame";
                separator_height = 2;
                shrink = "no";
                show_age_threshold = -1;
                show_indicators = "no";
                sort = "yes";
                stack_duplicates = "true";
                sticky_history = "no";
                title = "Dunst";
                transparency = 0;
                width = 300;
                word_wrap = "yes";
            };
            urgency_critical = {
                background = "#900000";
                foreground = "#ffffff";
                frame_color = "#ff0000";
                timeout = 0;
            };
            urgency_low = {
                background = "#222222";
                foreground = "#888888";
                timeout = 20;
            };
            urgency_normal = {
                background = "#a0a0a0";
                foreground = "#000000";
                timeout = 20;
            };
        };
    };
}