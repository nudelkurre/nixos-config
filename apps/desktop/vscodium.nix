
{ config, lib, pkgs, ... }:

{
    programs.vscode = {
        enable = true;
        enableUpdateCheck = false;
        extensions = with pkgs.vscode-extensions; [
            golang.go
            james-yu.latex-workshop
            jnoortheen.nix-ide
            ms-dotnettools.csdevkit
            ms-python.python
        ];
        keybindings = [
            {
                "command" = "workbench.action.terminal.new";
                "key" = "ctrl+alt+t";
            }
            {
                "command" = "editor.action.commentLine";
                "key" = "ctrl+shift+7";
                "when" = "editorTextFocus && !editorReadonly";
            }
        ];
        package = pkgs.unstable.vscodium;
        userSettings = {
            "editor.fontFamily" = "${config.fonts.name}";
            "editor.insertSpaces" = true;
            "editor.tabSize" = 4;
            "workbench.colorTheme" = "Default Dark";
        };
    };
}