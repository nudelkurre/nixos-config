{pkgs, config, ...}:
{
    services.wlsunset = {
        enable = ! config.disable.wlsunset;
        latitude = "59.6";
        longitude = "16.5";
        temperature = {
            day = 6500;
            night = 5000;
        };
    };
}