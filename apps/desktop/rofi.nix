{ config, pkgs, lib, ... }:
let
    inherit (config.lib.formats.rasi) mkLiteral;
in
{
    programs.rofi = {
        enable = true;
        extraConfig = {
            disable-history = mkLiteral "true";
            drun-display-format = "{name}";
            fixed-num-lines = mkLiteral "false";
            hover-select = mkLiteral "false";
            icon-theme = "${config.gtk.iconTheme.name}";
            location = mkLiteral "1";
            modes = "drun";
            monitor = mkLiteral "1";
            rows = mkLiteral "5";
            scroll-method = mkLiteral "1";
            scrollbar = mkLiteral "false";
            show-icons = mkLiteral "true";
            sort = mkLiteral "true";
            sorting-method = "fzf";
            
        };
        location = "top-left";
        package = pkgs.rofi-wayland;
        terminal = "kitty";
        theme = {
            "*" = {
                background-color = mkLiteral "transparent";
            };
            "element" = {
                margin = mkLiteral "2px 5px 2px 5px";
                padding = mkLiteral "10px 4px 10px 10px";
            };
            "element-icon" = {
                margin = mkLiteral "0 10px 0 0";
                size = mkLiteral "32px";
            };
            "element.normal.normal, element.alternate.normal, element.normal.urgent, element.alternate.urgent, element.normal.active, element.alternate.active" = {
                background-color = mkLiteral "hsla(0, 0%, 20%, 0.8)";
                border = mkLiteral "2px";
                border-color = mkLiteral "${config.rofi.border-color}";
                border-radius = mkLiteral "20px";
            };
            "element.selected.normal, element.selected.urgent, element.selected.active" = {
                border = mkLiteral "2px";
                background-color = mkLiteral "hsla(0, 0%, 35%, 0.8)";
                border-color = mkLiteral "${config.rofi.border-color}";
                border-radius = mkLiteral "20px";
            };
            "element-text" = {
                font = "${config.fonts.name} Bold 12";
                text-color = mkLiteral "#c8c8c8";
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
                margin = mkLiteral "2px 5px 2px 5px";
                padding = mkLiteral "10px 4px 10px 10px";
                text-color = mkLiteral "#ffffff";
            };
            "listview" = {
                columns = 1;
                lines = config.rofi.lines;
            };
            "prompt" = {
                text-color = mkLiteral "#ffffff";
            };
            "window" = {
                border = 0;
                margin = mkLiteral "10px 0 0 0";
                width = mkLiteral "300px";
            };
        };
    };
}
