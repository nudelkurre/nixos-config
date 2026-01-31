{
    pkgs,
    config,
    sharedSettings,
    ...
}:
{
    boot = {
        blacklistedKernelModules = [
            "k10temp"
        ];
        extraModulePackages = with config.boot.kernelPackages; [
            v4l2loopback
            zenpower
        ];
        extraModprobeConfig = ''
            options v4l2loopback devices=1 video_nr=1 card_label="OBS CAM" exclusive_caps=1
        '';
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
            "nosgx"
            "quiet"
        ];
        loader = {
            efi = {
                canTouchEfiVariables = true;
            };
            grub = {
                device = "nodev";
                efiSupport = true;
                enable = false;
                theme = "${pkgs.catppuccin-grub}";
                useOSProber = true;
            };
            systemd-boot = {
                configurationLimit = 10;
                editor = false;
                enable = true;
                memtest86 = {
                    enable = true;
                };
            };
        };
        # Settings for plymouth splash screen
        plymouth = {
            enable = true;
            theme = "catppuccin-frappe";
            themePackages = [
                (pkgs.catppuccin-plymouth.override {
                    variant = "frappe";
                })
            ];
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

    # System packages to install
    environment = {
        systemPackages = with pkgs; [
            amdgpu_top
            dnsutils
            file
            git
            headsetcontrol
            libnotify
            libva-utils
            nano
            p7zip
            pulseaudio
            sops
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
        "/home/emil/docker-compose" = {
            device = "${sharedSettings.serverIP}:/nfs/docker/compose";
            fsType = "nfs4";
            options = [
                "rw"
                "x-systemd.automount"
                "noauto"
            ];
        };
        "/home/emil/Manga" = {
            device = "${sharedSettings.serverIP}:/nfs/Manga";
            fsType = "nfs4";
            options = [
                "rw"
                "x-systemd.automount"
                "noauto"
            ];
        };
        "/home/emil/Media" = {
            device = "${sharedSettings.serverIP}:/nfs/Media";
            fsType = "nfs4";
            options = [
                "rw"
                "x-systemd.automount"
                "noauto"
            ];
        };
        "/home/emil/roms" = {
            device = "${sharedSettings.serverIP}:/nfs/ROMS";
            fsType = "nfs4";
            options = [
                "rw"
                "x-systemd.automount"
                "noauto"
            ];
        };
        "/home/emil/tmp" = {
            fsType = "tmpfs";
            options = [
                "rw"
                "size=10G"
                "nodev"
                "nosuid"
                "noexec"
                "uid=1000"
                "gid=1000"
            ];
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
            noto-fonts-color-emoji
            openmoji-black
            openmoji-color
        ];
    };

    hardware = {
        amdgpu = {
            initrd = {
                enable = true;
            };
        };
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
            enable32Bit = true;
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
        enableIPv6 = sharedSettings.enableIPv6;
        firewall = {
            enable = true;
            allowedTCPPorts = [
                1716 # KDE Connect
            ];
            allowedUDPPorts = [
                1716 # KDE Connect
            ];
        };
        hostName = "desktop";
        interfaces = {
            "eth0" = {
                useDHCP = false;
            };
            "vlan20" = {
                useDHCP = true;
            };
        };
        tempAddresses = if config.networking.enableIPv6 then "enabled" else "disabled";
        usePredictableInterfaceNames = false;
        vlans = {
            "vlan20" = {
                id = 20;
                interface = "eth0";
            };
        };
    };

    # Set expreimental flags to use flakes
    nix = {
        gc = {
            automatic = true;
            dates = "daily";
            options = "--delete-older-than 7d";
        };
        settings = {
            experimental-features = [
                "nix-command"
                "flakes"
            ];
            substituters = [
                "https://cache.nixos.org/"
                "https://nix-community.cachix.org"
            ];
            trusted-public-keys = [
                "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
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
        adb = {
            enable = true;
        };
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
        hyprland = {
            enable = false;
        };
        niri = {
            enable = true;
        };
        regreet = {
            cursorTheme = {
                name = "Bibata-Modern-Ice";
                package = pkgs.bibata-cursors;
            };
            enable = true;
            font = {
                name = "MonaspiceRn Nerd Font Mono";
                size = 16;
            };
            settings = {
                commands = {
                    reboot = [
                        "systemctl"
                        "reboot"
                    ];
                    poweroff = [
                        "systemctl"
                        "poweroff"
                    ];
                };
                widget.clock = {
                    format = "%A %Y-%m-%d %H:%M:%S";
                    resolution = "500ms";
                    timezone = sharedSettings.timeZone;
                };
            };
            theme = {
                name = "Colloid-Pink-Dark-Compact-Catppuccin";
                package = pkgs.unstable.colloid-gtk-theme.override {
                    themeVariants = [ "pink" ];
                    colorVariants = [ "dark" ];
                    sizeVariants = [ "compact" ];
                    tweaks = [ "catppuccin" ];
                };
            };
        };
        steam = {
            enable = true;
            gamescopeSession = {
                args = [
                    "--output-height 1440" # Monitor resolution
                    "--nested-height 1440" # Game Resolution
                    "--scaler integer"
                    "--fullscreen"
                    "--filter fsr"
                    "--force-grab-cursor"
                ];
                enable = true;
            };
        };
        sway = {
            enable = true;
            extraPackages = [ ];
        };
        virt-manager = {
            enable = true;
        };
        zsh = {
            enable = true;
        };
    };

    # Settings used for polkit
    security = {
        pam = {
            services = {
                gtklock = { };
                greetd = {
                    u2fAuth = false;
                };
                hyprlock = { };
                login = {
                    u2fAuth = true;
                };
                sudo = {
                    u2fAuth = true;
                };
                swaylock = { };
            };
            u2f = {
                enable = true;
                settings = {
                    authfile = sharedSettings.u2f.authFile;
                    cue = true;
                    interactive = false;
                    origin = sharedSettings.u2f.origin;
                };
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
        fwupd = {
            enable = true;
        };
        gnome = {
            gnome-keyring = {
                enable = true;
            };
        };
        greetd = {
            enable = true;
            settings = {
                default_session = {
                    command = "${pkgs.cage}/bin/cage -s -- ${pkgs.regreet}/bin/regreet";
                };
            };
        };
        logind = {
            settings = {
                Login = {
                    HandleHibernateKey = "ignore";
                    HandleHibernateKeyLongPress = "ignore";
                    HandlePowerKey = "ignore";
                    HandlePowerKeyLongPress = "ignore";
                    HandleRebootKey = "ignore";
                    HandleRebootKeyLongPress = "ignore";
                    HandleSuspendKey = "ignore";
                    HandleSuspendKeyLongPress = "ignore";
                };
            };
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
            extraConfig = {
                pipewire = {
                    "91-null-sinks" = {
                        "context.objects" = [
                            {
                                factory = "adapter";
                                args = {
                                    "factory.name" = "support.null-audio-sink";
                                    "node.name" = "Null Output";
                                    "node.description" = "Null Output";
                                    "media.class" = "Audio/Sink";
                                    "audio.position" = "FL,FR";
                                };
                            }
                        ];
                    };
                };
            };
            pulse = {
                enable = true;
            };
        };
        udev = {
            enable = true;
            packages = [
                pkgs.headsetcontrol
            ];
        };
        udisks2 = {
            enable = true;
        };
        upower = {
            enable = true;
        };
        xserver = {
            displayManager = {
                lightdm.enable = false;
            };
            enable = false;
            videoDrivers = [ "amdgpu" ];
        };
    };

    sops = {
        age = {
            generateKey = true;
            keyFile = "/home/${sharedSettings.userName}/.config/sops/age/keys.txt";
            sshKeyPaths = [ "/home/${sharedSettings.userName}/.ssh/id_ed25519" ];
        };
        defaultSopsFile = ../../secrets/secrets.yaml;
        defaultSopsFormat = "yaml";

        secrets = {
            "wg-quick/desktop/private_key" = { };
            "wg-quick/desktop/preshared_key" = { };
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
        settings = {
            Manager = {
                DefaultTimeoutStopSec = "10s";
            };
        };
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
                    "kvm"
                    "adbusers"
                ]; # Enable ‘sudo’ for the user.
                group = "${sharedSettings.userName}";
                isNormalUser = true;
                shell = pkgs.zsh;
            };
        };
    };

    virtualisation = {
        docker = {
            enable = false;
            rootless = {
                daemon = {
                    settings = {
                        dns = [
                            "1.1.1.1"
                            "1.0.0.1"
                        ];
                    };
                };
                enable = true;
                setSocketVariable = true;
            };
        };
        libvirtd = {
            enable = true;
            qemu = {
                vhostUserPackages = [
                    pkgs.virtiofsd
                ];
            };
        };
        spiceUSBRedirection = {
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
