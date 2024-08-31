{config, pkgs, ...}:
{
    boot = {
        kernelParams = [
            "nosgx"
        ];
        # Settings for plymouth splash screen
        plymouth = {
            enable = true;
        };
    };

    # Network settings
    networking = {
        hostName = "desktop";

        usePredictableInterfaceNames = false;
        enableIPv6 = true;

        firewall = {
            enable = true;
            interfaces = {
                "eth0" = {
                    allowedTCPPorts = [
                        22000
                    ];
                };
            };
        };
    };

    # Settings for system services
    services = {
        dbus.enable = true;
        getty.autologinUser = "emil";
        gnome.gnome-keyring.enable = true;
        flatpak.enable = true;
        udisks2.enable = true;
        pipewire = {
            enable = true;
            alsa.enable = false;
            alsa.support32Bit = false;
            pulse.enable = true;
        };
        pcscd = {
            enable = true;
        };
        udev = {
            enable = true;
            packages = [
                pkgs.headsetcontrol
            ];
        };
        upower = {
            enable = true;
        };
        xserver = {
            enable = false;
            displayManager = {
                lightdm.enable = false;
            };
            videoDrivers = [ "amdgpu" ];
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
        # Disable Intel SGX
        cpu.intel.sgx.provision.enable = false;
        # Hardware accelerating
        opengl = {
            enable = true;
            extraPackages = with pkgs; [
                intel-vaapi-driver
                intel-media-driver
                rocmPackages.clr.icd
            ];
            driSupport = true;
            driSupport32Bit = true;
        };
        # Drivers for Xbox Series X|S controller
        xpadneo.enable = true;
    };

    # System pakages to install
    environment = {
        sessionVariables = {
            
        };
        systemPackages = with pkgs; [
            amdgpu_top
            headsetcontrol
            intel-gpu-tools
            libnotify
            libva-utils
            mesa-demos
            pulseaudio
        ];
    };

    # Programs to enable
    programs = {
        dconf.enable = true;
        gamemode = {
            enable = true;
        };
        gamescope = {
            enable = true;
        };
        gnupg.agent = {
            enable = true;
            enableSSHSupport = true;
        };
        steam = {
            enable = true;
            gamescopeSession = {
                enable = true;
                args = [
                    "-H 1440"
                    "-h 720"
                    "-S integer"
                    "-f"
                    "--filter linear"
                    "--force-grab-cursor"
                ];
            };
        };
        virt-manager = {
            enable = true;
        };
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