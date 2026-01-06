{ pkgs, config, lib, ... }:
let
    color = "Pink";
    variant = "Frappe";
    accent = if variant == "Latte" then "Light" else "Dark";
in
{
    dconf.settings = {
        "org/gnome/desktop/interface" = {
            color-scheme = "prefer-${lib.strings.toLower accent}";
        };
    };
    home.pointerCursor = {
        gtk.enable = true;
        name = "${config.gtk.cursorTheme.name}";
        package = config.gtk.cursorTheme.package;
        size = config.gtk.cursorTheme.size;
        x11 = {
            enable = true;
            defaultCursor = "${config.gtk.cursorTheme.name}";
        };
    };
    gtk = {
        enable = true;
        cursorTheme = {
            name = "catppuccin-${lib.strings.toLower variant}-${lib.strings.toLower color}-cursors";
            package = pkgs.catppuccin-cursors."${lib.strings.toLower variant + color}";
            size = 32;
        };
        font = {
            name = "${config.fonts.name}";
            size = 10;
        };
        iconTheme = {
            name = "Papirus-${accent}";
            package = pkgs.catppuccin-papirus-folders.override {
                accent = "${lib.strings.toLower color}";
                flavor = "${lib.strings.toLower variant}";
            };
        };
        theme = {
            name = "Colloid-${color}-${accent}-Compact-Catppuccin";
            package = pkgs.unstable.colloid-gtk-theme.override {
                themeVariants = [ "${lib.strings.toLower color}" ];
                colorVariants = [ "${lib.strings.toLower accent}" ];
                sizeVariants = [ "compact" ];
                tweaks = [ "catppuccin" ];
            };
        };
        gtk2 = {
            extraConfig = ''
                gtk-enable-animations = 1
                gtk-primary-button-warps-slider = 0
                gtk-toolbar-style = 3
                gtk-menu-images = 1
                gtk-button-images = 1
            '';
        };
        gtk3 = {
            bookmarks = [
                "file:///home/emil/Downloads"
                "file:///home/emil/repos"
            ];
            extraConfig = {
                gtk-application-prefer-dark-theme = if accent == "Dark" then true else false;
                gtk-button-images = true;
                gtk-decoration-layout = "icon:minimize,maximize,close";
                gtk-enable-animations = true;
                gtk-menu-images = true;
                gtk-modules = "window-decorations-gtk-module:colorreload-gtk-module";
                gtk-primary-button-warps-slider = false;
                gtk-toolbar-style = 3;
                gtk-xft-dpi = 98304;
            };
        };
        gtk4 = {
            extraConfig = {
                gtk-application-prefer-dark-theme = if accent == "Dark" then true else false;
                gtk-decoration-layout = "icon:minimize,maximize,close";
                gtk-enable-animations = true;
                gtk-primary-button-warps-slider = false;
                gtk-xft-dpi = 98304;
            };
        };
    };
    qt = {
        style = {
            name = "catppuccin-${lib.strings.toLower variant}-${lib.strings.toLower color}";
            package = pkgs.unstable.catppuccin-kvantum.override {
                accent = "${lib.strings.toLower color}";
                variant = "${lib.strings.toLower variant}";
            };
        };
    };
}
