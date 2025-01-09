{pkgs, config, ...}:
{
    programs.mpv = {
        bindings = {
            "WHEEL_UP" = "seek 10";
            "WHEEL_DOWN" = "seek -10";
            "Ctrl+WHEEL_UP" = "add volume 5";
            "Ctrl+WHEEL_DOWN" = "add volume -5";
            "Shift+WHEEL_UP" = "add speed 0.5";
            "Shift+WHEEL_DOWN" = "add speed -0.5";
            "UP" = "seek 30";
            "DOWN" = "seek -30";
            "Ctrl+LEFT" = "playlist-prev";
            "Ctrl+RIGHT" = "playlist-next";
            "9" = "add volume -5";
            "0" = "add volume 5";
            "[" = "add speed -0.25";
            "]" = "add speed 0.25";
            "{" = "add speed -0.5";
            "}" = "add speed 0.5";
            "Ctrl+r" = "cycle_values video-rotate 90 180 270 0";

            "ESC" = "quit";
            "q" = "quit";
            "CLOSE_WIN" = "ignore";
            "Q" = "ignore";
            "MBTN_MID" = "quit";
        };
        config = {
            hwdec = "vaapi";
            gpu-context = "waylandvk";
            volume-max = "100";
            volume = "60";
            fullscreen = true;
        };
        enable = ! config.disable.mpv;
        package = pkgs.unstable.mpv;
        scriptOpts = {
            osc = {
                boxalpha = 80;
                barmargin = 0;
                boxmaxchars = 80;
                boxvideo = "no";
                chapter_fmt = "%s";
                chapters_osd = "yes";
                deadzonesize = 0.0;
                fadeduration = 200;
                greenandgrumpy = "no";
                halign = 0.0;
                hidetimeout = 1500;
                idlescreen = "yes";
                layout = "bottombar";
                livemarkers = "yes";
                minmousemove = 0;
                playlist_osd = "yes";
                scalefullscreen = 1.0;
                scalewindowed = 1.0;
                seekbarhandlesize = 0.7;
                seekbarkeyframes = "yes";
                seekbarstyle = "knob";
                seekrangealpha = 200;
                seekrangeseparate = "yes";
                seekrangestyle = "line";
                showfullscreen = "yes";
                showwindowed = "yes";
                tcspace = 100;
                timems = "no";
                timetotal = "yes";
                title = "$\{media-title\}";
                tooltipborder = 1;
                unicodeminus = "no";
                valign = 0.8;
                vidscale = "yes";
                visibility = "auto";
                windowcontrols = "auto";
                windowcontrols_alignment = "right";
            };
        };
    };
}