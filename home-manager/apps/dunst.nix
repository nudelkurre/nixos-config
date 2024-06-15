{config, ...}:
{
    services.dunst = {
        enable = true;
        settings = {
            global = {
                monitor = 0;
                width = 300;
                height = 300;
                indicate_hidden = "yes";
                shrink = "no";
                transparency = 0;
                separator_height = 2;
                padding = 8;
                horizontal_padding = 8;
                frame_width = 1;
                frame_color = "#000000";
                separator_color = "frame";
                sort = "yes";
                idle_threshold = 0;
                font = "${config.fonts.name} ${toString config.fonts.size}";
                line_height = 0;
                markup = "full";
                format = "<b>%s</b>\\n%b";
                alignment = "center";
                show_age_threshold = -1;
                word_wrap = "yes";
                ellipsize = "middle";
                ignore_newline = "no";
                stack_duplicates = "true";
                hide_duplicate_count = "false";
                show_indicators = "no";
                icon_position = "left";
                max_icon_size = 32;
                icon_path = "/usr/share/icons/gnome/16x16/status/:/usr/share/icons/gnome/16x16/devices/";
                sticky_history = "no";
                history_length = 20;
                browser = "/usr/bin/firefox --private-window";
                always_run_script = "true";
                title = "Dunst";
                class = "Dunst";
                corner_radius = 15;
                mouse_left_click = "close_current";
                mouse_middle_click = "do_action";
                mouse_right_click = "close_all";
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
            urgency_critical = {
                background = "#900000";
                foreground = "#ffffff";
                frame_color = "#ff0000";
                timeout = 0;
            };
        };
    };
}