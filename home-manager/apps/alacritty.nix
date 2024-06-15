{config, ...}:
{
    programs.alacritty = {
        enable = true;
        settings = {
            font = {
                normal = {
                    family = "${config.fonts.name}";
                    style = "Regular";
                };
                bold = {
                    family = "${config.fonts.name}";
                    style = "Bold";
                };
                italic = {
                    family = "${config.fonts.name}";
                    style = "Italic";
                };
                bold_italic = {
                    family = "${config.fonts.name}";
                    style = "Bold Italic";
                };
                size = 11;
            };
            colors = {
                primary = {
                    background = "#000000";
                    foreground = "#f0f0f0";
                };
                normal = {
                    black = "#171717";
                    red = "#FF3333";
                    green = "#00E600";
                    yellow = "#FFDD33";
                    blue = "#1966FF";
                    magenta = "#CC00CC";
                    cyan = "#00E6E6";
                    white = "#EDEDED";
                };
            };
            window = {
                opacity = 0.8;
            };
            cursor = {
                style = {
                    shape = "Block";
                    blinking = "Never";
                };
            };
            mouse.bindings = [
                {
                    mouse = "Middle";
                    action = "None";
                }
            ];
            env = {
                TERM = "xterm-256color";
            };
        };
    };
}