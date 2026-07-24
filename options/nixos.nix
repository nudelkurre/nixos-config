{ lib, ... }:
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
    };
}
