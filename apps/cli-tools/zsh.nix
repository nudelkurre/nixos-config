{pkgs, ...}:
{
    programs.zsh = {
        autosuggestion = {
            enable = true;
            strategy = [
                "completion"
                "history"
            ];
        };
        enable = true;
        enableCompletion = true;
        history = {
            ignoreAllDups = true;
            ignoreSpace = true;
            save = 10000;
            size = 10000;
        };
        shellAliases = {
            mv = "mv -v";
            cp = "cp -v";
            df = "df -h";
        };
        oh-my-zsh = {
            enable = true;
            plugins = [
                "bgnotify"
                "eza"
            ];
        };
        package = pkgs.zsh;
    };
}