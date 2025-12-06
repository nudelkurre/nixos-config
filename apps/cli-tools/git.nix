{ ... }:
{
    programs.git = {
        enable = true;
        lfs = {
            enable = true;
        };
        settings = {
            aliases = {
                st = "status";
            };
            user = {
                email = "nudelkurre@protonmail.com";
                name = "Emil Wendin";
            };
        };
    };
}
