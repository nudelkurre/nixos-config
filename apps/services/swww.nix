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
                
                if [ -n "$1" ]; then
                    count=$1
                else
                    count=1
                fi
            ''
            + lib.strings.concatStringsSep "\n" (
                map (m: ''
                    for i in $(seq $count); do
                        filename=$(find ${pkgs.wallpapers.wallpapers}/share/wallpapers/${m.orientation} -maxdepth 1 -type f | grep -P '(png|jpg|jpeg)' | shuf -n 1)
                    done
                    ${config.services.swww.package}/bin/swww img -o ${m.name} --resize=crop --transition-type=fade $filename
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
                    ExecStart = "${config.home.homeDirectory}/.local/bin/swww-background 3";
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
                    OnCalendar = "*:0/20";
                    Unit = "bgchange.service";
                    RandomizedDelaySec = 0;
                    AccuracySec = 15;
                };
                Unit = {
                    Description = "Change background";
                };
            };
        };
    };
}
