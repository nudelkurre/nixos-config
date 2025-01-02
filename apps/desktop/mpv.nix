{pkgs, ...}:
{
    programs.mpv = {
        enable = true;
        package = pkgs.unstable.mpv;
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
        scriptOpts = {
            osc = {
                layout = "bottombar";
                seekbarstyle = "knob";
                seekbarhandlesize = 0.7;
                seekbarkeyframes = "yes";
                seekrangestyle = "line";
                seekrangeseparate = "yes";
                seekrangealpha = 200;
                deadzonesize = 0.0;
                minmousemove = 0;
                showwindowed = "yes";
                showfullscreen = "yes";
                idlescreen = "yes";
                scalewindowed = 1.0;
                scalefullscreen = 1.0;
                vidscale = "yes";
                valign = 0.8;
                halign = 0.0;
                barmargin = 0;
                boxalpha = 80;
                hidetimeout = 1500;
                fadeduration = 200;
                title = "$\{media-title\}";
                tooltipborder = 1;
                timetotal = "yes";
                timems = "no";
                tcspace = 100;
                visibility = "auto";
                boxmaxchars = 80;
                boxvideo = "no";
                windowcontrols = "auto";
                windowcontrols_alignment = "right";
                greenandgrumpy = "no";
                livemarkers = "yes";
                chapters_osd = "yes";
                playlist_osd = "yes";
                chapter_fmt = "%s";
                unicodeminus = "no";
            };
        };
    };
}