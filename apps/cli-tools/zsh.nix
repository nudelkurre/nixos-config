{pkgs, ...}:
{
    programs.zsh = {
        autosuggestion = {
            enable = true;
            highlight = "fg=#ff96ff,bold,underline";
            strategy = [
                "history"
                "completion"
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
        localVariables = {
            PROMPT = "%B%F{#00e600}[%n@%m:%~]$%f%b ";
        };
        package = pkgs.zsh;
        shellAliases = {
            mv = "mv -v";
            cp = "cp -v";
            df = "df -h";
        };
    };
}