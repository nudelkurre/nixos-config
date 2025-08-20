{ config, ... }:
{
    programs.bash = {
        bashrcExtra = ''
            PS1="\[\e[1;32m\][\u@\h:\w]\$\[\e[0m\] "
        '';
        enable = !config.disable.bash;
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
