{ sharedSettings, ... }:
let
    main-color = builtins.replaceStrings ["#"] [""] sharedSettings.colors.main;
    secondary-color = builtins.replaceStrings ["#"] [""] sharedSettings.colors.secondary;
in
{
    programs.mangohud = {
        enable = true;
        settings = {
            time = true;
            fps = true;
            frametime = false;
            cpu_temp = true;
            cpu_mhz = true;
            cpu_power = true;
            gpu_stats = true;
            gpu_temp = true;
            gpu_power = true;
            gpu_name = true;
            gpu_list = 1; # Set to only use the igpu to fix no temp showing on cpu and not make gpu stutter
            throttling_status = false;
            vram = true;
            ram = true;
            swap = true;
            gamemode = true;
            engine_short_names = true;

            fps_limit = "60,30,0";
            show_fps_limit = true;
            font_size = "20";
            background_color = "000000";
            background_alpha = "0.3";
            gpu_color = "${main-color}";
            cpu_color = "${main-color}";
            ram_color = "${main-color}";
            vram_color = "${main-color}";
            frametime_color = "${main-color}";
            engine_color = "${main-color}";
            text_color = "${main-color}";
            horizontal_separator_color = secondary-color;

            # Disable settings
            frame_timing = 0;
            horizontal = true;
            horizontal_stretch = false;

            mangoapp_steam = true;

            time_format = "%H:%M %Z";
        };
    };
}
