{ pkgs, config, ... }:
{
    programs.chromium = {
        enable = !config.disable.chromium;
        package = pkgs.ungoogled-chromium;
    };
}
