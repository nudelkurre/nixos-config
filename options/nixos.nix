{ pkgs, lib, config, ... }:
with lib;
{
    options = {
        monitors = {
            outputs = mkOption {
                type = types.listOf (
                    types.submodule {
                        options = {
                            adaptive_sync = mkOption {
                                type = types.enum [
                                    "on"
                                    "off"
                                ];
                                example = "on";
                                default = "off";
                            };
                            background = mkOption {
                                type = types.str;
                                default = "#000000";
                            };
                            bg_style = mkOption {
                                type = types.str;
                                default = "solid_color";
                            };
                            height = mkOption {
                                type = types.int;
                                example = 1080;
                            };
                            name = mkOption {
                                type = types.str;
                                example = "DP-1";
                            };
                            refreshRate = mkOption {
                                type = types.int;
                                example = 60;
                                default = 60;
                            };
                            transform = mkOption {
                                type = types.int;
                                example = 0;
                                default = 0;
                            };
                            width = mkOption {
                                type = types.int;
                                example = 1920;
                            };
                            workspaces = mkOption {
                                type = types.listOf types.str;
                                example = [
                                    "1"
                                    "2"
                                ];
                                default = [ ];
                            };
                            x = mkOption {
                                type = types.int;
                                example = 0;
                                default = 0;
                            };
                            y = mkOption {
                                type = types.int;
                                example = 0;
                                default = 0;
                            };
                            wallpaper = mkOption {
                                type = types.enum [
                                    "mpvpaper"
                                    "awww"
                                    "none"
                                ];
                                example = "mpvpaper";
                                default = "none";
                                description = "Set wallpaper service to use";
                            };
                        };
                    }
                );
                default = [ ];
            };
            primary = mkOption {
                type = types.str;
                example = "DP-1";
                default = "";
            };
            wallpaper = mkOption {
                type = types.enum [
                    "awww"
                    "mpvpaper"
                ];
                example = "mpvpaper";
                default = "awww";
                description = "Set default wallpaper service";
            };
        };
        theme = {
            color = {
                main = mkOption {
                    type = types.enum [
                        "blue"
                        "flamingo"
                        "green"
                        "lavender"
                        "maroon"
                        "mauve"
                        "peach"
                        "pink"
                        "red"
                        "rosewater"
                        "sapphire"
                        "sky"
                        "teal"
                        "yellow"
                    ];
                    default = "blue";
                    description = "Set theme main color to use";
                };
                secondary = mkOption {
                    type = types.enum [
                        "blue"
                        "flamingo"
                        "green"
                        "lavender"
                        "maroon"
                        "mauve"
                        "peach"
                        "pink"
                        "red"
                        "rosewater"
                        "sapphire"
                        "sky"
                        "teal"
                        "yellow"
                    ];
                    default = "blue";
                    description = "Set theme secondary color to use";
                };
            };
            gtk = {
                name = mkOption {
                    type = types.str;
                    default = "catppuccin-${config.theme.variant}-${config.theme.color.main}-${config.theme.gtk.size}";
                    description = "Name of theme to use";
                };
                package = mkOption {
                    type = types.package;
                    default = pkgs.unstable.catppuccin-gtk.override {
                        accents = [ config.theme.color.main ];
                        variant = config.theme.variant;
                        size = config.theme.gtk.size;
                    };
                };
                size = mkOption {
                    type = types.enum [
                        "standard"
                        "compact"
                    ];
                    default = "standard";
                    description = "Set size for theme spacing";
                };
            };
            variant = mkOption {
                type = types.enum [
                    "latte"
                    "frappe"
                    "macchiato"
                    "mocha"
                ];
                default = "latte";
                description = "Set theme variant of catppuccin";
            };
        };
    };
}
