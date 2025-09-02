{
    pkgs,
    config,
    lib,
    ...
}:
{
    home.file = {
        "swww-background" = {
            enable = true;
            executable = true;
            target = ".local/bin/swww-background";
            text = ''
                #!/usr/bin/env bash
            ''
            + lib.strings.concatStringsSep "\n" (
                map (m: ''
                    ${config.services.swww.package}/bin/swww img -o ${m.name} --resize=crop --transition-type=fade "$(find ${pkgs.wallpapers.wallpapers}/share/wallpapers/${m.orientation} -maxdepth 1 -type f | shuf -n 1)"
                '') (config.monitors.outputs)
            );
        };
    };
    services.swww = {
        enable = true;
        package = pkgs.unstable.swww;
    };
    systemd.user = {
        services = {
            bgchange = {
                Service = {
                    ExecStart = "${config.home.homeDirectory}/.local/bin/swww-background";
                    Type = "oneshot";
                    Restart = "on-failure";
                    RestartSec = "5";
                };
                Unit = {
                    Description = "Change background";
                };
            };
        };
        timers = {
            bgchange = {
                Install = {
                    WantedBy = [ "timers.target" ];
                };
                Timer = {
                    OnCalendar = "*:0/15";
                    Unit = "bgchange.service";
                };
                Unit = {
                    Description = "Change background";
                };
            };
        };
    };
}
