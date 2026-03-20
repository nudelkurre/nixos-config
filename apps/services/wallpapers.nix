{
    pkgs,
    config,
    lib,
    ...
}:
let
    target = "graphical-session.target";
    services = (
        builtins.listToAttrs (
            builtins.map (m: {
                name = "bgchange-${m.name}";
                value =
                    let
                        mpv-socket = "/tmp/mpv-${m.name}.socket";
                        orientation = if m.transform == 0 || m.transform == 180 then "horizontal" else "vertical";
                    in
                    if m.wallpaper == "mpvpaper" && orientation == "horizontal" then
                        {
                            Install = {
                                WantedBy = [ target ];
                            };
                            Service = {
                                ExecStart = pkgs.writeShellScript "mpvpaper-${m.name}-start" ''
                                    ${pkgs.mpvpaper}/bin/mpvpaper ${m.name} ${pkgs.wallpapers.video-wallpapers}/share/wallpapers/${orientation} --mpv-options 'shuffle loop-file=inf panscan=1.0 really-quiet no-audio input-ipc-server=${mpv-socket}' --auto-pause
                                '';
                                ExecReload = pkgs.writeShellScript "mpvpaper-${m.name}-reload" ''
                                    echo 'playlist-next' | ${pkgs.socat}/bin/socat - ${mpv-socket}
                                '';
                                ExecStop = pkgs.writeShellScript "mpvpaper-${m.name}-stop" ''
                                    echo 'quit' | ${pkgs.socat}/bin/socat - ${mpv-socket}
                                    rm -v ${mpv-socket}
                                '';
                                Restart = "always";
                                RestartSec = "5s";
                            };
                            Unit = {
                                After = target;
                                ConditionEnvironment = "WAYLAND_DISPLAY";
                                Description = "Change background";
                                PartOf = target;
                            };
                        }
                    else if m.wallpaper == "swww" then
                        {
                            Install = {
                                WantedBy = [ target ];
                            };
                            Service = {
                                ExecStart = pkgs.writeShellScript "bgchange-${m.name}" ''
                                    ${config.services.swww.package}/bin/swww img -o ${m.name} --resize=crop --transition-type=fade $(find ${pkgs.wallpapers.wallpapers}/share/wallpapers/${orientation} | grep -P '(png|jpg|jpeg)' | shuf -n 1)
                                '';
                                ExecReload = pkgs.writeShellScript "bgchange-${m.name}" ''
                                    ${config.services.swww.package}/bin/swww img -o ${m.name} --resize=crop --transition-type=fade $(find ${pkgs.wallpapers.wallpapers}/share/wallpapers/${orientation} | grep -P '(png|jpg|jpeg)' | shuf -n 1)
                                '';
                                ExecStopPost = pkgs.writeShellScript "bgchange-${m.name}-clear" ''
                                    ${config.services.swww.package}/bin/swww clear -o ${m.name}
                                '';
                                Type = "oneshot";
                                RemainAfterExit = true;
                                Restart = "on-failure";
                                RestartSec = "5";
                            };
                            Unit = {
                                After = target;
                                ConditionEnvironment = "WAYLAND_DISPLAY";
                                Description = "Change background";
                                PartOf = target;
                            };
                        }
                    else
                        { };
            }) (config.monitors.outputs)
        )
        // builtins.listToAttrs (
            (builtins.map (m: {
                name = "bgchange-${m.name}-restart";
                value =
                    if m.wallpaper == "swww" || m.wallpaper == "mpvpaper" then
                        {
                            Service = {
                                ExecStart = pkgs.writeShellScript "bgchange-${m.name}-restart" ''
                                    if systemctl --user is-active --quiet bgchange-${m.name}.service; then
                                        systemctl --user reload bgchange-${m.name}.service
                                    else
                                        systemctl --user start bgchange-${m.name}.service
                                    fi
                                '';
                                Type = "oneshot";
                                Restart = "on-failure";
                                RestartSec = "5";
                            };
                        }
                    else
                        { };
            }) (config.monitors.outputs))
        )
    );
    timers = (
        builtins.listToAttrs (
            builtins.map (m: {
                name = "bgchange-${m.name}";
                value =
                    if m.wallpaper == "swww" || m.wallpaper == "mpvpaper" then
                        {
                            Install = {
                                WantedBy = [ "timers.target" ];
                            };
                            Timer = {
                                OnCalendar = "*:0/20";
                                Unit = "bgchange-${m.name}-restart.service";
                                RandomizedDelaySec = 0;
                                AccuracySec = 15;
                            };
                            Unit = {
                                Description = "Change background";
                            };
                        }
                    else
                        { };
            }) (config.monitors.outputs)
        )
    );
    enableSwww = builtins.elem true (
        builtins.map (m: if m.wallpaper == "swww" then true else false) (config.monitors.outputs)
    );
    filteredAttrs = lib.filterAttrsRecursive (name: value: value != { });
in
{
    systemd.user = {
        services = filteredAttrs services;
        timers = filteredAttrs timers;
    };
    services.swww.enable = enableSwww;
}
