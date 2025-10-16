{
    pkgs,
    config,
    lib,
    ...
}:
let
    outputs = lib.strings.concatStringsSep "\n" (
        map (m: ''
            ${pkgs.mpvpaper}/bin/mpvpaper ${m.name} ${pkgs.wallpapers.wallpapers}/share/wallpapers/${m.orientation} --slideshow 1200 --mpv-options "shuffle" --auto-pause --fork
        '') (config.monitors.outputs)
    );
in
{
    systemd.user = {
        services = {
            "mpvpaper-slideshow" = {
                Service = {
                    ExecStart = pkgs.writeShellScript "mpvpaper-output" ''
                        ${outputs}
                    '';
                    GuessMainPID = "no";
                    RemainAfterExit = "yes";
                    Restart = "on-failure";
                    RestartSec = "5";
                    TimeoutSec = "0";
                    Type = "forking";
                };
                Unit = {
                    Description = "Change background";
                };
            };
        };
    };
}
