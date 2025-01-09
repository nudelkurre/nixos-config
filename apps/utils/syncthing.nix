{
    services.syncthing = {
        enable = ! config.disable.sybcthing;
        tray = {
            enable = false;
        };
    };
}