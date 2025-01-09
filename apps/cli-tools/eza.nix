{pkgs, config, ...}:
{
    programs.eza = {
        enable = ! config.disable.eza;
        extraOptions = [
            "--header"
            "--group"
            "--long"
            "--numeric"
            "--octal-permissions"
        ];
        git = true;
        icons = "auto";
    };
}