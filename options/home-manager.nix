{ lib, ... }:
with lib;
{
    options = {
        desktop = {
            bookmarks = mkOption {
                type = types.listOf types.str;
                default = [];
                description = "List of bookmarks to use by gtk";
            };
            borders = mkOption {
                type = types.int;
                example = 2;
                default = 0;
                description = "Set border width";
            };
            corner-radius = mkOption {
                type = types.int;
                example = 10;
                default = 0;
                description = "Set radius to use for window corners";
            };
            gaps = mkOption {
                type = types.int;
                example = 2;
                default = 0;
                description = "Set size of gaps to use";
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
                clickfinger = mkOption {
                    type = types.bool;
                    example = false;
                    description = "Enable clickfinger mode for touchpads";
                    default = true;
                };
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
                tap = mkOption {
                    type = types.bool;
                    example = false;
                    description = "Enable tap-to-click";
                    default = true;
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
