{pkgs, config, lib, ...}:
{
    home.packages = [
        (pkgs.writeShellApplication {
            name = "swww-bakground";
            runtimeInputs = [
                pkgs.swww
            ];
            text = lib.strings.concatStringsSep "\n" (map
            (m:
                "swww img -o ${m.name} ${m.background}"
            )
            (config.monitors.outputs));
        })
    ];
    services.swww.enable = true;
}