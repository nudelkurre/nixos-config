{
    pkgs,
    config,
    sharedSettings,
    ...
}:
let
    browser = "firefox.desktop";
    image_viewer = "imv-dir.desktop";
    media_player = "mpv.desktop";
    text_editor = "codium.desktop";

    main-monitor = "DP-1";
    secondary-monitor = "HDMI-A-1";
in
{
    fonts = {
        fontconfig = {
            defaultFonts = {
                emoji = [ "OpenMoji Color" ];
                monospace = [ "MonaspiceAr Nerd Font Mono" ];
                sansSerif = [ "MonaspiceAr Nerd Font" ];
                serif = [ "MonaspiceXe Nerd Font" ];
            };
            enable = true;
        };
        name = "MonaspiceRn Nerd Font Mono";
        size = 16;
    };

    gaps = 5;

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    home = {
        homeDirectory = "/home/${sharedSettings.userName}";
        packages = with pkgs; [
            bitwarden-desktop
            imv
            jq
            lm_sensors
            mate.mate-polkit
            mypkgs.freetube
            mypkgs.mangadex-downloader
            mypkgs.pkg2zip
            nemo-with-extensions
            pavucontrol
            python3
            seahorse
            socat
            texliveMedium
            wl-clipboard
            yt-dlp
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
        username = "${sharedSettings.userName}";
    };

    input = {
        keyboard = {
            language = "se";
            variant = "nodeadkeys";
            numlock = true;
        };
        mouse = {
            enable = true;
            natural-scroll = false;
        };
    };

    keybindings = [
        # Controlling media
        {
            key = "XF86AudioPlay";
            program = "${pkgs.playerctl}/bin/playerctl -i firefox play-pause";
        }
        {
            key = "XF86AudioNext";
            program = "${pkgs.playerctl}/bin/playerctl -i firefox next";
        }
        {
            key = "XF86AudioPrev";
            program = "${pkgs.playerctl}/bin/playerctl -i firefox previous";
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
            mod = [
                "Mod4"
                "Shift"
            ];
            key = "s";
            program = "systemctl poweroff";
            overlay-title = "Shutdown";
        }

        # Reboot
        {
            mod = [
                "Mod4"
                "Ctrl"
                "Shift"
            ];
            key = "r";
            program = "systemctl reboot";
            overlay-title = "Reboot";
        }

        # Open terminal
        {
            mod = [ "Mod4" ];
            key = "Return";
            program = "alacritty";
            overlay-title = "Open terminal window";
        }

        # Start firefox
        {
            mod = [
                "Mod4"
                "Shift"
            ];
            key = "f";
            program = "firefox";
            overlay-title = "Launch firefox";
        }
        {
            key = "XF86HomePage";
            program = "firefox";
            overlay-title = "Launch firefox";
        }

        # Start firefox in private window
        {
            mod = [
                "Mod4"
                "Ctrl"
                "Shift"
            ];
            key = "f";
            program = "firefox --private-window";
            overlay-title = "Launch firefox private window";
        }

        # Start jellyfin media player
        {
            mod = [ "Mod4" ];
            key = "kp_0";
            program = "flatpak run com.github.iwalton3.jellyfin-media-player";
            overlay-title = "Launch jellyfin media player";
        }

        # Start FreeTube
        {
            mod = [ "Mod4" ];
            key = "kp_1";
            program = "freetube";
            overlay-title = "Launch FreeTube";
        }

        # Open file browser
        {
            mod = [ "Mod4" ];
            key = "kp_2";
            program = "nemo";
            overlay-title = "Launch file browser";
        }

        # Open Steam
        {
            mod = [ "Mod4" ];
            key = "kp_5";
            program = "steam --no-minimize-to-tray";
            overlay-title = "Launch Steam";
        }
    ];

    keybindings-multi = [
        # Toggle open rofi
        {
            mod = [ "Mod4" ];
            key = "d";
            program = "pkill rofi || rofi -show";
            overlay-title = "Open rofi";
        }
    ];

    monitors = {
        outputs = [
            {
                adaptive_sync = "on";
                bg_style = "fill";
                name = main-monitor;
                height = 1440;
                refreshRate = 144;
                transform = 0;
                width = 2560;
                workspaces = [
                    "1"
                    "2"
                    "3"
                    "4"
                    "5"
                ];
                x = 0;
                y = 240;
                wallpaper = "mpvpaper";
            }
            {
                adaptive_sync = "off";
                bg_style = "fill";
                name = secondary-monitor;
                height = 1080;
                refreshRate = 60;
                transform = 90;
                width = 1920;
                workspaces = [
                    "6"
                    "7"
                    "8"
                    "9"
                    "10"
                ];
                x = 2560;
                y = 0;
                wallpaper = "swww";
            }
        ];
        primary = main-monitor;
    };

    nix = {
        gc = {
            automatic = true;
            dates = "daily";
            options = "--delete-older-than 7d";
        };
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
        ngb = {
            enable = true;
            settings = {
                bars = [
                    {
                        "output" = main-monitor;
                        "widgets" = {
                            "center" = [ ];
                            "left" = [
                                {
                                    "config" = {
                                        "monitor" = main-monitor;
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
                                        "interface" = "vlan20";
                                    };
                                    "module" = "network";
                                }
                                {
                                    "config" = { };
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
                        "output" = secondary-monitor;
                        "widgets" = {
                            "center" = [ ];
                            "left" = [
                                {
                                    "config" = {
                                        "monitor" = secondary-monitor;
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
                                    "config" = { };
                                    "module" = "headset";
                                }
                                {
                                    "config" = { };
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
                "corner_radius" = 15;
                "gaps" = config.gaps;
                "height" = 25;
                "layer" = "top";
                "icon_size" = 20;
                "spacing" = 5;
            };
        };
    };

    workspaces = [
        {
            name = "1";
            programs = [
                {
                    name = "Alacritty";
                    focus = true;
                }
                {
                    name = "kitty";
                    focus = true;
                }
            ];
        }
        {
            name = "2";
            programs = [
                {
                    name = "chromium-browser";
                    focus = true;
                }
                {
                    name = "firefox";
                    focus = true;
                }
                {
                    name = "floorp";
                    focus = true;
                }
            ];
        }
        {
            name = "3";
            programs = [
                {
                    name = "FreeTube";
                    focus = true;
                }
            ];
        }
        {
            name = "4";
            programs = [
                { name = ".virt-manager-wrapped"; }
            ];
        }
        {
            name = "5";
            programs = [
                { name = "com.usebottles.bottles"; }
                { name = "gamescope"; }
                { name = "heroic"; }
                { name = "lutris"; }
                { name = "steam"; }
                { name = "pcsx2-qt"; }
            ];
        }
        {
            name = "6";
            programs = [ ];
        }
        {
            name = "7";
            programs = [
                { name = "chatterino"; }
                { name = "com.chatterino.chatterino"; }
                { name = "discord"; }
                { name = "Keybase"; }
                { name = "vesktop"; }
            ];
        }
        {
            name = "8";
            programs = [ ];
        }
        {
            name = "9";
            programs = [
                { name = "org.freedesktop.ryuukyu.Helvum"; }
                { name = "pavucontrol"; }
            ];
        }
        {
            name = "10";
            programs = [
                {
                    name = "codium";
                    focus = true;
                }
            ];
        }
    ];

    xdg = {
        desktopEntries = {
            Alacritty = {
                exec = "${config.programs.alacritty.package}/bin/alacritty";
                icon = "alacritty";
                name = "alacritty";
                noDisplay = true;
            };
            "amdgpu_top" = {
                name = "AMDGPU TOP";
                noDisplay = true;
            };
            "amdgpu_top-tui" = {
                name = "AMDGPU TOP";
                noDisplay = true;
            };
            btop = {
                exec = "${config.programs.btop.package}/bin/btop";
                icon = "btop";
                name = "btop";
                noDisplay = true;
            };
            kitty = {
                exec = "${config.programs.kitty.package}/bin/kitty";
                icon = "kitty";
                name = "kitty";
                noDisplay = true;
            };
            mpv = {
                exec = "${config.programs.mpv.package}/bin/mpv";
                icon = "mpv";
                name = "mpv";
                noDisplay = true;
            };
            steam = {
                name = "Steam";
                comment = "Application for managing and playing games on Steam";
                exec = "steam %U --no-minimize-to-tray";
                icon = "steam";
                terminal = false;
                type = "Application";
                categories = [
                    "Network"
                    "FileTransfer"
                    "Game"
                ];
                mimeType = [
                    "x-scheme-handler/steam"
                    "x-scheme-handler/steamlink"
                ];
            };
        };
        enable = true;
        mimeApps = {
            enable = true;
            defaultApplications = {
                "application/pdf" = browser;
                "audio/flac" = media_player;
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
