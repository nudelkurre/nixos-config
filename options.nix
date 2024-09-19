{options, pkgs, lib, ...}:
with lib;
{
    options = {
        eww = {
            enable = mkEnableOption "eww";
            package = mkOption {
                type = types.package;
                default = pkgs.eww;
                defaultText = literalExpression "pkgs.eww";
                example = literalExpression "pkgs.eww";
                description = ''
                    The eww package to install.
                '';
            };
            testing = mkOption {
                type = types.bool;
                description = "Include testing.yuck file inside eww config directory";
                example = true;
                default = false;
            };
            main-color = mkOption {
                type = types.str;
                description = "CSS rgb value (HEX, RGB(), rgba()) to use as main color";
                example = "#B3F2FF";
                default = "#B3F2FF";
            };
            secondary-color = mkOption {
                type = types.str;
                description = "CSS rgb value (HEX, RGB(), rgba()) to use as secondary color";
                example = "rgba(107, 107, 107, 0.4)";
                default = "rgba(107, 107, 107, 0.4)";
            };
            text-color = mkOption {
                type = types.str;
                description = "CSS rgb value (HEX, RGB()) to use as text color";
                example = "#FFFFFF";
                default = "#FFFFFF";
            };
            icon-font = mkOption {
                type = types.str;
                example = "NotoMono Nerd Font";
                default = "NotoMono Nerd Font";
            };
            icon-size = mkOption {
                type = types.int;
                example = 18;
                default = 18;
            };
            bars = mkOption {
                type = types.listOf (types.submodule {
                    options = {
                        name = mkOption {
                            type = types.str;
                            example = "mainbar";
                            description = "Set the name of the bar";
                        };
                        id = mkOption {
                            type = types.int;
                            example = 1;
                            default = 0;
                            description = "Monitor id to use";
                        };
                        widgets = mkOption {
                            type = types.listOf types.str;
                            example = [ "(workspace :monitor \"DP-1\")" ];
                            default = [ ];
                        };
                        width = mkOption {
                            type = types.int;
                            example = 1000;
                            default = 1000;
                            description = "Width of widget in pixels";
                        };
                    };
                });
            };
            widgets = mkOption {
                type = types.listOf (types.submodule {
                    options = {
                        name = mkOption {
                            type = types.str;
                            example = "mainbar";
                            description = "Set the name of the widget";
                        };
                        id = mkOption {
                            type = types.int;
                            example = 1;
                            default = 0;
                            description = "Monitor id to use";
                        };
                        modules = mkOption {
                            type = types.listOf types.str;
                            example = [ "(workspace :monitor \"DP-1\")" ];
                            default = [ ];
                        };
                        x = mkOption {
                            type = types.int;
                            example = 10;
                            default = 0;
                            description = "Position in x";
                        };
                        y = mkOption {
                            type = types.int;
                            example = 10;
                            default = 0;
                            description = "Position in y";
                        };
                        width = mkOption {
                            type = types.int;
                            example = 1;
                            default = 0;
                            description = "Width of widget in percent of screen";
                        };
                        height = mkOption {
                            type = types.int;
                            example = 1;
                            default = 0;
                            description = "Height of widget in percent of screen";
                        };
                        anchor = mkOption {
                            type = types.str;
                            example = "top right";
                            default = "top right";
                            description = "Set anchor point for widget";
                        };
                    };
                });
            };
        };
        fonts = {
            name = mkOption {
                type = types.str;
                example = "NotoMono Nerd Font";
                default = "NotoMono Nerd Font";
            };
            size = mkOption {
                type = types.int;
                example = 16;
                default = 16;
            };
        };
        monitors = {
            primary = mkOption {
                type = types.str;
                example = "DP-1";
                default = "";
            };
            outputs = mkOption {
                type = types.listOf (types.submodule {
                    options = {
                        background = mkOption {
                            type = types.str;
                            default = "#000000";
                        };
                        bg_style = mkOption {
                            type = types.str;
                            default = "solid_color";
                        };
                        name = mkOption {
                            type = types.str;
                            example = "DP-1";
                        };
                        width = mkOption {
                            type = types.int;
                            example = 1920;
                        };
                        height = mkOption {
                            type = types.int;
                            example = 1080;
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
                        adaptive_sync = mkOption {
                            type = types.enum [ "on" "off" ];
                            example = "on";
                            default = "off";
                        };
                        workspaces = mkOption {
                            type = types.listOf types.str;
                            example = ["1" "2"];
                            default = [ ];
                        };
                    };
                });
                default = [ ];
            };
        };
        rofi = {
            lines = mkOption {
                type = types.int;
                description = "Number of rows to use in rofi";
                example = 15;
                default = 10;
            };
            border-color = mkOption {
                type = types.str;
                description = "Color to use on borders of rofi";
                example = "#ffffff";
                default = "#ffffff";
            };
        };
        workspaces = mkOption {
            type = types.listOf (types.submodule {
                options = {
                    name = mkOption {
                        type = types.str;
                        example = "1";
                    };
                    programs = mkOption {
                        type = types.listOf (types.submodule {
                            options = {
                                name = mkOption {
                                    type = types.str;
                                    example = "firefox";
                                };
                                focus = mkOption {
                                    type = types.bool;
                                    example = true;
                                    default = false;
                                };
                            };
                        });
                        default = [ ];
                    };
                    # programs = mkOption {
                    #     type = types.listOf types.str;
                    #     example = [ "firefox" ];
                    #     default = [ ];
                    # };
                };
            });
            default = [ ];
        };
    };
}