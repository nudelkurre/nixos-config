{ ... }:
{
    programs.git = {
        aliases = {
            st = "status";
        };
        enable = true;
        lfs = {
            enable = true;
        };
        userEmail = "nudelkurre@protonmail.com";
        userName = "Emil Wendin";
    };
}
