{pkgs, config, ...}:
{
    dconf.settings = {
        "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
        };
    };
    home.pointerCursor = {
        gtk.enable = ! config.disable.gtk;
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
            name = "Bibata-Modern-Ice";
            package = pkgs.bibata-cursors;
            size = 32;
        };
        font = {
            name = "${config.fonts.name}";
            size = 10;
        };
        iconTheme = {
            name = "Papirus-Dark";
            package = pkgs.catppuccin-papirus-folders.override {
                accent = "pink";
                flavor = "frappe";
            };
        };
        theme = {
            name = "Colloid-Pink-Dark-Compact-Catppuccin";
            package = pkgs.unstable.colloid-gtk-theme.override {
                themeVariants = [ "pink" ];
                colorVariants = [ "dark" ];
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
            ];
            extraConfig = {
                gtk-application-prefer-dark-theme = true;
                gtk-button-images = true;
                gtk-decoration-layout = icon:minimize,maximize,close;
                gtk-enable-animations = true;
                gtk-menu-images = true;
                gtk-modules = window-decorations-gtk-module:colorreload-gtk-module;
                gtk-primary-button-warps-slider = false;
                gtk-toolbar-style = 3;
                gtk-xft-dpi = 98304;
            };
        };
        gtk4 = {
            extraConfig = {
                gtk-application-prefer-dark-theme = true;
                gtk-decoration-layout = icon:minimize,maximize,close;
                gtk-enable-animations = true;
                gtk-primary-button-warps-slider = false;
                gtk-xft-dpi = 98304;
            };
        };
    };
}