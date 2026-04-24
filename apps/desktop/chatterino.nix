{ pkgs, config, sharedSettings, ... }:
let
    colors = sharedSettings.colors."${sharedSettings.colors.variant}";
    accent = "pink";
    strip = code: builtins.substring 1 6 code;
    theme_json = {
        "$schema" = "https://raw.githubusercontent.com/Chatterino/chatterino2/v2.5.0/docs/ChatterinoTheme.schema.json";
        "colors" = {
            "accent" = "#ff${strip colors.${accent}}";
            "messages" = {
                "backgrounds" = {
                    "alternate" = "#ff${strip colors.base}";
                    "regular" = "#ff${strip colors.mantle}";
                };
                "disabled" = "#99${strip colors.crust}";
                "highlightAnimationEnd" = "#00${strip colors.overlay2}";
                "highlightAnimationStart" = "#73${strip colors.overlay2}";
                "selection" = "#40${strip colors.text}";
                "textColors" = {
                    "caret" = "#ff${strip colors.text}";
                    "chatPlaceholder" = "#ff${strip colors.subtext1}";
                    "link" = "#ff${strip colors.${accent}}";
                    "regular" = "#ff${strip colors.text}";
                    "system" = "#ff${strip colors.subtext0}";
                };
            };
            "scrollbars" = {
                "background" = "#00${strip colors.crust}";
                "thumb" = "#ff${strip colors.overlay1}";
                "thumbSelected" = "#ff${strip colors.overlay0}";
            };
            "splits" = {
                "background" = "#ff${strip colors.crust}";
                "dropPreview" = "#33${strip colors.${accent}}";
                "dropPreviewBorder" = "#ff${strip colors.${accent}}";
                "dropTargetRect" = "#00${strip colors.${accent}}";
                "dropTargetRectBorder" = "#00${strip colors.${accent}}";
                "header" = {
                    "background" = "#ff${strip colors.mantle}";
                    "border" = "#ff${strip colors.crust}";
                    "focusedBackground" = "#ff${strip colors.mantle}";
                    "focusedBorder" = "#ff${strip colors.crust}";
                    "focusedText" = "#ff${strip colors.text}";
                    "text" = "#ff${strip colors.text}";
                };
                "input" = {
                    "background" = "#ff${strip colors.mantle}";
                    "text" = "#ff${strip colors.${accent}}";
                };
                "messageSeperator" = "#ff${strip colors.surface0}";
                "resizeHandle" = "#ff${strip colors.${accent}}";
                "resizeHandleBackground" = "#ff${strip colors.${accent}}";
            };
            "tabs" = {
                "dividerLine" = "#ff${strip colors.${accent}}";
                "highlighted" = {
                    "backgrounds" = {
                        "hover" = "#ff${strip colors.mantle}";
                        "regular" = "#ff${strip colors.mantle}";
                        "unfocused" = "#ff${strip colors.mantle}";
                    };
                    "line" = {
                        "hover" = "#ff${strip colors.red}";
                        "regular" = "#ff${strip colors.red}";
                        "unfocused" = "#ff${strip colors.red}";
                    };
                    "text" = "#ff${strip colors.subtext1}";
                };
                "liveIndicator" = "#ff${strip colors.red}";
                "newMessage" = {
                    "backgrounds" = {
                        "hover" = "#ff${strip colors.mantle}";
                        "regular" = "#ff${strip colors.mantle}";
                        "unfocused" = "#ff${strip colors.mantle}";
                    };
                    "line" = {
                        "hover" = "#ff${strip colors.mantle}";
                        "regular" = "#ff${strip colors.mantle}";
                        "unfocused" = "#ff${strip colors.mantle}";
                    };
                    "text" = "#ff${strip colors.text}";
                };
                "regular" = {
                    "backgrounds" = {
                        "hover" = "#ff${strip colors.mantle}";
                        "regular" = "#ff${strip colors.mantle}";
                        "unfocused" = "#ff${strip colors.mantle}";
                    };
                    "line" = {
                        "hover" = "#ff${strip colors.mantle}";
                        "regular" = "#ff${strip colors.mantle}";
                        "unfocused" = "#ff${strip colors.mantle}";
                    };
                    "text" = "#ff${strip colors.subtext0}";
                };
                "rerunIndicator" = "#ff${strip colors.yellow}";
                "selected" = {
                    "backgrounds" = {
                        "hover" = "#ff${strip colors.surface0}";
                        "regular" = "#ff${strip colors.surface0}";
                        "unfocused" = "#ff${strip colors.surface0}";
                    };
                    "line" = {
                        "hover" = "#ff${strip colors.${accent}}";
                        "regular" = "#ff${strip colors.${accent}}";
                        "unfocused" = "#ff${strip colors.${accent}}";
                    };
                    "text" = "#ff${strip colors.text}";
                };
            };
            "window" = {
                "background" = "#ff${strip colors.crust}";
                "text" = "#ff${strip colors.subtext1}";
            };
        };
        "metadata" = {
            "iconTheme" = "light";
        };
    };
    toJson = pkgs.formats.json {};
in
{
    home = {
        file = {
            "${config.xdg.dataHome}/chatterino/Themes/${sharedSettings.colors.variant}-${accent}.json" = {
                force = true;
                source = toJson.generate "theme" theme_json;
            };
        };
        packages = [
            pkgs.chatterino2
        ];
    };
}
