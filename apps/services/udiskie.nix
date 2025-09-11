{ ... }:
{
    services.udiskie = {
        automount = true;
        enable = true;
        notify = true;
        tray = "never";
    };
}
