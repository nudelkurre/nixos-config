{config, pkgs, ...}:
{
    boot = {
        # Settings for plymouth splash screen
        plymouth = {
            enable = true;
        };
    };

    # Network settings
    networking = {
        hostName = "laptop";

        usePredictableInterfaceNames = false;
        enableIPv6 = false;

        firewall = {
            enable = true;
            interfaces = {
                "wlan0" = {
                    allowedTCPPorts = [
                        22000
                    ];
                };
            };
        };

        networkmanager = {
            enable = true;
            unmanaged = [
                "eth0"
            ];
        };
    };

    # Settings for system services
    services = {
        dbus.enable = true;
        getty.autologinUser = "emil";
        flatpak.enable = true;
        udisks2.enable = true;
        pipewire = {
            enable = true;
            alsa.enable = false;
            alsa.support32Bit = false;
            pulse.enable = true;
        };
        upower = {
            enable = true;
        };
    };

    systemd = {
        # Settings to get polkit working
        user.services.polkit-mate-authentication-agent-1 = {
            description = "polkit-mate-authentication-agent-1";
            wantedBy = [ "graphical-session.target" ];
            wants = [ "graphical-session.target" ];
            after = [ "graphical-session.target" ];
            serviceConfig = {
                Type = "simple";
                ExecStart = "${pkgs.mate.mate-polkit}/libexec/polkit-mate-authentication-agent-1";
                Restart = "on-failure";
                RestartSec = 1;
                TimeoutStopSec = 10;
            };
        };
        extraConfig = ''
            DefaultTimeoutStopSec=10s
        '';
    };

    hardware = {
        bluetooth = {
            enable = true;
            powerOnBoot = true;
            settings = {
                General = {
                    Experimental = true;
                };
            };
        };
        # Hardware accelerating
        opengl = {
            enable = true;
            extraPackages = with pkgs; [
                vaapiIntel
            ];
        };
    };

    # System pakages to install
    environment.systemPackages = with pkgs; [
        intel-gpu-tools
        libnotify
        libva-utils
        pulseaudio
    ];

    # Programs to enable
    programs = {
        dconf.enable = true;
        light.enable = true;
    };

    security = {
        pam = {
            services = {
                swaylock = {};
                hyprlock = {};
            };
        };
    };

    # Enable xdg-desktop-portal
    xdg.portal = {
        enable = true;
        config = {
            common = {
                default = [
                    "gtk"
                ];
            };
            sway = {
                default = [
                    "gtk"
                    "wlr"
                ];
            };
            hyprland = {
                default = [
                    "gtk"
                    "hyprland"
                ];
            };
        };
        wlr.enable = true;
        extraPortals = [
            pkgs.xdg-desktop-portal-hyprland
            pkgs.xdg-desktop-portal-gtk
        ];
        xdgOpenUsePortal = true;
    };
}