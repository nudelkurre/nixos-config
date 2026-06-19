{ config, ... }:
{
    services.jellyfin-mpv-shim = {
        enable = true;
        settings = {
            discord_presence = false;
            mpv_ext = true;
            mpv_ext_no_ovr = true;
            mpv_ext_path = "${config.programs.mpv.package}/bin/mpv";
            skip_credits_always = true;
            skip_credits_enable = true;
            skip_intro_always = true;
            skip_intro_enable = true;
        };
    };
}
