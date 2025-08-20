{ ... }:
{
    services.kanshi = {
        enable = true;
        settings = [
            {
                profile = {
                    name = "Desktop";
                    outputs = [
                        {
                            criteria = "DP-1";
                            adaptiveSync = true;
                            mode = "2560x1440@143.856Hz";
                            position = "0,240";
                            transform = "normal";
                        }
                        {
                            criteria = "HDMI-A-1";
                            mode = "1920x1080@60Hz";
                            position = "2560,0";
                            transform = "270";
                        }
                    ];
                };
            }
            {
                profile = {
                    name = "Laptop";
                    outputs = [
                        {
                            criteria = "LVDS-1";
                            mode = "1367x768@60Hz";
                            position = "0,0";
                            transform = "normal";
                        }
                    ];
                };
            }
        ];
    };
    systemd.user.services."kanshi" = {
        Service = {
            RestartSec = 1;
        };
    };
}
