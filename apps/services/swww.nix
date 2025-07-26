{pkgs, config, lib, ...}:
{
    home.packages = [
        (pkgs.writeShellApplication {
            name = "swww-background";
            runtimeInputs = [
                pkgs.swww
            ];
            text = lib.strings.concatStringsSep "\n" (map
            (m:
                ''
                    swww img -o ${m.name} --resize=crop --transition-type=random "$(find ${pkgs.mypkgs.wallpapers}/share/wallpapers/${m.orientation} -maxdepth 1 -type f | shuf -n 1)"
                ''
            )
            (config.monitors.outputs));
        })
    ];
    services.swww.enable = true;
}