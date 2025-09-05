{ ... }:
{
    programs.go = {
        enable = true;
        goBin = ".local/bin.go";
        goPath = "go";
    };
}
