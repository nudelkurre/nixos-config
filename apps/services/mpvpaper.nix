{
    pkgs,
    config,
    ...
}:
let
    target = "graphical-session.target";
in
{
    systemd.user =
        if config.monitors.wallpaper == "mpvpaper" then
            {
                services = (
                    builtins.listToAttrs (
                        builtins.map (m: {
                            name = "mpvpaper-${m.name}";
                            value = {
                                Install = {
                                    WantedBy = [ target ];
                                };
                                Service = {
                                    ExecStart =
                                        if m.orientation == "horizontal" then
                                            "${pkgs.mpvpaper}/bin/mpvpaper ${m.name} ${pkgs.wallpapers.video-wallpapers}/share/wallpapers/${m.orientation} --slideshow 1200 --mpv-options 'shuffle panscan=1.0 really-quiet no-audio' --auto-pause"
                                        else
                                            "${pkgs.mpvpaper}/bin/mpvpaper ${m.name} ${pkgs.wallpapers.wallpapers}/share/wallpapers/${m.orientation} --slideshow 1200 --mpv-options 'shuffle panscan=1.0 really-quiet'";
                                    Restart = "always";
                                    RestartSec = "5s";
                                };
                                Unit = {
                                    After = target;
                                    ConditionEnvironment = "WAYLAND_DISPLAY";
                                    Description = "Change background";
                                    PartOf = target;
                                };
                            };
                        }) (config.monitors.outputs)
                    )
                );
            }
        else
            { };
}
