{pkgs, ...}:
{
    programs.bash = {
        enable = true;
        enableCompletion = true;
        historyControl = [ "ignoredups" ];
        bashrcExtra = ''
PS1="\\w> "
        '';
        sessionVariables = {
            
        };
        shellAliases = {
            mv = "mv -v";
            cp = "cp -v";
        };
        historyIgnore = [
            "ls"
            "cd"
            "git"
            "sway"
            "Hyprland"
            "nix"
        ];
    };
}
