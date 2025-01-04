{ config, pkgs, lib, ... }:

{
    eww = {
        bars = [
            {
                id = "\"DP-1\"";
                name = "main";
                widgets = [
                    "(workspace :monitor \"DP-1\")"
                    "(spacer)"
                    "(disk :mountpoint \"/\")"
                    "(net :interface \"eth0\")"
                    "(volume)"
                    "(time :tz \"Europe/Stockholm\")"
                    "(tray)"
                ];
                width = 2560;
            }
            {
                id = "\"HDMI-A-1\"";
                name = "secondary";
                widgets = [
                    "(workspace :monitor \"HDMI-A-1\")"
                    "(spacer)"
                    "(headset)"
                    "(bt)"
                    "(cpu)"
                    "(weather :iconsize 25)"
                    "(time :tz \"Europe/Stockholm\")"
                ];
                width = 1080;
            }
        ];
        colors = {
            main = "rgb(153, 51, 153)";
            secondary = "rgba(107, 107, 107, 0.4)";
            text = "rgb(255,255,255)";
        };
        enable = true;
        icons = {
            font = "MonaspiceRn Nerd Font Propo";
            size = 20;
        };
        testing = true;
        widgets = [
            {
                id = "\"DP-1\"";
                modules = [
                    "(weather-widget :iconsize 100)"
                ];
                name = "weather";
                width = 20;
                x = 10;
                y = 10;
            }
        ];
    };

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
            nemo
            mypkgs.freetube
            seahorse
            hyprpaper
            imv
            kbfs
            keybase
            keybase-gui
            lm_sensors
            mypkgs.mangadex-downloader
            mate.mate-polkit
            nodejs_22
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


    imports = [
        ../../apps/desktop/alacritty.nix
        ../../apps/desktop/chromium.nix
        ../../apps/desktop/eww/eww.nix
        ../../apps/utils/dunst.nix
        ../../apps/desktop/firefox.nix
        ../../apps/utils/gnome-keyring.nix
        ../../apps/utils/gtk.nix
        ../../apps/utils/hyprlock.nix
        ../../apps/desktop/kitty/kitty.nix
        ../../apps/utils/mangohud.nix
        ../../apps/desktop/mpv.nix
        ../../apps/desktop/obs.nix
        ../../apps/desktop/rofi.nix
        ../../apps/utils/swaylock.nix
        ../../apps/utils/syncthing.nix
        ../../apps/desktop/vscodium.nix
        ../../apps/utils/wlsunset.nix

        ../../apps/cli-tools

        ../../apps/window-managers/hyprland.nix
        ../../apps/window-managers/sway.nix
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
        keybase = {
            enable = true;
        };
        kbfs = {
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
        mimeApps = {
            enable = true;
            defaultApplications = {
                "audio/x-m4b" = "mpv.desktop";
                "image/jpeg" = "imv-dir.desktop";
                "image/png" = "imv-dir.desktop";
                "inode/directory" = "nemo.desktop";
                "text/html" = "codium.desktop";
                "text/x-python" = "codium.desktop";
                "video/mp4" = "mpv.desktop";
                "video/x-matroska" = "mpv.desktop";
                "x-scheme-handler/http" = "firefox-esr-private.desktop";
                "x-scheme-handler/https" = "firefox-esr-private.desktop";
                "x-scheme-handler/chrome" = "firefox-esr-private.desktop";
            };
        };
        userDirs = {
            createDirectories = true;
            enable = true;
        };
    };
}
