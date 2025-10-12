{ pkgs, sharedSettings, ... }:
{

    # Set bootloader config
    boot = {
        initrd = {
            luks = {
                devices = {
                    "encrypted" = {
                        device = "/dev/disk/by-label/encrypted";
                    };
                };
            };
            systemd = {
                enable = true;
            };
        };
        kernelParams = [
            "quiet"
        ];
        loader = {
            efi = {
                canTouchEfiVariables = true;
            };
            grub = {
                device = "nodev";
                efiSupport = true;
                enable = true;
                useOSProber = true;
            };
            systemd-boot = {
                enable = false;
            };
        };
        # Settings for plymouth splash screen
        plymouth = {
            enable = true;
        };
    };

    console = {
        keyMap = "sv-latin1";
    };

    documentation = {
        doc = {
            enable = false;
        };
    };

    # System pakages to install
    environment = {
        systemPackages = with pkgs; [
            dnsutils
            file
            git
            htop
            intel-gpu-tools
            libnotify
            libva-utils
            nano
            p7zip
            pulseaudio
            unrar
            unzip
            usbutils
            xdg-utils
            zip
        ];
    };

    fileSystems = {
        "/" = {
            device = "/dev/disk/by-label/ROOT";
            fsType = "ext4";
        };
        "/boot" = {
            device = "/dev/disk/by-label/BOOT";
            fsType = "vfat";
            options = [ "umask=0077" ];
        };
    };

    # Set fonts to install
    fonts = {
        fontDir = {
            decompressFonts = true;
            enable = true;
        };
        packages = with pkgs; [
            freefont_ttf
            monaspace
            nerd-fonts.monaspace
            nerd-fonts.noto
            noto-fonts
            noto-fonts-cjk-sans
            noto-fonts-emoji
            openmoji-black
            openmoji-color
        ];
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
        # Driver for drawing tablet
        opentabletdriver = {
            daemon = {
                enable = true;
            };
            enable = true;
        };
        # Drivers for Xbox Series X|S controller
        xpadneo = {
            enable = true;
        };
    };

    # Select internationalisation properties.
    i18n = {
        defaultLocale = sharedSettings.locale;
    };

    # Network settings
    networking = {
        enableIPv6 = false;
        hostName = "laptop";
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
            enable = false;
        };
        usePredictableInterfaceNames = false;
        wireless = {
            enable = true;
            networks = { };
        };
    };

    # Set expreimental flags to use flakes
    nix = {
        gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 7d";
        };
        settings = {
            experimental-features = [
                "nix-command"
                "flakes"
            ];
        };
    };

    nixpkgs = {
        config = {
            allowUnfree = true;
        };
    };

    # Programs to enable
    programs = {
        dconf = {
            enable = true;
        };
        gamemode = {
            enable = true;
        };
        gamescope = {
            enable = true;
        };
        gnupg = {
            agent = {
                enable = true;
                enableSSHSupport = true;
            };
        };
        light = {
            enable = true;
        };
        steam = {
            enable = true;
            gamescopeSession = {
                args = [
                    "-h 720"
                    "-f"
                    "--filter linear"
                    "--force-grab-cursor"
                ];
                enable = true;
            };
        };
        virt-manager = {
            enable = true;
        };
    };

    security = {
        pam = {
            services = {
                hyprlock = { };
                swaylock = { };
            };
        };
        polkit = {
            enable = true;
        };
        rtkit = {
            enable = true;
        };
    };

    # Settings for system services
    services = {
        dbus = {
            enable = true;
        };
        flatpak = {
            enable = true;
        };
        getty = {
            autologinUser = sharedSettings.userName;
        };
        gnome = {
            gnome-keyring = {
                enable = true;
            };
        };
        logind = {
            extraConfig = ''
                HandleLidSwitch=ignore
            '';
            lidSwitch = "ignore";
            lidSwitchDocked = "ignore";
            lidSwitchExternalPower = "ignore";
        };
        pcscd = {
            enable = true;
        };
        pipewire = {
            alsa = {
                enable = false;
                support32Bit = false;
            };
            enable = true;
            pulse = {
                enable = true;
            };
        };
        tlp = {
            enable = true;
            settings = {
                CPU_BOOST_ON_AC = "1";
                CPU_BOOST_ON_BAT = "0";
                CPU_DRIVER_OPMODE_ON_AC = "passive";
                CPU_DRIVER_OPMODE_ON_BAT = "passive";
                CPU_SCALING_GOVERNOR_ON_AC = "performance";
                CPU_SCALING_GOVERNOR_ON_BAT = "schedutil";
                CPU_SCALING_MAX_FREQ_ON_AC = "2600000";
                CPU_SCALING_MAX_FREQ_ON_BAT = "2600000";
                CPU_SCALING_MIN_FREQ_ON_AC = "800000";
                CPU_SCALING_MIN_FREQ_ON_BAT = "800000";
                DEVICES_TO_DISABLE_ON_LAN_CONNECT = "wifi";
                DEVICES_TO_ENABLE_ON_LAN_CONNECT = "wifi";
                START_CHARGE_THRESH_BAT0 = "75";
                STOP_CHARGE_THRESH_BAT0 = "80";
            };
        };
        udisks2 = {
            enable = true;
        };
        upower = {
            enable = true;
        };
    };

    system = {
        # This value determines the NixOS release from which the default
        # settings for stateful data, like file locations and database versions
        # on your system were taken. It's perfectly fine and recommended to leave
        # this value at the release version of the first install of this system.
        # Before changing this value read the documentation for this option
        # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
        stateVersion = "23.05"; # Did you read the comment?
    };

    systemd = {
        extraConfig = ''
            DefaultTimeoutStopSec=10s
        '';
        # Settings to get polkit working
        user = {
            services = {
                polkit-mate-authentication-agent-1 = {
                    after = [ "graphical-session.target" ];
                    description = "polkit-mate-authentication-agent-1";
                    serviceConfig = {
                        ExecStart = "${pkgs.mate.mate-polkit}/libexec/polkit-mate-authentication-agent-1";
                        Restart = "on-failure";
                        RestartSec = 1;
                        TimeoutStopSec = 10;
                        Type = "simple";
                    };
                    wantedBy = [ "graphical-session.target" ];
                    wants = [ "graphical-session.target" ];
                };
            };
        };
    };

    # Set your time zone.
    time = {
        timeZone = sharedSettings.timeZone;
    };

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users = {
        groups = {
            "${sharedSettings.userName}" = {
                gid = sharedSettings.groupId;
            };
        };
        users = {
            "${sharedSettings.userName}" = {
                extraGroups = [
                    "wheel"
                    "video"
                    "docker"
                    "users"
                    "libvirtd"
                ]; # Enable ‘sudo’ for the user.
                group = sharedSettings.userName;
                isNormalUser = true;
            };
        };
    };

    virtualisation = {
        docker = {
            daemon = {
                settings = {
                    dns = [
                        "1.1.1.1"
                        "1.0.0.1"
                    ];
                };
            };
            enable = true;
        };
        libvirtd = {
            enable = true;
        };
    };

    xdg = {
        portal = {
            config = {
                common = {
                    default = [
                        "gtk"
                    ];
                };
            };
            enable = true;
            extraPortals = [
                pkgs.xdg-desktop-portal-gtk
            ];
        };
    };

    # Settings for zRam
    zramSwap = {
        enable = true;
        memoryPercent = 75;
    };
}
