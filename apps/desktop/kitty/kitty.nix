{ config, ... }:
{
    programs.kitty = {
        enable = !config.disable.kitty;
        font = {
            name = "${config.fonts.name}";
            size = 11;
        };
        settings = {
            background = "#000000";
            background_opacity = "0.8";
            click_interval = "1.0";
            close_on_child_death = "yes";
            cursor_blink_interval = 0;
            cursor_shape = "block";
            default_pointer_shape = "arrow";
            detect_urls = true;
            enable_audio_bell = false;
            foreground = "#f0f0f0";
            input_delay = 5;
            mouse_hide_wait = 0;
            pointer_shape_when_dragging = "beam";
            pointer_shape_when_grabbed = "hand";
            scrollback_lines = 5000;
            select_by_word_characters = "@/-_.";
            sync_to_monitor = "yes";
            term = "xterm-256color";
            update_check_interval = 0;
            url_prefixes = "http https";
            visual_bell_duration = "0.0";
            window_alert_on_bell = "no";
            window_logo_alpha = "0.2";
            window_logo_path = "Espeon_Umbreon.png";
            window_logo_position = "bottom-right";
        };
    };
    xdg = {
        configFile = {
            "kitty/Espeon_Umbreon.png" = {
                source = ./Espeon_Umbreon.png;
            };
        };
    };
}
