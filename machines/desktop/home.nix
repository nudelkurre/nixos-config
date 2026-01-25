{
    pkgs,
    config,
    sharedSettings,
    ...
}:
let
    # Set default programs to be used by mimetypes and keybindings
    browser = "firefox";
    image_viewer = "imv-dir";
    media_player = "mpv";
    text_editor = "codium";
    file_browser = "nemo";

    main-monitor = "DP-1";
    secondary-monitor = "HDMI-A-1";
in
{
    desktop = {
        corner-radius = 15;
        gaps = 5;
    };
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

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    home = {
        file = {
            pokemon-dl = {
                source = pkgs.writeShellScript "pokemon-dl" ''
                    ${pkgs.yt-dlp}/bin/yt-dlp --output "%(playlist_index)s_%(title)s.%(ext)s" --restrict-filenames --format "bv[height<=720][vcodec~='^((he|a)vc|h26[45])']+mergeall[language~='(en|sv)'][acodec='opus'][abr>=100][format_id!$=-drc]" --audio-multistreams --embed-chapters --embed-metadata --extractor-args "youtube:player-client=default,-tv_simply" $@
                '';
                target = "${config.home.homeDirectory}/.local/bin/pokemon-dl";
            };
            scale-video = {
                source = pkgs.writeShellScript "scale-video" ''
                    ${pkgs.ffmpeg}/bin/ffmpeg -i $1 -an -b:v 4M -vf "scale=1920:1080,setsar=1:1" $(echo $1 | cut -d "." -f1)_1080.mp4
                '';
                target = "${config.home.homeDirectory}/.local/bin/scale-video";
            };
        };
        homeDirectory = "/home/${sharedSettings.userName}";
        packages = with pkgs; [
            bitwarden-desktop
            mypkgs.pkg2zip
            socat
            texliveMedium
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
            program = "${pkgs.playerctl}/bin/playerctl -i ${browser} play-pause";
        }
        {
            key = "XF86AudioNext";
            program = "${pkgs.playerctl}/bin/playerctl -i ${browser} next";
        }
        {
            key = "XF86AudioPrev";
            program = "${pkgs.playerctl}/bin/playerctl -i ${browser} previous";
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

        # Start browser
        {
            mod = [
                "Mod4"
                "Shift"
            ];
            key = "f";
            program = "${browser}";
            overlay-title = "Launch ${browser}";
        }
        {
            key = "XF86HomePage";
            program = "${browser}";
            overlay-title = "Launch ${browser}";
        }

        # Start browser in private window
        {
            mod = [
                "Mod4"
                "Ctrl"
                "Shift"
            ];
            key = "f";
            program = "${browser} --private-window";
            overlay-title = "Launch ${browser} private window";
        }

        # Start jellyfin media player
        {
            mod = [ "Mod4" ];
            key = "kp_0";
            program = "${pkgs.jellyfin-desktop}/bin/jellyfin-desktop";
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
            program = "${file_browser}";
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
        kdeconnect = {
            enable = true;
            indicator = true;
        };
        ngb = {
            enable = true;
            settings = {
                bars = [
                    {
                        "output" = main-monitor;
                        "widgets" = {
                            "center" = [
                                {
                                    "config" = {
                                        "hide_no_focus" = true;
                                        "timer" = 0.3;
                                    };
                                    "module" = "windowtitle";
                                }
                            ];
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
                                        "timer" = 0.3;
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
                                        "timer" = 0.3;
                                    };
                                    "module" = "workspace";
                                }
                            ];
                            "right" = [
                                {
                                    "config" = { };
                                    "module" = "bluetooth";
                                }
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
                                        "api" = "SMHI";
                                        "city" = "Västerås";
                                        "icon_size" = 20;
                                        "show_big_icon" = true;
                                    };
                                    "module" = "weather";
                                }
                                {
                                    "config" = {
                                        "api" = "YR";
                                        "city" = "Västerås";
                                        "icon_size" = 20;
                                        "show_big_icon" = true;
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
                "corner_radius" = config.desktop.corner-radius;
                "gaps" = config.desktop.gaps;
                "height" = 25;
                "layer" = "top";
                "icon_size" = 20;
                "spacing" = config.desktop.gaps;
            };
        };
    };

    sops = {
        age = {
            sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
        };
        defaultSopsFile = ../../secrets/secrets.yaml;
        secrets = {

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
                    name = "${browser}";
                    focus = true;
                }
                {
                    name = "floorp";
                    focus = true;
                }
                {
                    name = "org.jellyfin.JellyfinDesktop";
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
                {
                    name = "gamescope";
                    focus = true;
                }
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
            "amdgpu_top" = {
                name = "AMDGPU TOP";
                noDisplay = true;
            };
            "amdgpu_top-tui" = {
                name = "AMDGPU TOP";
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
                "application/pdf" = "${browser}.desktop";
                "audio/flac" = "${media_player}.desktop";
                "audio/mpeg" = "${media_player}.desktop";
                "audio/x-m4b" = "${media_player}.desktop";
                "audio/x-vorbis+ogg" = "${media_player}.desktop";
                "image/jpeg" = "${image_viewer}.desktop";
                "image/png" = "${image_viewer}.desktop";
                "inode/directory" = "${file_browser}.desktop";
                "text/html" = "${text_editor}.desktop";
                "text/x-python" = "${text_editor}.desktop";
                "video/mp4" = "${media_player}.desktop";
                "video/x-matroska" = "${media_player}.desktop";
                "x-scheme-handler/http" = "${browser}.desktop";
                "x-scheme-handler/https" = "${browser}.desktop";
                "x-scheme-handler/chrome" = "${browser}.desktop";
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
