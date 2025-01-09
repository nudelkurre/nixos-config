{pkgs, config, ...}:
{
    programs.bat = {
        config = {

        };
        enable = ! config.disable.bat;
    };
}