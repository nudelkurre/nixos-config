{ ... }:
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

            time_format = "%H:%M %Z";
        };
    };
}
