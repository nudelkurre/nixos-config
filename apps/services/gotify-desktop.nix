{ pkgs, ... }:
{
    systemd = {
        user = {
            services = {
                "gotify-desktop" = {
                    Unit = {
                        Description = "Gotify daemon to send desktop notifications";
                        PartOf = "graphical-session.target";
                    };
                    Install = {
                        WantedBy = [ "graphical-session.target" ];
                    };
                    Service = {
                        ExecStart = "${pkgs.gotify-desktop}/bin/gotify-desktop";
                        Restart = "always";
                        RestartSec = "5s";
                    };
                };
            };
        };
    };
}
