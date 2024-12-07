{ config, pkgs, ... }:

{
    # Home Manager needs a bit of information about you and the paths it should
    # manage.
    home.username = "emil";
    home.homeDirectory = "/home/emil";

    imports = [
        ./apps/alacritty.nix
        ./apps/chromium.nix
        ./apps/dunst.nix
        ./apps/eww/eww.nix
        ./apps/firefox.nix
        ./apps/gnome-keyring.nix
        ./apps/gtk.nix
        ./apps/hyprlock.nix
        ./apps/kitty/kitty.nix
        ./apps/mangohud.nix
        ./apps/mpv.nix
        ./apps/rofi.nix
        ./apps/syncthing.nix
        ./apps/swaylock.nix
        ./apps/vscodium.nix
        ./apps/wlsunset.nix

        ./cli-tools

        ./window-managers/hyprland.nix
        ./window-managers/sway.nix
    ];

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

    qt = {
        enable = true;
        platformTheme.name = "gtk";
    };

    rofi = {
        border-color = "#f3c8f3";
        lines = 13;
    };

    monitors = {
        primary = "LVDS-1";
        outputs = [
            {
                background = "${pkgs.mypkgs.wallpapers}/share/wallpapers/wallhaven-ne7jkw.jpg";
                bg_style = "fill";
                name = "LVDS-1";
                width = 1366;
                height = 768;
                refreshRate = 60;
                x = 0;
                y = 0;
                transform = 0;
                adaptive_sync = "off";
                workspaces = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" ];
            }
            {
                background = "${pkgs.mypkgs.wallpapers}/share/wallpapers/wallhaven-ne7jkw.jpg";
                bg_style = "fill";
                name = "HDMI-A-1";
                width = 1280;
                height = 720;
                refreshRate = 60;
                x = 1366;
                y = 0;
                transform = 0;
                adaptive_sync = "off";
                workspaces = [ "10" ];
            }
        ];
    };

    fonts = {
        name = "MonaspiceRn Nerd Font Mono";
        size = 13;
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
        icon-size = 16;
        bars = [
            {
                name = "main";
                id = 0;
                width = 1366;
                widgets = [
                    "(workspace :monitor \"LVDS-1\")"
                    "(spacer)"
                    "(disk :mountpoint \"/\")"
                    "(net :interface \"eth0\")"
                    "(net :interface \"wlan0\")"
                    "(volume)"
                    "(battery)"
                    "(time :tz \"Europe/Stockholm\")"
                ];
            }
            {
                name = "secondary";
                id = 1;
                width = 1280;
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
                {name ="Alacritty"; focus = true;}
                {name ="kitty"; focus = true;}
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
            programs = [
                {name = "codium";}
            ];
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
            programs = [  ];
        }
    ];

    xdg.userDirs = {
        enable = true;
        createDirectories = true;
    };

    services = {
        udiskie = {
            enable = true;
            automount = true;
            notify = true;
            tray = "never";
        };
    };

    # The home.packages option allows you to install Nix packages into your
    # environment.
    home.packages = with pkgs; [
        nemo
        mypkgs.freetube
        hyprpaper
        imv
        lm_sensors
        mate.mate-polkit
        pavucontrol
        wl-clipboard
    ];

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    home.file = {

    };

    home.sessionVariables = {
        EDITOR = "nano";
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
}
