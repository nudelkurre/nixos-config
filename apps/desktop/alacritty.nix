{ config, ... }:
{
    programs.alacritty = {
        enable = true;
        settings = {
            colors = {
                primary = {
                    background = "#000000";
                    foreground = "#f0f0f0";
                };
                normal = {
                    black = "#171717";
                    blue = "#1966FF";
                    cyan = "#00E6E6";
                    green = "#00E600";
                    magenta = "#CC00CC";
                    red = "#FF3333";
                    white = "#EDEDED";
                    yellow = "#FFDD33";
                };
            };
            cursor = {
                style = {
                    shape = "Block";
                    blinking = "Never";
                };
            };
            env = {
                TERM = "xterm-256color";
            };
            font = {
                bold = {
                    family = "${config.fonts.name}";
                    style = "Bold";
                };
                bold_italic = {
                    family = "${config.fonts.name}";
                    style = "Bold Italic";
                };
                italic = {
                    family = "${config.fonts.name}";
                    style = "Italic";
                };
                normal = {
                    family = "${config.fonts.name}";
                    style = "Regular";
                };
                size = 11;
            };
            mouse = {
                bindings = [
                    {
                        mouse = "Middle";
                        action = "None";
                    }
                ];
            };
            window = {
                opacity = 0.8;
            };
        };
    };
    xdg = {
        desktopEntries = {
            Alacritty = {
                exec = "${config.programs.alacritty.package}/bin/alacritty";
                icon = "alacritty";
                name = "alacritty";
                noDisplay = true;
            };
        };
    };
}
