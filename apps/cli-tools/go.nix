{pkgs, config, ...}:
{
    programs.go = {
        enable = ! config.disable.go;
        goBin = ".local/bin.go";
        goPath = "go";
    };
}