{ ... }:
{
    programs.git = {
        enable = true;
        lfs = {
            enable = true;
        };
        settings = {
            alias = {
                st = "status";
            };
            user = {
                email = "nudelkurre@protonmail.com";
                name = "Emil Wendin";
            };
        };
    };
}
