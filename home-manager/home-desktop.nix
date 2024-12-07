{ config, pkgs, lib, ... }:

{
    # Home Manager needs a bit of information about you and the paths it should
    # manage.
    home.username = "emil";
    home.homeDirectory = "/home/emil";

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    home.stateVersion = "23.05"; # Please read the comment before changing.

    # Allow to install unfree packages
    nixpkgs.config.allowUnfree = true;

    imports = [
        ./apps/alacritty.nix
        ./apps/chromium.nix
        ./apps/eww/eww.nix
        ./apps/dunst.nix
        ./apps/firefox.nix
        ./apps/gnome-keyring.nix
        ./apps/gtk.nix
        ./apps/hyprlock.nix
        ./apps/kitty/kitty.nix
        ./apps/mangohud.nix
        ./apps/mpv.nix
        ./apps/obs.nix
        ./apps/rofi.nix
        ./apps/swaylock.nix
        ./apps/syncthing.nix
        ./apps/vscodium.nix
        ./apps/wlsunset.nix

        ./cli-tools

        ./window-managers/hyprland.nix
        ./window-managers/sway.nix
    ];

    # The home.packages option allows you to install Nix packages into your
    # environment.
    home.packages = with pkgs; [
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
        wl-clipboard
    ];

    qt = {
        enable = true;
        platformTheme.name = "gtk3";
    };

    rofi = {
        border-color = "#f3c8f3";
        lines = 25;
    };

    monitors = {
        primary = "DP-1";
        outputs = [
            {
                background = "${pkgs.mypkgs.wallpapers}/share/wallpapers/wallhaven-z8xqqo.jpg";
                bg_style = "fill";
                name = "DP-1";
                width = 2560;
                height = 1440;
                refreshRate = 144;
                x = 0;
                y = 240;
                transform = 0;
                adaptive_sync = "on";
                workspaces = [ "1" "2" "3" "4" "5" ];
            }
            {
                background = "${pkgs.mypkgs.wallpapers}/share/wallpapers/wallhaven-qz2qld.jpg";
                bg_style = "fill";
                name = "HDMI-A-1";
                width = 1920;
                height = 1080;
                refreshRate = 60;
                x = 2560;
                y = 0;
                transform = 90;
                adaptive_sync = "off";
                workspaces = [ "6" "7" "8" "9" "10" ];
            }
        ];
    };

    fonts = {
        name = "MonaspiceRn Nerd Font Mono";
        size = 16;
        fontconfig = {
            enable = true;
            defaultFonts = {
                emoji = ["OpenMoji Color"];
                monospace = ["MonaspiceAr Nerd Font Mono"];
                sansSerif = ["MonaspiceAr Nerd Font"];
                serif = ["MonaspiceXe Nerd Font"];
            };
        };
    };

    eww = {
        enable = true;
        main-color = "rgb(153, 51, 153)";
        secondary-color = "rgba(107, 107, 107, 0.4)";
        text-color = "rgb(255,255,255)";
        icon-font = "MonaspiceRn Nerd Font Propo";
        icon-size = 20;
        bars = [
            {
                name = "main";
                id = 0;
                width = 2560;
                widgets = [
                    "(workspace :monitor \"DP-1\")"
                    "(spacer)"
                    "(disk :mountpoint \"/\")"
                    "(net :interface \"eth0\")"
                    "(volume)"
                    "(time :tz \"Europe/Stockholm\")"
                    "(tray)"
                ];
            }
            {
                name = "secondary";
                id = 1;
                width = 1080;
                widgets = [
                    "(workspace :monitor \"HDMI-A-1\")"
                    "(spacer)"
                    "(headset)"
                    "(bt)"
                    "(cpu)"
                    "(weather :iconsize 25)"
                    "(time :tz \"Europe/Stockholm\")"
                ];
            }
        ];
        widgets = [
            {
                name = "weather";
                id = 0;
                x = 10;
                y = 10;
                width = 20;
                modules = [
                    "(weather-widget :iconsize 100)"
                ];
            }
        ];
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
                {name = "firefox"; focus = true;}
                {name = "chromium-browser"; focus = true;}
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
                {name = "steam";}
                {name = "gamescope";}
                {name = "com.usebottles.bottles";}
                {name = "lutris";}
            ];
        }
        {
            name = "6";
            programs = [  ];
        }
        {
            name = "7";
            programs = [
                {name = "Keybase";}
                {name = "discord";}
                {name = "chatterino";}
                {name = "com.chatterino.chatterino";}
            ];
        }
        {
            name = "8";
            programs = [  ];
        }
        {
            name = "9";
            programs = [
                {name = "pavucontrol";}
                {name = "org.freedesktop.ryuukyu.Helvum";}
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
                "x-scheme-handler/http" = "firefox-esr-private.desktop";
                "x-scheme-handler/https" = "firefox-esr-private.desktop";
                "x-scheme-handler/chrome" = "firefox-esr-private.desktop";
                "image/jpeg" = "imv-dir.desktop";
                "image/png" = "imv-dir.desktop";
                "inode/directory" = "nemo.desktop";
                "text/x-python" = "codium.desktop";
                "text/html" = "codium.desktop";
                "video/mp4" = "mpv.desktop";
                "audio/x-m4b" = "mpv.desktop";
                "video/x-matroska" = "mpv.desktop";
            };
        };
        userDirs = {
            enable = true;
            createDirectories = true;
        };
    };

    services = {
        keybase.enable = true;
        kbfs.enable = true;
    };

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    home.file = {
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

    home.sessionVariables = {
        EDITOR = "nano";
        MANGADEXDL_CONFIG_ENABLED = "1";
        PATH = "$PATH:$HOME/.local/bin";
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
}
