{
    pkgs,
    lib,
    config,
    ...
}:
let
    monitors_style = lib.strings.concatStringsSep "\n" (
        map (m: ''
            window#${m.name} {
                background-image: url("${config.xdg.configHome}/gtklock/${
                    if m.transform == 0 || m.transform == 180 then "horizontal" else "vertical"
                }");
                background-size: cover;
            }
        '') (config.monitors.outputs)
    );
in
{
    options = with lib; {
        programs.gtklock = {
            enable = mkOption {
                type = types.bool;
                default = false;
                description = "Enable gtklock";
            };
            package = mkOption {
                type = types.package;
                default = pkgs.gtklock;
                description = "Set package for gtklock";
            };
        };
    };
    config = {
        programs.gtklock = {
            enable = true;
        };
        home = lib.mkIf config.programs.gtklock.enable {
            packages = [
                config.programs.gtklock.package
            ];
        };
        systemd = lib.mkIf config.programs.gtklock.enable {
            user.services = {
                "gtklock-bg" = {
                    Install = {
                        WantedBy = [ "graphical-session.target" ];
                    };
                    Service = {
                        ExecStart = pkgs.writeShellScript "random-bg" ''
                            ln -sf $(find ${pkgs.mypkgs.wallpapers}/share/wallpapers/horizontal | grep -P '(png|jpg|jpeg)' | shuf -n 1) ${config.xdg.configHome}/gtklock/horizontal
                            ln -sf $(find ${pkgs.mypkgs.wallpapers}/share/wallpapers/vertical | grep -P '(png|jpg|jpeg)' | shuf -n 1) ${config.xdg.configHome}/gtklock/vertical
                        '';
                        ExecStop = pkgs.writeShellScript "clean-random-bg" ''
                            rm ${config.xdg.configHome}/gtklock/horizontal
                            rm ${config.xdg.configHome}/gtklock/vertical
                        '';
                        RemainAfterExit = "yes";
                        Type = "oneshot";
                    };
                    Unit = {
                        After = [ "graphical-session.target" ];
                        Description = "Create link to random wallpaper";
                    };
                };
            };
        };
        xdg = lib.mkIf config.programs.gtklock.enable {
            configFile = {
                "style.css" = {
                    target = "gtklock/style.css";
                    text = monitors_style;
                };
            };
        };
    };
}
