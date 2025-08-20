{ config, ... }:
{
    programs.git = {
        aliases = {
            st = "status";
        };
        enable = !config.disable.git;
        userEmail = "nudelkurre@protonmail.com";
        userName = "Emil Wendin";
    };
}
