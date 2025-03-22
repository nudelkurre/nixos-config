{pkgs, config, ...}:
{
    programs.mangohud = {
        enable = ! config.disable.mangohud;
        settings = {
            time=true;
            fps=true;
            frametime=false;
            cpu_temp=true;
            cpu_mhz=true;
            cpu_power=false;
            gpu_temp=true;
            gpu_power=false;
            gpu_name=false;
            throttling_status=false;
            vram=true;
            ram=true;
            gamemode=true;

            fps_limit="60";
            font_size="20";
            background_color="000000";
            gpu_color="FFCCF6";
            cpu_color="FFCCF6";
            frametime_color="FFCCF6B";
            engine_color="FFCCF6";
            text_color="FFCCF6";

            # Disable settings
            frame_timing=0;
            horizontal=true;

            mangoapp_steam=true;

            time_format="%H:%M";
        };
    };
}