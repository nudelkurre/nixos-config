{config, ...}:
{
    programs.kitty = {
        enable = true;
        font = {
            name = "${config.fonts.name}";
            size = 11;
        };
        settings = {
            scrollback_lines = 5000;
            enable_audio_bell = false;
            visual_bell_duration = "0.0";
            window_alert_on_bell = "no";
            mouse_hide_wait = 0;
            url_prefixes = "http https";
            detect_urls = true;
            select_by_word_characters = "@/-_.";
            click_interval = "1.0";
            pointer_shape_when_grabbed = "hand";
            default_pointer_shape = "arrow";
            pointer_shape_when_dragging = "beam";
            input_delay = 5;
            sync_to_monitor = "yes";
            close_on_child_death = "yes";
            update_check_interval = 0;
            cursor_shape = "block";
            cursor_blink_interval = 0;
            foreground = "#f0f0f0";
            background = "#000000";
            background_opacity = "0.8";

            term = "xterm-256color";

            window_logo_path = "Espeon_Umbreon.png";
            window_logo_position = "bottom-right";
            window_logo_alpha = "0.2";
        };
    };
    xdg.configFile."kitty/Espeon_Umbreon.png".source = ./Espeon_Umbreon.png;
}