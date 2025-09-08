{ config, pkgs, ... }:
{
    programs.vscode = {
        enable = true;
        package = pkgs.unstable.vscodium;
        profiles = {
            "default" = {
                enableUpdateCheck = false;
                extensions = with pkgs.vscode-extensions; [
                    golang.go
                    james-yu.latex-workshop
                    jnoortheen.nix-ide
                    ms-dotnettools.csdevkit
                    ms-python.python
                    ms-python.black-formatter
                    naumovs.color-highlight
                    catppuccin.catppuccin-vsc
                    catppuccin.catppuccin-vsc-icons
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
                userSettings = {
                    "editor.fontFamily" = "${config.fonts.name}";
                    "editor.insertSpaces" = true;
                    "editor.tabSize" = 4;
                    "nix.enableLanguageServer" = true;
                    "nix.serverPath" = "${pkgs.nil}/bin/nil";
                    "nix.serverSettings" = {
                        "nil" = {
                            "formatting" = {
                                command = [
                                    "${pkgs.nixfmt-rfc-style}/bin/nixfmt"
                                    "--indent=4"
                                ];
                            };
                        };
                    };
                    "workbench.colorTheme" = "Catppuccin Frappé";
                    "workbench.iconTheme" = "catppuccin-frappe";
                    "[python]" = {
                        "editor.formatOnSave" = true;
                        "editor.defaultFormatter" = "ms-python.black-formatter";
                    };
                };
            };
        };
    };
}
