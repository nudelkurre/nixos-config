{pkgs, config, ...}:
{
    services.syncthing = {
        enable = ! config.disable.syncthing;
        tray = {
            enable = false;
        };
    };
}