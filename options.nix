{options, pkgs, lib, ...}:
with lib;
{
    options = {
        eww = {
            bars = mkOption {
                type = types.listOf (types.submodule {
                    options = {
                        id = mkOption {
                            type = types.str;
                            example = "1";
                            default = "0";
                            description = "Monitor id or name to use";
                        };
                        name = mkOption {
                            type = types.str;
                            example = "mainbar";
                            description = "Set the name of the bar";
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
            colors = {
                main = mkOption {
                    type = types.str;
                    description = "CSS rgb value (HEX, RGB(), rgba()) to use as main color";
                    example = "#B3F2FF";
                    default = "#B3F2FF";
                };
                secondary = mkOption {
                    type = types.str;
                    description = "CSS rgb value (HEX, RGB(), rgba()) to use as secondary color";
                    example = "rgba(107, 107, 107, 0.4)";
                    default = "rgba(107, 107, 107, 0.4)";
                };
                text = mkOption {
                    type = types.str;
                    description = "CSS rgb value (HEX, RGB()) to use as text color";
                    example = "#FFFFFF";
                    default = "#FFFFFF";
                };
            };
            enable = mkEnableOption "eww";
            icons = {
                font = mkOption {
                    type = types.str;
                    example = "NotoMono Nerd Font";
                    default = "NotoMono Nerd Font";
                };
                size = mkOption {
                    type = types.int;
                    example = 18;
                    default = 18;
                };
            };
            
            package = mkOption {
                type = types.package;
                default = pkgs.eww-git.eww;
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
            
            widgets = mkOption {
                type = types.listOf (types.submodule {
                    options = {
                        anchor = mkOption {
                            type = types.str;
                            example = "top right";
                            default = "top right";
                            description = "Set anchor point for widget";
                        };
                        height = mkOption {
                            type = types.int;
                            example = 1;
                            default = 0;
                            description = "Height of widget in percent of screen";
                        };
                        id = mkOption {
                            type = types.str;
                            example = "1";
                            default = "0";
                            description = "Monitor id or name to use";
                        };
                        modules = mkOption {
                            type = types.listOf types.str;
                            example = [ "(workspace :monitor \"DP-1\")" ];
                            default = [ ];
                        };
                        name = mkOption {
                            type = types.str;
                            example = "mainbar";
                            description = "Set the name of the widget";
                        };
                        width = mkOption {
                            type = types.int;
                            example = 1;
                            default = 0;
                            description = "Width of widget in percent of screen";
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
            outputs = mkOption {
                type = types.listOf (types.submodule {
                    options = {
                        adaptive_sync = mkOption {
                            type = types.enum [ "on" "off" ];
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
                            example = ["1" "2"];
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
                    };
                });
                default = [ ];
            };
            primary = mkOption {
                type = types.str;
                example = "DP-1";
                default = "";
            };
        };
        rofi = {
            border-color = mkOption {
                type = types.str;
                description = "Color to use on borders of rofi";
                example = "#ffffff";
                default = "#ffffff";
            };
            lines = mkOption {
                type = types.int;
                description = "Number of rows to use in rofi";
                example = 15;
                default = 10;
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
                                focus = mkOption {
                                    type = types.bool;
                                    example = true;
                                    default = false;
                                };
                                name = mkOption {
                                    type = types.str;
                                    example = "firefox";
                                };
                            };
                        });
                        default = [ ];
                    };
                };
            });
            default = [ ];
        };
    };
}