{ pkgs, sharedSettings, ... }:
let
    colors = sharedSettings.colors."${sharedSettings.colors.variant}";
    accent = "pink";
    strip = code: builtins.substring 1 6 code;
    theme_json = {
        "$schema" =
            "https://raw.githubusercontent.com/Chatterino/chatterino2/v2.5.0/docs/ChatterinoTheme.schema.json";
        "colors" = {
            "accent" = "${strip colors.${accent}}"; #ff
            "messages" = {
                "backgrounds" = {
                    "alternate" = "${colors.base}"; #ff
                    "regular" = "${colors.mantle}"; #ff
                };
                "disabled" = "${colors.crust}"; #99
                "highlightAnimationEnd" = "${colors.overlay2}"; #00
                "highlightAnimationStart" = "${colors.overlay2}"; #73
                "selection" = "${colors.text}"; #40
                "textColors" = {
                    "caret" = "${colors.text}"; #ff
                    "chatPlaceholder" = "${colors.subtext1}"; #ff
                    "link" = "${colors.${accent}}"; #ff
                    "regular" = "${colors.text}"; #ff
                    "system" = "${colors.subtext0}"; #ff
                };
            };
            "scrollbars" = {
                "background" = "${colors.crust}"; #00
                "thumb" = "${colors.overlay1}"; #ff
                "thumbSelected" = "${colors.overlay0}"; #ff
            };
            "splits" = {
                "background" = "${colors.crust}"; #ff
                "dropPreview" = "${colors.${accent}}"; #33
                "dropPreviewBorder" = "${colors.${accent}}"; #ff
                "dropTargetRect" = "${colors.${accent}}"; #00
                "dropTargetRectBorder" = "${colors.${accent}}"; #00
                "header" = {
                    "background" = "${colors.mantle}"; #ff
                    "border" = "${colors.crust}"; #ff
                    "focusedBackground" = "${colors.mantle}"; #ff
                    "focusedBorder" = "${colors.crust}"; #ff
                    "focusedText" = "${colors.text}"; #ff
                    "text" = "${colors.text}"; #ff
                };
                "input" = {
                    "background" = "${colors.mantle}"; #ff
                    "text" = "${colors.${accent}}"; #ff
                };
                "messageSeperator" = "${colors.surface0}"; #ff
                "resizeHandle" = "${colors.${accent}}"; #ff
                "resizeHandleBackground" = "${colors.${accent}}"; #ff
            };
            "tabs" = {
                "dividerLine" = "${colors.${accent}}"; #ff
                "highlighted" = {
                    "backgrounds" = {
                        "hover" = "${colors.mantle}"; #ff
                        "regular" = "${colors.mantle}"; #ff
                        "unfocused" = "${colors.mantle}"; #ff
                    };
                    "line" = {
                        "hover" = "${colors.red}"; #ff
                        "regular" = "${colors.red}"; #ff
                        "unfocused" = "${colors.red}"; #ff
                    };
                    "text" = "${colors.subtext1}"; #ff
                };
                "liveIndicator" = "${colors.red}"; #ff
                "newMessage" = {
                    "backgrounds" = {
                        "hover" = "${colors.mantle}"; #ff
                        "regular" = "${colors.mantle}"; #ff
                        "unfocused" = "${colors.mantle}"; #ff
                    };
                    "line" = {
                        "hover" = "${colors.mantle}"; #ff
                        "regular" = "${colors.mantle}"; #ff
                        "unfocused" = "${colors.mantle}"; #ff
                    };
                    "text" = "${colors.text}"; #ff
                };
                "regular" = {
                    "backgrounds" = {
                        "hover" = "${colors.mantle}"; #ff
                        "regular" = "${colors.mantle}"; #ff
                        "unfocused" = "${colors.mantle}"; #ff
                    };
                    "line" = {
                        "hover" = "${colors.mantle}"; #ff
                        "regular" = "${colors.mantle}"; #ff
                        "unfocused" = "${colors.mantle}"; #ff
                    };
                    "text" = "${colors.subtext0}"; #ff
                };
                "rerunIndicator" = "${colors.yellow}"; #ff
                "selected" = {
                    "backgrounds" = {
                        "hover" = "${colors.surface0}"; #ff
                        "regular" = "${colors.surface0}"; #ff
                        "unfocused" = "${colors.surface0}"; #ff
                    };
                    "line" = {
                        "hover" = "${colors.${accent}}"; #ff
                        "regular" = "${colors.${accent}}"; #ff
                        "unfocused" = "${colors.${accent}}"; #ff
                    };
                    "text" = "${colors.text}"; #ff
                };
            };
            "window" = {
                "background" = "${colors.crust}"; #ff
                "text" = "${colors.subtext1}"; #ff
            };
        };
        "metadata" = {
            "iconTheme" = "light";
        };
    };
    toJson = pkgs.formats.json {};
in
{
    home.file = {
        # "${config.xdg.dataHome}/chatterino/Themes/${sharedSettings.colors.variant}.json" = {
        #     text = ''
        #         ${theme_json}
        #     '';
        # };
        test = {
            text = ''
                ${toJson.generate "theme" theme_json}
            '';
        };
    };
}
