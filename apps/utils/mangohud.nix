{ config, ... }:
{
    programs.mangohud = {
        enable = !config.disable.mangohud;
        settings = {
            time = true;
            fps = true;
            frametime = false;
            cpu_temp = true;
            cpu_mhz = true;
            cpu_power = false;
            gpu_stats = false; # Causes stuttering in game if enabled
            gpu_temp = false;
            gpu_power = false;
            gpu_name = false;
            throttling_status = false;
            vram = false;
            ram = true;
            gamemode = true;

            fps_limit = "60,30,0";
            font_size = "20";
            background_color = "000000";
            gpu_color = "FFCCF6";
            cpu_color = "FFCCF6";
            frametime_color = "FFCCF6B";
            engine_color = "FFCCF6";
            text_color = "FFCCF6";

            # Disable settings
            frame_timing = 0;
            horizontal = true;

            mangoapp_steam = true;

            time_format = "%H:%M";
        };
    };
}
