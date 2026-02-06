{ config, pkgs, sharedSettings, ... }:
let
    inherit (config.lib.formats.rasi) mkLiteral;
in
{
    programs.rofi = {
        enable = true;
        cycle = false;
        extraConfig = {
            disable-history = mkLiteral "true";
            drun-display-format = "{name}";
            drun-match-fields = "name";
            fixed-num-lines = mkLiteral "false";
            hover-select = mkLiteral "false";
            icon-theme = "${config.gtk.iconTheme.name}";
            scroll-method = mkLiteral "0";
            show-icons = mkLiteral "true";
            sort = mkLiteral "true";
            sorting-method = "fzf";

        };
        location = "top-left";
        modes = [ "drun" ];
        package = pkgs.rofi;
        terminal = "kitty";
        theme = {
            "*" = {
                background-color = mkLiteral "transparent";
            };
            "element" = {
                margin = mkLiteral "2px 5px 2px 5px";
                padding = mkLiteral "10px 4px 10px 10px";
                children = mkLiteral "[element-icon, element-text]";
                orientation = mkLiteral "vertical";
            };
            "element-icon" = {
                size = mkLiteral "96px";
            };
            "element-text" = {
                font = "${config.fonts.name} Bold 10";
                text-color = mkLiteral sharedSettings.colors.text;
                horizontal-align = mkLiteral "0.5";
            };
            "element.normal.normal, element.alternate.normal, element.normal.urgent, element.alternate.urgent, element.normal.active, element.alternate.active" =
                {
                    background-color = mkLiteral "${sharedSettings.colors.base}00";
                };
            "element.selected.normal, element.selected.urgent, element.selected.active" = {
                background-color = mkLiteral "${sharedSettings.colors.overlay}d9";
                border = mkLiteral "2px";
                border-color = mkLiteral "${config.rofi.border-color}";
                border-radius = mkLiteral "${toString config.desktop.corner-radius}px";
            };
            "entry" = {
                placeholder = "Program";
                placeholder-color = mkLiteral sharedSettings.colors.text;
                text-color = mkLiteral sharedSettings.colors.text;
            };
            "inputbar" = {
                background-color = mkLiteral "${sharedSettings.colors.overlay}d9";
                border-radius = mkLiteral "${toString config.desktop.corner-radius}px";
                children = mkLiteral "[entry]";
                margin = mkLiteral "10px";
                padding = mkLiteral "10px 4px 10px 10px";
                text-color = mkLiteral sharedSettings.colors.text;
            };
            "listview" = {
                columns = mkLiteral "10";
                scrollbar = mkLiteral "false";
                padding = mkLiteral "10px";
            };
            "prompt" = {
                text-color = mkLiteral sharedSettings.colors.text;
            };
            "window" = {
                background-color = mkLiteral "${sharedSettings.colors.base}cc";
                border = mkLiteral "2px";
                border-color = mkLiteral "${config.rofi.border-color}";
                border-radius = mkLiteral "${toString config.desktop.corner-radius}px";
                margin = mkLiteral "${toString (config.desktop.gaps * 4)}px";
                width = mkLiteral "100%";
                height = mkLiteral "100%";
            };
        };
    };
}
