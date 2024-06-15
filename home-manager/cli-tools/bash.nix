{
    programs.bash = {
        enable = true;
        enableCompletion = true;
        historyControl = [ "ignoredups" ];
        bashrcExtra = ''
m4b-merge() {
    IFS=$'\n'

    for i in $(find . -type f -name "*.m4b" | cut -d "/" -f2 | sort -uV); do m4b-tool split $i/*.m4b --output-dir=Splitted/$i --no-conversion -v && m4b-tool merge Splitted/$i/*.m4b --output-file=$1/$i/$i.m4b --no-conversion -v && rm -r Splitted; done

    for i in $(find . -type f -name "*.m4a" | cut -d "/" -f2 | sort -uV); do m4b-tool merge $i/*.m4a --output-file=$1/$i/$i.m4b -v; done

    for i in $(find . -type f -name "*.mp3" | cut -d "/" -f2 | sort -uV); do m4b-tool merge $i/*.mp3 --output-file=$1/$i/$i.m4b -v; done
}

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
