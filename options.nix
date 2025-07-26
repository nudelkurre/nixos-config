{options, pkgs, lib, ...}:
with lib;
{
    options = {
        disable = {
            alacritty = mkOption {
                type = types.bool;
                default = false;
                example = true;
            };
            bash = mkOption {
                type = types.bool;
                default = false;
                example = true;
            };
            bat = mkOption {
                type = types.bool;
                default = false;
                example = true;
            };
            chromium = mkOption {
                type = types.bool;
                default = false;
                example = true;
            };
            dunst = mkOption {
                type = types.bool;
                default = false;
                example = true;
            };
            eww = mkOption {
                type = types.bool;
                default = false;
                example = true;
            };
            eza = mkOption {
                type = types.bool;
                default = false;
                example = true;
            };
            firefox = mkOption {
                type = types.bool;
                default = false;
                example = true;
            };
            git = mkOption {
                type = types.bool;
                default = false;
                example = true;
            };
            gnome-keyring = mkOption {
                type = types.bool;
                default = false;
                example = true;
            };
            go = mkOption {
                type = types.bool;
                default = false;
                example = true;
            };
            gtk = mkOption {
                type = types.bool;
                default = false;
                example = true;
            };
            hyprland = mkOption {
                type = types.bool;
                default = false;
                example = true;
            };
            kitty = mkOption {
                type = types.bool;
                default = false;
                example = true;
            };
            mangohud = mkOption {
                type = types.bool;
                default = false;
                example = true;
            };
            mpv = mkOption {
                type = types.bool;
                default = false;
                example = true;
            };
            nano = mkOption {
                type = types.bool;
                default = false;
                example = true;
            };
            obs = mkOption {
                type = types.bool;
                default = false;
                example = true;
            };
            python = mkOption {
                type = types.bool;
                default = false;
                example = true;
            };
            rofi = mkOption {
                type = types.bool;
                default = false;
                example = true;
            };
            ssh = mkOption {
                type = types.bool;
                default = false;
                example = true;
            };
            sway = mkOption {
                type = types.bool;
                default = false;
                example = true;
            };
            syncthing = mkOption {
                type = types.bool;
                default = false;
                example = true;
            };
            vscodium = mkOption {
                type = types.bool;
                default = false;
                example = true;
            };
            wlsunset = mkOption {
                type = types.bool;
                default = false;
                example = true;
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
        input = {
            keyboard = {
                language = mkOption {
                    type = types.str;
                    example = "se";
                    description = "Set the language for keyboard layout";
                    default = "se";
                };
                numlock = mkOption {
                    type = types.bool;
                    example = true;
                    description = "Set numlock to active";
                    default = false;
                };
                variant = mkOption {
                    type = types.str;
                    example = "nodeadkeys";
                    description = "Set variant of keyboard layout";
                    default = "";
                };
            };
            mouse = {
                enable = mkOption {
                    type = types.bool;
                    example = true;
                    description = "Enable mouse";
                    default = false;
                };
                natural-scroll = mkOption {
                    type = types.bool;
                    example = true;
                    description = "Enable natural scroll";
                    default = false;
                };
            };
            touchpad = {
                disable-on-mouse = mkOption {
                    type = types.bool;
                    example = true;
                    description = "Disable if external mouse is connected";
                    default = false;
                };
                enable = mkOption {
                    type = types.bool;
                    example = true;
                    description = "Enable touchpad";
                    default = false;
                };
                natural-scroll = mkOption {
                    type = types.bool;
                    example = true;
                    description = "Enable natural scroll";
                    default = false;
                };
                scroll-method = mkOption {
                    type = types.str;
                    example = "two-finger";
                    description = "Set scroll method";
                    default = "";
                };
            };
        };
        keybindings = mkOption {
            type = types.listOf (types.submodule {
                options = {
                    program = mkOption {
                        type = types.str;
                        example = "firefox";
                        description = "Program to run on key bind";
                    };
                    key = mkOption {
                        type = types.str;
                        example = "f";
                        description = "Key to use for key bind";
                    };
                    mod = mkOption {
                        type = types.listOf types.str;
                        default = [];
                        description = "List of mod keys to use";
                    };
                    overlay-title = mkOption {
                        type = types.str;
                        default = "";
                        example = "Launch firefox";
                        description = "Set a custom title for niri overlay";
                    };
                };
            });
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