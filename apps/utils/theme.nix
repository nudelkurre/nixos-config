{
    pkgs,
    config,
    lib,
    sharedSettings,
    ...
}:
let
    capitalize = str: if str == "" then "" else lib.strings.toUpper (builtins.substring 0 1 str) + lib.strings.toLower (builtins.substring 1 (builtins.stringLength str - 1) str);
    color = "Pink";
    variant = capitalize sharedSettings.colors.variant;
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
        colorScheme = lib.strings.toLower accent;
        cursorTheme = {
            name = "Afterglow-Recolored-Catppuccin-${color}";
            package = pkgs.afterglow-cursors-recolored.override {
                themeVariants = [ "Catppuccin" ];
                catppuccinColorVariants = [ color ];
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
            name = "Colloid-${color}-${accent}-Compact-Catppuccin";
            package = pkgs.unstable.colloid-gtk-theme.override {
                themeVariants = [ "${lib.strings.toLower color}" ];
                colorVariants = [ "${lib.strings.toLower accent}" ];
                sizeVariants = [ "compact" ];
                tweaks = [ "catppuccin" ];
            };
        };
        gtk3 = {
            bookmarks = [
                "file:///home/emil/Downloads"
                "file:///home/emil/repos"
            ];
            extraConfig = {
                gtk-button-images = true;
                gtk-enable-animations = true;
                gtk-menu-images = true;
                gtk-toolbar-style = 3;
            };
        };
        gtk4 = {
            extraConfig = {
                gtk-enable-animations = true;
            };
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
