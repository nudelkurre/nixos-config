{pkgs, config, ...}:
{
    programs.bash = {
        bashrcExtra = ''
PS1="\\w> "
        '';
        enable = ! config.disable.bash;
        enableCompletion = true;
        historyControl = [ "ignoredups" ];
        historyIgnore = [
            "ls"
            "cd"
            "git"
            "sway"
            "Hyprland"
            "nix"
        ];
        sessionVariables = {
            
        };
        shellAliases = {
            mv = "mv -v";
            cp = "cp -v";
        };
    };
}
