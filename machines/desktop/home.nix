{
    pkgs,
    config,
    sharedSettings,
    ...
}:
let
    # Set default programs to be used by mimetypes and keybindings
    browser = sharedSettings.firefox-version;
    image_viewer = "imv-dir";
    media_player = "mpv";
    text_editor = "codium";
    file_browser = "nemo";
    pdf_viewer = "mupdf";

    main-monitor = "DP-1";
    secondary-monitor = "HDMI-A-1";
in
{
    desktop = {
        bookmarks = [
            "file:///home/emil/Downloads"
            "file:///mnt/docker-compose"
            "file:///mnt/Manga"
            "file:///mnt/Media"
            "file:///home/emil/repos"
            "file:///mnt/roms"
        ];
        borders = 4;
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
        size = 12;
    };

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    home = {
        file = {
            pokemon-dl = {
                source = pkgs.writeShellScript "pokemon-dl" ''
                    ${pkgs.yt-dlp}/bin/yt-dlp --output "%(playlist_index)s_%(title)s.%(ext)s" --restrict-filenames --format "bv[height<=720][vcodec~='^((he|a)vc|h26[45])']+mergeall[language~='(en|sv)'][acodec='opus'][abr>=100][format_id!$=-drc]" --audio-multistreams --embed-chapters --embed-metadata $@
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
            blender
            heroic
            krita
            unstable.mkvtoolnix
            mupdf
            mypkgs.pkg2zip
            pcsx2
            socat
            texliveMedium
        ];
        sessionVariables = {
            EDITOR = "nano";
            MANGADEXDL_CONFIG_ENABLED = "1";
            PATH = "$HOME/.local/bin:$PATH";
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
            program = "kitty";
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
            program = "jellyfin-desktop";
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
                y = 480;
                wallpaper = "awww";
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
                wallpaper = "awww";
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
                "font_size" = config.fonts.size;
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

    systemd.user = {
        services = {
            "pw-link" = {
                Install = {
                    WantedBy = [ "graphical-session.target" ];
                };
                Service =
                    let
                        input = "Null Output";
                        output = ["alsa_output.usb-SteelSeries_SteelSeries_Arctis_7-00.stereo-game" "alsa_output.pci-0000_30_00.6.analog-stereo"];
                        linkTemplate = s: ''
                            input_exist=$(${pkgs.pipewire}/bin/pw-link -i ${input})
                            output_exist=$(${pkgs.pipewire}/bin/pw-link -o ${s})
                            if [[ $input_exist && $output_exist ]]; then
                                ${pkgs.pipewire}/bin/pw-link "${input}:monitor_FL" "${s}:playback_FL"
                                ${pkgs.pipewire}/bin/pw-link "${input}:monitor_FR" "${s}:playback_FR"
                            fi
                        '';
                        unlinkTemplate = s: ''
                            input_exist=$(${pkgs.pipewire}/bin/pw-link -i ${input})
                            output_exist=$(${pkgs.pipewire}/bin/pw-link -o ${s})
                            if [[ $input_exist && $output_exist ]]; then
                                ${pkgs.pipewire}/bin/pw-link -d "${input}:monitor_FL" "${s}:playback_FL"
                                ${pkgs.pipewire}/bin/pw-link -d "${input}:monitor_FR" "${s}:playback_FR"
                            fi
                        '';
                    in
                    {
                        ExecStart = pkgs.writeShellScript "pw-link" (builtins.concatStringsSep "" (map linkTemplate output));
                        ExecStop = pkgs.writeShellScript "pw-unlink" (builtins.concatStringsSep "" (map unlinkTemplate output));
                        Type = "oneshot";
                        RemainAfterExit = true;
                        Restart = "on-failure";
                        RestartSec = "5";
                    };
                Unit = {
                    Description = "Link headset to null sink";
                };
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
                { name = "info.cemu.Cemu"; }
                { name = "org.ppsspp.PPSSPP"; }
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
        configFile = {
            # Force managing mimeapps.list via home manager
            "mimeapps.list" = {
                force = true;
            };
        };
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
            "org.kde.kdeconnect.nonplasma" = {
                name = "KDE Connect Indicator";
                exec = "${pkgs.kdePackages.kdeconnect-kde}/bin/kdeconnect-indicator";
                terminal = false;
                type = "Application";
                categories = [
                    "Qt"
                    "KDE"
                    "Network"
                ];
                noDisplay = true;
            };
            "org.kde.kdeconnect.sms" = {
                name = "KDE Connect SMS";
                exec = "${pkgs.kdePackages.kdeconnect-kde}/bin/kdeconnect-sms";
                terminal = false;
                type = "Application";
                categories = [
                    "Qt"
                    "KDE"
                    "Network"
                ];
                noDisplay = true;
            };
        };
        enable = true;
        mimeApps = {
            enable = true;
            defaultApplications = {
                "application/pdf" = "${pdf_viewer}.desktop";
                "audio/flac" = "${media_player}.desktop";
                "audio/mpeg" = "${media_player}.desktop";
                "audio/x-m4b" = "${media_player}.desktop";
                "audio/x-vorbis+ogg" = "${media_player}.desktop";
                "image/gif" = "${image_viewer}.desktop";
                "image/jpeg" = "${image_viewer}.desktop";
                "image/png" = "${image_viewer}.desktop";
                "image/x-xcursor" = "${image_viewer}.desktop";
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
                niri = {
                    default = [
                        "gtk"
                        "gnome"
                    ];
                };
                sway = {
                    default = [
                        "wlr"
                        "gtk"
                    ];
                };
            };
            enable = true;
            extraPortals = [
                pkgs.xdg-desktop-portal-gnome
                pkgs.xdg-desktop-portal-gtk
                pkgs.xdg-desktop-portal-wlr
            ];
            xdgOpenUsePortal = true;
        };
        userDirs = {
            createDirectories = true;
            enable = true;
            setSessionVariables = false;
        };
    };
}
