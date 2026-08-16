{
    pkgs,
    lib,
    config,
    sharedSettings,
    ...
}:
let
    capitalize = str: if str == "" then "" else lib.strings.toUpper (builtins.substring 0 1 str) + lib.strings.toLower (builtins.substring 1 (builtins.stringLength str - 1) str);
in
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
            theme = "catppuccin-${config.theme.variant}";
            themePackages = [
                (pkgs.catppuccin-plymouth.override {
                    variant = config.theme.variant;
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

    fileSystems =
        let
            options = [
                "rw"
                "x-systemd.automount"
                "x-systemd.idle-timeout=600"
                "noauto"
            ];
        in
        {
            "/" = {
                device = "/dev/disk/by-label/ROOT";
                fsType = "ext4";
            };
            "/boot" = {
                device = "/dev/disk/by-label/BOOT";
                fsType = "vfat";
                options = [ "umask=0077" ];
            };
            "/mnt/docker-compose" = {
                device = "${sharedSettings.serverIP}:/nfs/docker/compose";
                fsType = "nfs4";
                options = options;
            };
            "/mnt/Manga" = {
                device = "${sharedSettings.serverIP}:/nfs/Manga";
                fsType = "nfs4";
                options = options;
            };
            "/mnt/Media" = {
                device = "${sharedSettings.serverIP}:/nfs/Media";
                fsType = "nfs4";
                options = options;
            };
            "/mnt/roms" = {
                device = "${sharedSettings.serverIP}:/nfs/ROMS";
                fsType = "nfs4";
                options = options;
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
            overdrive = {
                enable = true;
            };
        };
        bluetooth = {
            enable = true;
            powerOnBoot = true;
            settings = {
                General = {
                    Experimental = true;
                    ReverseServiceDiscovery = false;
                };
            };
        };
        firmware = [
            pkgs.linux-firmware
        ];
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
        uinput = {
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

    monitors = {
        outputs = [
            {
                adaptive_sync = "on";
                bg_style = "fill";
                name = "DP-1";
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
                name = "HDMI-A-1";
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
        primary = "DP-1";
    };

    # Network settings
    networking = {
        bridges = {
            br30 = {
                interfaces = [
                    "vlan30"
                ];
            };
        };
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
            vlan20 = {
                useDHCP = true;
            };
        };
        tempAddresses = if config.networking.enableIPv6 then "enabled" else "disabled";
        useDHCP = false;
        usePredictableInterfaceNames = false;
        vlans = {
            vlan20 = {
                id = 20;
                interface = "eth0";
            };
            vlan30 = {
                id = 30;
                interface = "eth0";
            };
        };
    };

    # Set expreimental flags to use flakes
    nix = {
        gc = {
            automatic = true;
            dates = "daily";
            options = "--delete-older-than 3d";
        };
        optimise = {
            automatic = true;
            dates = "daily";
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

    powerManagement = {
        enable = true;
        cpuFreqGovernor = "performance";
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
            args = [
                "--output-height 1440" # Monitor resolution
                "--nested-height 1440" # Game Resolution
                "--scaler integer"
                "--fullscreen"
                "--filter fsr"
                "--force-grab-cursor"
            ];
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
        localsend = {
            enable = true;
            openFirewall = true;
        };
        niri = {
            enable = true;
        };
        regreet = {
            cursorTheme = {
                name = "Afterglow-Recolored-Catppuccin-${capitalize config.theme.color.main}";
                package = pkgs.afterglow-cursors-recolored.override {
                    themeVariants = [ "Catppuccin" ];
                    catppuccinColorVariants = [ (capitalize config.theme.color.main) ];
                };
            };
            enable = true;
            font = {
                name = "MonaspiceRn Nerd Font Mono";
                size = 16;
            };
            settings = {
                background = {
                    path = "/etc/greetd/regreet-horizontal-bg";
                    fit = "Cover";
                };
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
                name = config.theme.gtk.name;
                package = config.theme.gtk.package;
            };
        };
        steam = {
            enable = true;
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
            packages = [
                pkgs.gcr
            ];
        };
        flatpak = {
            enable = true;
        };
        fwupd = {
            enable = false;
        };
        gnome = {
            gnome-keyring = {
                enable = true;
            };
        };
        greetd = {
            enable = true;
            settings = {
                default_session = 
                    let
                        outputs = lib.strings.concatStringsSep "\n" (
                            map (
                                m:
                                let
                                    resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}Hz";
                                in
                                if m.name == config.monitors.primary then ''
                                    output "${m.name}" {
                                        pos 0 0
                                        resolution ${resolution}
                                        transform ${toString m.transform}
                                    }
                                '' else ''
                                    output "${m.name}" {
                                        disable
                                        power on
                                    }
                                ''
                            ) (config.monitors.outputs)
                        );
                        swayConfig = pkgs.writeText "greetd-sway-config" ''
                            exec "${config.programs.regreet.package}/bin/regreet; swaymsg exit"
                            ${outputs}
                        '';
                    in
                    {
                    command = "${config.programs.sway.package}/bin/sway --config ${swayConfig}";
                };
            };
        };
        gvfs = {
            enable = true;
        };
        lact = {
            enable = true;
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
                            {
                                factory = "adapter";
                                args = {
                                    "factory.name" = "support.null-audio-sink";
                                    "node.name" = "Null Input";
                                    "node.description" = "Null Input";
                                    "media.class" = "Audio/Source/Virtual";
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
        sunshine = {
            applications = {
                apps = [
                    {
                        image-path = "desktop.png";
                        name = "Desktop";
                    }
                    {
                        auto-detach = true;
                        cmd = "${pkgs.heroic}/bin/heroic --console";
                        elevated = false;
                        exclude-global-prep-cmd = false;
                        exit-timeout = 5;
                        image-path = "${pkgs.fetchurl {
                            url = "https://cdn2.steamgriddb.com/grid/e022cb640ae8809689b66b0eb6464305.png";
                            hash = "sha256-S5FmpmHLK7tp0ikBq4D8Si1VjdzrKhdDhH1SuIZeDzo=";
                        }}";
                        name = "Heroic Game Launcher";
                        output = "";
                        wait-all = true;
                    }
                    {
                        auto-detach = true;
                        cmd = "${pkgs.pcsx2}/bin/pcsx2-qt -bigpicture -fullscreen";
                        elevated = false;
                        exclude-global-prep-cmd = false;
                        exit-timeout = 5;
                        image-path = "${pkgs.fetchurl {
                            url = "https://cdn2.steamgriddb.com/grid/96418198105e16f6674bf6d045180afc.png";
                            hash = "sha256-Vcp2NQsPbIqB83AwoCCJoRCyFBS+OyvixDWhT7oyc18=";
                        }}";
                        name = "PCSX2";
                        output = "";
                        wait-all = true;
                    }
                    {
                        auto-detach = true;
                        cmd = "${pkgs.ppsspp-sdl}/bin/ppsspp";
                        elevated = false;
                        exclude-global-prep-cmd = false;
                        exit-timeout = 5;
                        image-path = "${pkgs.fetchurl {
                            url = "https://cdn2.steamgriddb.com/grid/cf476046d346e8091393001a40a523dc.png";
                            hash = "sha256-kRSprQGxwambuxGyUhuFhKEMrO6+padfXdAh7xrOYmg=";
                        }}";
                        name = "PPSSPP";
                        output = "";
                        wait-all = true;
                    }
                    {
                        detached = [
                            "setsid ${config.programs.steam.package}/bin/steam steam://open/bigpicture"
                        ];
                        image-path = "${pkgs.fetchurl {
                            url = "https://cdn2.steamgriddb.com/grid/39c2966989c4f0091a99eef7f1d09c09.png";
                            hash = "sha256-YZmRA0mMU6Ez6PxskyNasCspGRMeduh+L7JzZ5NQE6I=";
                        }}";
                        name = "Steam Big Picture";
                        prep-cmd = [
                            {
                                do = "";
                                undo = "setsid ${config.programs.steam.package}/bin/steam steam://close/bigpicture";
                            }
                        ];
                    }
                ];
                env = {
                    PATH = "$(PATH):$(HOME)/.local/bin";
                };
            };
            enable = true;
            autoStart = true;
            openFirewall = true;
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

        defaultSopsFile = ../../secrets/desktop.yaml;
        defaultSopsFormat = "yaml";

        secrets = {
            
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
        services = {
            regreet-random-bg = {
                after = [ "basic.target" ];
                before = [
                    "greetd.service"
                    "graphical.target"
                ];
                description = "Create link to random wallpaper";
                serviceConfig = {
                    ExecStart = pkgs.writeShellScript "random-bg" ''
                        ln -sf $(find ${pkgs.mypkgs.wallpapers}/share/wallpapers/horizontal | grep -P '(png|jpg|jpeg)' | shuf -n 1) /etc/greetd/regreet-horizontal-bg
                        ln -sf $(find ${pkgs.mypkgs.wallpapers}/share/wallpapers/vertical | grep -P '(png|jpg|jpeg)' | shuf -n 1) /etc/greetd/regreet-vertical-bg
                    '';
                    ExecStop = pkgs.writeShellScript "clean-random-bg" ''
                        rm /etc/greetd/regreet-horizontal-bg
                        rm /etc/greetd/regreet-vertical-bg
                    '';
                    RemainAfterExit = "yes";
                    Type = "oneshot";
                };
                wantedBy = [ "multi-user.target" ];
            };
        };
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
                        ExecStart = "${pkgs.mate-polkit}/libexec/polkit-mate-authentication-agent-1";
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

    theme = {
        color = {
            main = "pink";
            secondary = "sky";
        };
        gtk = {
            size = "compact";
        };
        variant = "frappe";
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
                    "uinput"
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
