{ config, pkgs, lib, ... }:
let
    browser = "floorp-private.desktop";
    image_viewer = "imv-dir.desktop";
    media_player = "mpv.desktop";
    text_editor = "codium.desktop";
in
{    
    fonts = {
        fontconfig = {
            defaultFonts = {
                emoji = ["OpenMoji Color"];
                monospace = ["MonaspiceAr Nerd Font Mono"];
                sansSerif = ["MonaspiceAr Nerd Font"];
                serif = ["MonaspiceXe Nerd Font"];
            };
            enable = true;
        };
        name = "MonaspiceRn Nerd Font Mono";
        size = 16;
    };

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    home = {
        file = {
            "m4b-merge" = {
                enable = true;
                executable = true;
                target = ".local/bin/m4b-merge";
                text = ''
                    #!/usr/bin/env bash
                    
                    IFS=$'\n'

                    for i in $(find . -type f -name "*.m4b" | cut -d "/" -f2 | sort -uV); do ${pkgs.m4b-tool.m4b-tool-libfdk}/bin/m4b-tool split $i/*.m4b --output-dir=Splitted/$i --no-conversion -v && ${pkgs.m4b-tool.m4b-tool-libfdk}/bin/m4b-tool merge Splitted/$i/*.m4b --output-file=$1/$i/$i.m4b --no-conversion -v && rm -r Splitted; done

                    for i in $(find . -type f -name "*.m4a" | cut -d "/" -f2 | sort -uV); do ${pkgs.m4b-tool.m4b-tool-libfdk}/bin/m4b-tool merge $i/*.m4a --output-file=$1/$i/$i.m4b -v; done

                    for i in $(find . -type f -name "*.mp3" | cut -d "/" -f2 | sort -uV); do ${pkgs.m4b-tool.m4b-tool-libfdk}/bin/m4b-tool merge $i/*.mp3 --output-file=$1/$i/$i.m4b -v; done
                '';
            };
        };
        homeDirectory = "/home/emil";
        packages = with pkgs; [
            nemo-with-extensions
            mypkgs.freetube
            seahorse
            imv
            lm_sensors
            mypkgs.mangadex-downloader
            mate.mate-polkit
            pavucontrol
            mypkgs.pkg2zip
            scripts.video-dl
            texliveMedium
            wl-clipboard
        ];
        sessionVariables = {
            EDITOR = "nano";
            MANGADEXDL_CONFIG_ENABLED = "1";
            PATH = "$PATH:$HOME/.local/bin";
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

        # Start jellyfin media player
        {
            mod = ["Mod4"];
            key = "kp_0";
            program = "flatpak run com.github.iwalton3.jellyfin-media-player";
        }

        # Start FreeTube
        {
            mod = ["Mod4"];
            key = "kp_1";
            program = "freetube";
        }

        # Open file browser
        {
            mod = ["Mod4"];
            key = "kp_2";
            program = "nemo";
        }

        # Open Steam
        {
            mod = ["Mod4"];
            key = "kp_5";
            program = "steam --no-minimize-to-tray";
        }
    ];

    monitors = {
        outputs = [
            {
                adaptive_sync = "on";
                background = "${pkgs.mypkgs.wallpapers}/share/wallpapers/wallhaven-z8xqqo.jpg";
                bg_style = "fill";
                name = "DP-1";
                height = 1440;
                refreshRate = 144;
                transform = 0;
                width = 2560;
                workspaces = [ "1" "2" "3" "4" "5" ];
                x = 0;
                y = 240;
            }
            {
                adaptive_sync = "off";
                background = "${pkgs.mypkgs.wallpapers}/share/wallpapers/wallhaven-qz2qld.jpg";
                bg_style = "fill";
                name = "HDMI-A-1";
                height = 1080;
                refreshRate = 60;
                transform = 90;
                width = 1920;
                workspaces = [ "6" "7" "8" "9" "10" ];
                x = 2560;
                y = 0;
            }
        ];
        primary = "DP-1";
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
                        "output" = "DP-1";
                        "widgets" = {
                            "center" = [];
                            "left" = [
                                {
                                    "config" = {
                                        "monitor" = "DP-1";
                                        "names" = {
                                            "1" = "";
                                            "2" = "";
                                            "3" = "";
                                            "4" = "";
                                            "5" = "";
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
                                    "config" = {
                                        "interface" = "eth0";
                                    };
                                    "module" = "network";
                                }
                                {
                                    "config" = {};
                                    "module" = "volume";
                                }
                                {
                                    "config" = {
                                        "show_revealer" = true;
                                        "timeformat_normal" = "%H:%M:%S";
                                        "timeformat_revealer" = "%A %Y-%m-%d";
                                    };
                                    "module" = "clock";
                                }
                            ];
                        };
                    }
                    {
                        "output" = "HDMI-A-1";
                        "widgets" = {
                            "center" = [];
                            "left" = [
                                {
                                    "config" = {
                                        "monitor" = "HDMI-A-1";
                                        "names" = {
                                            "6" = "";
                                            "7" = "";
                                            "8" = "";
                                            "9" = "󰓃";
                                            "10" = "";
                                        };
                                    };
                                    "module" = "workspace";
                                }
                            ];
                            "right" = [
                                {
                                    "config" = {};
                                    "module" = "bluetooth";
                                }
                                {
                                    "config" = {};
                                    "module" = "headset";
                                }
                                {
                                    "config" = {};
                                    "module" = "cpu";
                                }
                                {
                                    "config" = {
                                        "city" = "Västerås";
                                        "icon_size" = 20;
                                    };
                                    "module" = "weather";
                                }
                                {
                                    "config" = {
                                        "timeformat_normal" = "%H:%M:%S";
                                        "timeformat_revealer" = "%Y-%m-%d";
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
        platformTheme = {
            name = "gtk3";
        };
    };

    rofi = {
        border-color = "#f3c8f3";
        lines = 23;
    };

    services = {
        swww = {
            enable = true;
        };
    };

    workspaces = [
        {
            name = "1";
            programs = [
                {name = "Alacritty"; focus = true;}
                {name = "kitty"; focus = true;}
            ];
        }
        {
            name = "2";
            programs = [
                {name = "chromium-browser"; focus = true;}
                {name = "firefox"; focus = true;}
                {name = "floorp"; focus = true;}
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
                {name = "heroic";}
                {name = "lutris";}
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
            programs = [  ];
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
            programs = [
                {name = "codium"; focus = true;}
            ];
        }
    ];

    xdg = {
        desktopEntries = {
            steam = {
                name = "Steam";
                comment = "Application for managing and playing games on Steam";
                exec = "steam %U --no-minimize-to-tray";
                icon = "steam";
                terminal = false;
                type = "Application";
                categories = ["Network" "FileTransfer" "Game"];
                mimeType = ["x-scheme-handler/steam" "x-scheme-handler/steamlink"];
            };
        };
        enable = true;
        mimeApps = {
            enable = true;
            defaultApplications = {
                "application/pdf" = browser;
                "audio/mpeg" = media_player;
                "audio/x-m4b" = media_player;
                "audio/x-vorbis+ogg" = media_player;
                "image/jpeg" = image_viewer;
                "image/png" = image_viewer;
                "inode/directory" = "nemo.desktop";
                "text/html" = text_editor;
                "text/x-python" = text_editor;
                "video/mp4" = media_player;
                "video/x-matroska" = media_player;
                "x-scheme-handler/http" = browser;
                "x-scheme-handler/https" = browser;
                "x-scheme-handler/chrome" = browser;
            };
        };
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
                sway = {
                    default = [
                        "gtk"
                        "wlr"
                    ];
                };
            };
            enable = true;
            extraPortals = [
                pkgs.xdg-desktop-portal-gtk
                pkgs.xdg-desktop-portal-hyprland
                pkgs.xdg-desktop-portal-wlr
            ];
            xdgOpenUsePortal = true;
        };
        userDirs = {
            createDirectories = true;
            enable = true;
        };
    };
}
