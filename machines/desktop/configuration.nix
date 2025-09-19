{ pkgs, ... }:
{
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
                enable = true;
                theme = "${pkgs.catppuccin-grub}";
                useOSProber = true;
            };
            systemd-boot = {
                enable = false;
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
        "/home/emil/docker-compose" = {
            device = "172.16.0.12:/nfs/docker/compose";
            fsType = "nfs4";
            options = [
                "rw"
                "x-systemd.automount"
                "noauto"
            ];
        };
        "/home/emil/Manga" = {
            device = "172.16.0.12:/nfs/Manga";
            fsType = "nfs4";
            options = [
                "rw"
                "x-systemd.automount"
                "noauto"
            ];
        };
        "/home/emil/Media" = {
            device = "172.16.0.12:/nfs/Media";
            fsType = "nfs4";
            options = [
                "rw"
                "x-systemd.automount"
                "noauto"
            ];
        };
        "/home/emil/roms" = {
            device = "172.16.0.12:/nfs/ROMS";
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
        "/home/emil/Winrepos/java" = {
            device = "/home/emil/repos/D0018D";
            fsType = "none";
            options = [
                "bind"
            ];
        };
        "/home/emil/Winrepos/net" = {
            device = "/home/emil/repos/2IS225";
            fsType = "none";
            options = [
                "bind"
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
        # Disable Intel SGX
        cpu = {
            intel = {
                sgx = {
                    provision = {
                        enable = false;
                    };
                };
            };
        };
        # Hardware accelerating
        graphics = {
            enable = true;
            enable32Bit = true;
            extraPackages = with pkgs; [
                intel-media-driver
                intel-vaapi-driver
                rocmPackages.clr.icd
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
        defaultLocale = "en_DK.UTF-8";
    };

    # Network settings
    networking = {
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
        hostName = "desktop";
        usePredictableInterfaceNames = false;
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
        steam = {
            enable = true;
            gamescopeSession = {
                args = [
                    "-H 1440"
                    "-h 720"
                    "-S integer"
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

    # Settings used for polkit
    security = {
        pam = {
            services = {
                gtklock = { };
                hyprlock = { };
                login = {
                    u2fAuth = true;
                };
                sudo = {
                    u2fAuth = true;
                };
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
            autologinUser = "emil";
        };
        gnome = {
            gnome-keyring = {
                enable = true;
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
        tlp = {
            enable = true;
            settings = {
                CPU_BOOST_ON_AC = "1";
                CPU_DRIVER_OPMODE_ON_AC = "active";
                CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
                CPU_HWP_DYN_BOOST_ON_AC = "1";
                CPU_MAX_PERF_ON_AC = "100";
                CPU_MIN_PERF_ON_AC = "0";
                CPU_SCALING_GOVERNOR_ON_AC = "performance";
                NMI_WATCHDOG = "1";
                RADEON_DPM_PERF_LEVEL_ON_AC = "high";
                RADEON_DPM_STATE_ON_AC = "performance";
                START_CHARGE_THRESH_BAT0 = "75";
                STOP_CHARGE_THRESH_BAT0 = "80";
            };
        };
        udev = {
            enable = true;
            packages = [
                pkgs.android-udev-rules
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
        timeZone = "Europe/Stockholm";
    };

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users = {
        groups = {
            emil = {
                gid = 1000;
            };
        };
        users = {
            emil = {
                extraGroups = [
                    "wheel"
                    "video"
                    "docker"
                    "users"
                    "libvirtd"
                    "kvm"
                    "adbusers"
                ]; # Enable ‘sudo’ for the user.
                group = "emil";
                isNormalUser = true;
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
