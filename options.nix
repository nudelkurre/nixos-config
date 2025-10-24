{ lib, ... }:
with lib;
{
    options = {
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
        gaps = mkOption {
            type = types.int;
            example = 2;
            default = 0;
            description = "Set size of gaps to use";
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
            type = types.listOf (
                types.submodule {
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
                            default = [ ];
                            description = "List of mod keys to use";
                        };
                        overlay-title = mkOption {
                            type = types.str;
                            default = "";
                            example = "Launch firefox";
                            description = "Set a custom title for niri overlay";
                        };
                    };
                }
            );
            default = [ ];
        };
        keybindings-multi = mkOption {
            type = types.listOf (
                types.submodule {
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
                            default = [ ];
                            description = "List of mod keys to use";
                        };
                        overlay-title = mkOption {
                            type = types.str;
                            default = "";
                            example = "Launch firefox";
                            description = "Set a custom title for niri overlay";
                        };
                    };
                }
            );
            default = [ ];
        };
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
                            orientation = mkOption {
                                type = types.enum [
                                    "horizontal"
                                    "vertical"
                                ];
                                example = "vertical";
                                default = "horizontal";
                                description = "Specify orientation for use with background";
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
                type = types.enum[
                    "swww"
                    "mpvpaper"
                ];
                example = "mpvpaper";
                default = "swww";
                description = "Set default wallpaper service";
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
            type = types.listOf (
                types.submodule {
                    options = {
                        name = mkOption {
                            type = types.str;
                            example = "1";
                        };
                        programs = mkOption {
                            type = types.listOf (
                                types.submodule {
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
                                }
                            );
                            default = [ ];
                        };
                    };
                }
            );
            default = [ ];
        };
    };
}
