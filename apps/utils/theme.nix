{
    pkgs,
    config,
    osConfig,
    lib,
    ...
}:
let
    capitalize = str: if str == "" then "" else lib.strings.toUpper (builtins.substring 0 1 str) + lib.strings.toLower (builtins.substring 1 (builtins.stringLength str - 1) str);
    color = osConfig.theme.color.main;
    variant = osConfig.theme.variant;
    accent = if variant == "latte" then "Light" else "Dark";
    darkmode = if accent == "Dark" then true else false;
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
            name = "Afterglow-Recolored-Catppuccin-${capitalize color}";
            package = pkgs.afterglow-cursors-recolored.override {
                themeVariants = [ "Catppuccin" ];
                catppuccinColorVariants = [ (capitalize color) ];
            };
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
            name = osConfig.theme.gtk.name;
            package = osConfig.theme.gtk.package;
        };
        gtk3 = {
            bookmarks = config.desktop.bookmarks;
            extraConfig = {
                gtk-application-prefer-dark-theme = darkmode;
                gtk-button-images = true;
                gtk-enable-animations = true;
                gtk-menu-images = true;
                gtk-toolbar-style = 3;
            };
            theme = config.gtk.theme;
        };
        gtk4 = {
            extraConfig = {
                gtk-application-prefer-dark-theme = darkmode;
                gtk-enable-animations = true;
            };
            theme = config.gtk.theme;
        };
    };
    qt = {
        enable = true;
        platformTheme = {
            name = "gtk3";
        };
        style = {
            name = "catppuccin-${lib.strings.toLower variant}-${lib.strings.toLower color}";
            package = pkgs.unstable.catppuccin-kvantum.override {
                accent = "${lib.strings.toLower color}";
                variant = "${lib.strings.toLower variant}";
            };
        };
    };
}
