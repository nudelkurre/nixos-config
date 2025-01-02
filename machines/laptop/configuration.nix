{config, pkgs, ...}:
{

    # Set bootloader config
    boot = {
        loader = {
            systemd-boot.enable = false;
            efi.canTouchEfiVariables = true;
            grub = {
                enable = true;
                device = "nodev";
                efiSupport = true;
                useOSProber = true;
            };
        };
        kernelParams = [
            "quiet"
            #"loglevel=0"
        ];
        initrd.systemd.enable = true;
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

        wireless = {
            enable = true;
            networks = {};
        };

        networkmanager = {
            enable = false;
        };
    };

    # Settings for system services
    services = {
        dbus.enable = true;
        getty.autologinUser = "emil";
        gnome.gnome-keyring.enable = true;
        flatpak.enable = true;
        logind = {
            lidSwitch = "ignore";
            lidSwitchDocked = "ignore";
            lidSwitchExternalPower = "ignore";
            extraConfig = ''
                HandleLidSwitch=ignore
            '';
        };
        tlp = {
            enable = true;
            settings = {
                START_CHARGE_THRESH_BAT0 = "75";
                STOP_CHARGE_THRESH_BAT0 = "80";

                CPU_DRIVER_OPMODE_ON_AC = "passive";
                CPU_DRIVER_OPMODE_ON_BAT = "passive";
                CPU_SCALING_GOVERNOR_ON_AC = "performance";
                CPU_SCALING_GOVERNOR_ON_BAT = "schedutil";
                CPU_SCALING_MIN_FREQ_ON_AC = "800000";
                CPU_SCALING_MAX_FREQ_ON_AC = "2600000";
                CPU_SCALING_MIN_FREQ_ON_BAT = "800000";
                CPU_SCALING_MAX_FREQ_ON_BAT = "2600000";
                CPU_BOOST_ON_AC = "1";
                CPU_BOOST_ON_BAT = "0";

                DEVICES_TO_DISABLE_ON_LAN_CONNECT = "wifi";
                DEVICES_TO_ENABLE_ON_LAN_CONNECT = "wifi";
            };
        };
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
        graphics = {
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

        dnsutils
        file
        git
        nano
        htop
        p7zip
        unrar
        unzip
        usbutils
        xdg-utils
        zip
    ];

    # Programs to enable
    programs = {
        dconf.enable = true;
        light.enable = true;
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
                    "-h 720"
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

    nixpkgs.config.allowUnfree = true;

    # Set expreimental flags to use flakes
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # Set your time zone.
    time.timeZone = "Europe/Stockholm";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";
    console = {
        keyMap = "sv-latin1";
    };

    # Settings for zRam
    zramSwap = {
        enable = true;
        memoryPercent = 75;
    };

    # Settings used for polkit
    security = {
        polkit.enable = true;
        rtkit.enable = true;
    }; 

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users = {
        users = {
            emil = {
                group = "emil";
                isNormalUser = true;
                extraGroups = [ "wheel" "video" "docker" "users" "libvirtd" ]; # Enable ‘sudo’ for the user.
                packages = with pkgs; [
                    
                ];
            };
        };
        groups = {
            emil = {
                gid = 1000;
            };
        };
    };

    # Set fonts to install
    fonts = {
        fontDir = {
            enable = true;
            decompressFonts = true;
        };
        packages = with pkgs; [
            freefont_ttf
            monaspace
            noto-fonts
            noto-fonts-cjk-sans
            noto-fonts-emoji
            openmoji-black
            openmoji-color
            (nerdfonts.override { fonts = [ "Noto" "Monaspace" ]; })
        ];
    };

    virtualisation = {
        docker = {
            enable = true;
            daemon = {
                settings = {
                    dns = [
                        "1.1.1.1"
                        "1.0.0.1"
                    ];
                };
            };
        };
        libvirtd = {
            enable = true;
        };
    };

    documentation = {
        doc.enable = false;
    };

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It's perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "23.05"; # Did you read the comment?
}