{
    pkgs,
    lib,
    sharedSettings,
    ...
}:
{
    programs.zsh = {
        autosuggestion = {
            enable = true;
            highlight = "fg=${sharedSettings.colors.main},bold,underline";
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
        initContent =
            let
                early = lib.mkOrder 500 ''
                    # Early content
                '';
                middle = lib.mkOrder 1000 ''
                    # Middle content
                '';
                late = lib.mkOrder 1500 ''
                    # Late content
                    bindkey "^[[1;5C" forward-word
                    bindkey "^[[1;5D" backward-word
                '';
            in
            lib.mkMerge [
                early
                middle
                late
            ];
        localVariables = {
            PROMPT = "%B%F{#00e600}[%n@%m:%~]$%f%b ";
        };
        oh-my-zsh = {
            enable = true;
            plugins = [
                "git-prompt"
            ];
        };
        package = pkgs.zsh;
        shellAliases = {
            mv = "mv -v";
            cp = "cp -v";
            df = "df -h";
        };
    };
}
