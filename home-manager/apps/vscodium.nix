
{ config, lib, pkgs, ... }:

{
    programs.vscode = {
        enable = true;
        enableUpdateCheck = false;
        package = pkgs.unstable.vscodium;
        extensions = with pkgs.vscode-extensions; [
            golang.go
            jnoortheen.nix-ide
            ms-python.python
            ms-dotnettools.csdevkit
        ];
        keybindings = [
            {
                "key" = "ctrl+alt+t";
                "command" = "workbench.action.terminal.new";
            }
            {
                "key" = "ctrl+shift+7";
                "command" = "editor.action.commentLine";
                "when" = "editorTextFocus && !editorReadonly";
            }
        ];
        userSettings = {
            "editor.fontFamily" = "${config.fonts.name}";
            "workbench.colorTheme" = "Default Dark";
            "editor.tabSize" = 4;
            "editor.insertSpaces" = true;
        };
    };
}