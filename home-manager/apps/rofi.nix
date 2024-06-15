{ config, pkgs, lib, ... }:
let
    inherit (config.lib.formats.rasi) mkLiteral;
in
{
    programs.rofi = {
        enable = true;
        package = pkgs.rofi-wayland;
        extraConfig = {
            modes = "drun";
            monitor = mkLiteral "1";
            rows = mkLiteral "5";
            location = mkLiteral "1";
            sorting-method = "fzf";
            sort = mkLiteral "true";
            disable-history = mkLiteral "true";
            hover-select = mkLiteral "false";
            fixed-num-lines = mkLiteral "false";
            show-icons = mkLiteral "true";
            scroll-method = mkLiteral "1";
            scrollbar = mkLiteral "false";
            icon-theme = "${config.gtk.iconTheme.name}";
            drun-display-format = "{name}";
            
        };
        location = "top-left";
        terminal = "kitty";
        theme = {
            "*" = {
                background-color = mkLiteral "transparent";
            };
            "window" = {
                border = 0;
                margin = mkLiteral "10px 0 0 0";
                width = mkLiteral "300px";
            };
            "listview" = {
                lines = config.rofi.lines;
                columns = 1;
            };
            "element" = {
                margin = mkLiteral "2px 5px 2px 5px";
                padding = mkLiteral "10px 4px 10px 10px";
            };
            "element-text" = {
                text-color = mkLiteral "#c8c8c8";
                font = "${config.fonts.name} Bold 12";
            };
            "element-icon" = {
                size = mkLiteral "24px";
                margin = mkLiteral "0 10px 0 0";
            };
            "element.normal.normal, element.alternate.normal, element.normal.urgent, element.alternate.urgent, element.normal.active, element.alternate.active" = {
                background-color = mkLiteral "hsla(0, 0%, 20%, 0.8)";
                border-radius = mkLiteral "20px";

                border = mkLiteral "2px";
                border-color = mkLiteral "${config.rofi.border-color}";
            };
            "element.selected.normal, element.selected.urgent, element.selected.active" = {
                background-color = mkLiteral "hsla(0, 0%, 35%, 0.8)";
                border-radius = mkLiteral "20px";

                border = mkLiteral "2px";
                border-color = mkLiteral "${config.rofi.border-color}";
            };
            "entry" = {
                text-color = mkLiteral "#ffffff";
                placeholder = "Program";
                placeholder-color = mkLiteral "#aaaaaa";
            };
            "prompt" = {
                text-color = mkLiteral "#ffffff";
            };
            "inputbar" = {
                border-radius = mkLiteral "15px";
                margin = mkLiteral "2px 5px 2px 5px";
                padding = mkLiteral "10px 4px 10px 10px";
                background-color = mkLiteral "rgba(128, 128, 128, 0.85)";
                text-color = mkLiteral "#ffffff";
                children = mkLiteral "[entry]";
            };
        };
    };
}
