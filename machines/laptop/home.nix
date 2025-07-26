{ config, pkgs, ... }:

{
    fonts = {
        fontconfig = {
            enable = true;
            defaultFonts = {
                emoji = ["OpenMoji Color"];
                monospace = ["MonaspiceAr Nerd Font Mono"];
                sansSerif = ["MonaspiceAr Nerd Font"];
                serif = ["MonaspiceXe Nerd Font"];
            };
        };
        name = "MonaspiceRn Nerd Font Mono";
        size = 13;
    };

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    home = {
        file = {

        };
        homeDirectory = "/home/emil";
        packages = with pkgs; [
            hyprpaper
            imv
            lm_sensors
            mate.mate-polkit
            mypkgs.freetube
            nemo-with-extensions
            pavucontrol
            wireguard-tools
            wl-clipboard
        ];
        sessionVariables = {
            EDITOR = "nano";
        };
        # This value determines the Home Manager release that your configuration is
        # compatible with. This helps avoid breakage when a new Home Manager release
        # introduces backwards incompatible changes.
        #
        # You should not change this value, even if you update Home Manager. If you do
        # want to update the value, then make sure to first check the Home Manager
        # release notes.
        stateVersion = "23.05"; # Please read the comment before changing.
        username = "emil";
    };

    input = {
        keyboard = {
            language = "se";
            variant = "nodeadkeys";
            numlock = false;
        };
        mouse = {
            enable = true;
            natural-scroll = false;
        };
        touchpad = {
            enable = true;
            scroll-method = "two-finger"
        };
    };

    keybindings = [
        # Controlling media
        {
            key = "XF86AudioPlay";
            program = "${pkgs.playerctl}/bin/playerctl -i firefox,floorp play-pause";
        }
        {
            key = "XF86AudioNext";
            program = "${pkgs.playerctl}/bin/playerctl -i firefox,floorp next";
        }
        {
            key = "XF86AudioPrev";
            program = "${pkgs.playerctl}/bin/playerctl -i firefox,floorp previous";
        }
        
        # Change volume
        {
            key = "XF86AudioRaiseVolume";
            program = "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
        }
        {
            key = "XF86AudioLowerVolume";
            program = "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        }
        {
            key = "XF86AudioMute";
            program = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        }

        # Shutdown
        {
            mod = ["Mod4" "Shift"];
            key = "s";
            program = "systemctl poweroff";
            overlay-title = "Shutdown";
        }

        # Reboot
        {
            mod = ["Mod4" "Ctrl" "Shift"];
            key = "r";
            program = "systemctl reboot";
            overlay-title = "Reboot";
        }

        # Start Floorp
        {
            mod = ["Mod4" "Shift"];
            key = "f";
            program = "floorp";
        }
        {
            key = "XF86HomePage";
            program = "floorp";
        }

        # Start Floorp in private window
        {
            mod = ["Mod4" "Ctrl" "Shift"];
            key = "f";
            program = "floorp --private-window";
        }

        # Take a screenshot
        {
            key = "Print";
            program = "${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\"";
        }
    ];

    monitors = {
        outputs = [
            {
                adaptive_sync = "off";
                background = "${pkgs.mypkgs.wallpapers}/share/wallpapers/wallhaven-ne7jkw.jpg";
                bg_style = "fill";
                height = 768;
                name = "LVDS-1";
                refreshRate = 60;
                transform = 0;
                width = 1366;
                workspaces = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" ];
                x = 0;
                y = 0;
            }
            {
                adaptive_sync = "off";
                background = "${pkgs.mypkgs.wallpapers}/share/wallpapers/wallhaven-ne7jkw.jpg";
                bg_style = "fill";
                name = "HDMI-A-1";
                height = 720;
                refreshRate = 60;
                transform = 0;
                width = 1280;
                workspaces = [ "10" ];
                x = 1366;
                y = 0;
            }
        ];
        primary = "LVDS-1";
    };

    # Allow to install unfree packages
    nixpkgs = {
        config = {
            allowUnfree = true;
        };
    };

    # Let Home Manager install and manage itself.
    programs = {
        home-manager = {
            enable = true;
        };
        ngb = {
            enable = true;
            settings = {
                bars = [
                    {
                        "output" = "LVDS-1";
                        "widgets" = {
                            "center" = [
                                {
                                    "config" = {
                                        "city" = "Västerås";
                                    };
                                    "module" = "weather";
                                }
                            ];
                            "left" = [
                                {
                                    "config" = {
                                        "monitor" = "all";
                                        "names" = {
                                            "1" = "";
                                            "2" = "";
                                            "3" = "";
                                            "4" = "";
                                            "5" = "";
                                            "6" = "";
                                            "7" = "";
                                            "8" = "";
                                            "9" = "󰓃";
                                            "10" = "";
                                        };
                                    };
                                "module" = "workspace";
                                }
                            ];
                            "right" = [
                                {
                                    "config" = {
                                        "mountpoint" = "/";
                                    };
                                    "module" = "disk";
                                }
                                {
                                    "config" = {};
                                    "module" = "cpu";
                                }
                                {
                                    "config" = {
                                        "interface" = "eth0";
                                    };
                                    "module" = "network";
                                }
                                {
                                    "config" = {
                                        "interface" = "wlan0";
                                    };
                                    "module" = "network";
                                }
                                {
                                    "config" = {};
                                    "module" = "volume";
                                }
                                {
                                    "config" = {
                                        "timeformat_normal" = "%H:%M:%S";
                                        "timeformat_revealer" = "%A %Y-%m-%d";
                                    };
                                    "module" = "clock";
                                }
                            ];
                        };
                    }
                ];
                "icon_size" = 20;
                "spacing" = 5;
            };
        };
    };

    qt = {
        enable = true;
        platformTheme.name = "gtk";
    };

    rofi = {
        border-color = "#f3c8f3";
        lines = 11;
    };

    services = {
        udiskie = {
            automount = true;
            enable = true;
            notify = true;
            tray = "never";
        };
    };

    workspaces = [
        {
            name = "1";
            programs = [
                {name ="Alacritty"; focus = true;}
                {name ="kitty"; focus = true;}
            ];
        }
        {
            name = "2";
            programs = [
                {name = "chromium-browser"; focus = true;}
                {name = "firefox"; focus = true;}
            ];
        }
        {
            name = "3";
            programs = [
                {name = "FreeTube"; focus = true;}
            ];
        }
        {
            name = "4";
            programs = [  ];
        }
        {
            name = "5";
            programs = [
                {name = "com.usebottles.bottles";}
                {name = "gamescope";}
                {name = "steam";}
            ];
        }
        {
            name = "6";
            programs = [  ];
        }
        {
            name = "7";
            programs = [
                {name = "chatterino";}
                {name = "com.chatterino.chatterino";}
                {name = "discord";}
                {name = "Keybase";}
            ];
        }
        {
            name = "8";
            programs = [
                {name = "codium";}
            ];
        }
        {
            name = "9";
            programs = [
                {name = "org.freedesktop.ryuukyu.Helvum";}
                {name = "pavucontrol";}
            ];
        }
        {
            name = "10";
            programs = [  ];
        }
    ];

    xdg = {
        enable = true;
        # Enable xdg-desktop-portal
        portal = {
            config = {
                common = {
                    default = [
                        "gtk"
                    ];
                };
                hyprland = {
                    default = [
                        "gtk"
                        "hyprland"
                    ];
                };
                niri = {
                    default = [
                        "gtk"
                        "gnome"
                    ];
                };
                sway = {
                    default = [
                        "gtk"
                        "wlr"
                    ];
                };
            };
            enable = true;
            extraPortals = [
                pkgs.xdg-desktop-portal-gnome
                pkgs.xdg-desktop-portal-gtk
                pkgs.xdg-desktop-portal-hyprland
                pkg.xdg-desktop-portal-wlr
            ];
            xdgOpenUsePortal = true;
        };
        userDirs = {
            createDirectories = true;
            enable = true;
        };
    };
}
