{ config, pkgs, lib, ... }:
let
    inherit (config.lib.formats.rasi) mkLiteral;
in
{
    programs.rofi = {
        enable = ! config.disable.rofi;
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
        package = pkgs.rofi-wayland;
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
                text-color = mkLiteral "#c8c8c8";
                horizontal-align = mkLiteral "0.5";
            };
            "element.normal.normal, element.alternate.normal, element.normal.urgent, element.alternate.urgent, element.normal.active, element.alternate.active" = {
                background-color = mkLiteral "rgba(51, 51, 51, 0.0)";
            };
            "element.selected.normal, element.selected.urgent, element.selected.active" = {
                background-color = mkLiteral "rgba(128, 128, 128, 0.85)";
                border = mkLiteral "2px";
                border-color = mkLiteral "${config.rofi.border-color}";
                border-radius = mkLiteral "20px";
            };
            "entry" = {
                placeholder = "Program";
                placeholder-color = mkLiteral "#aaaaaa";
                text-color = mkLiteral "#ffffff";
            };
            "inputbar" = {
                background-color = mkLiteral "rgba(128, 128, 128, 0.85)";
                border-radius = mkLiteral "15px";
                children = mkLiteral "[entry]";
                margin = mkLiteral "10px";
                padding = mkLiteral "10px 4px 10px 10px";
                text-color = mkLiteral "#ffffff";
            };
            "listview" = {
                columns = mkLiteral "10";
                scrollbar = mkLiteral "false";
                padding = mkLiteral "10px";
            };
            "prompt" = {
                text-color = mkLiteral "#ffffff";
            };
            "window" = {
                background-color = mkLiteral "rgba(51, 51, 51, 0.8)";
                border = mkLiteral "2px";
                border-color = mkLiteral "${config.rofi.border-color}";
                border-radius = mkLiteral "15px";
                margin = mkLiteral "50px";
                width = mkLiteral "100%";
                height = mkLiteral "100%";
            };
        };
    };
}
