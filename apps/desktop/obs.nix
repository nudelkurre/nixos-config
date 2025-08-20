{ pkgs, config, ... }:
{
    programs.obs-studio = {
        enable = !config.disable.obs;
        plugins = with pkgs.obs-studio-plugins; [
            obs-vintage-filter
            obs-vkcapture
            wlrobs
        ];
    };
}
