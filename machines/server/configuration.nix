# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ pkgs, ... }:
let
    ip_addr = "10.10.0.12";
in
{
    # Set bootloader config
    boot = {
        initrd = {
            luks = {
                devices = {
                    "encrypted" = {
                        device = "/dev/disk/by-label/encrypted_root";
                        keyFile = "/key/key.bin";
                    };
                };
            };
            systemd = {
                enable = true;
                mounts = [
                    {
                        what = "/dev/disk/by-label/Key";
                        where = "/key";
                        type = "ext4";
                    }
                ];
            };
        };
        loader = {
            systemd-boot = {
                enable = false;
            };
            efi = {
                canTouchEfiVariables = false;
            };
            grub = {
                device = "nodev";
                efiSupport = false;
                enable = true;
                useOSProber = true;
            };
        };
        kernelParams = [
            "quiet"
        ];
    };

    console = {
        keyMap = "sv-latin1";
    };

    documentation = {
        doc = {
            enable = false;
        };
    };

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment = {
        etc = {
            crypttab = {
                text = ''
                    files /dev/disk/by-label/encrypted_files /etc/crypto.key
                '';
            };
        };
        systemPackages = with pkgs; [
            dnsutils
            file
            git
            lm_sensors
            nano
            htop
            p7zip
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
        "/nfs" = {
            device = "/dev/disk/by-label/files";
            fsType = "ext4";
        };
    };

    # Select internationalisation properties.
    i18n = {
        defaultLocale = "en_DK.UTF-8";
    };

    # networking.hostName = "nixos"; # Define your hostname.
    # Pick only one of the below networking options.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
    networking = {
        defaultGateway = "10.10.0.1";
        enableIPv6 = true;
        firewall = {
            enable = true;
            allowedTCPPorts = [
                80   # http
                443  # https
                2049 # NFSv4
                5900 # Spice virt-manager
                5901 # VNC virt-manager
            ];
            allowedUDPPorts = [
                53   # DNS
            ];
        };
        hostName = "server";
        hosts = {
            "${ip_addr}" = ["git.nudelkurre.com"];
        };
        interfaces = {
            vlan10 = {
                ipv4 = {
                    addresses = [
                        {
                            address = ip_addr;
                            prefixLength = 24;
                        }
                    ];
                };
            };
        };
        nameservers = [
            "1.1.1.1"
            "1.0.0.1"
        ];
        useDHCP = false;
        usePredictableInterfaceNames = false;
        vlans = {
            vlan10 = {
                id = 10;
                interface = "eth0";
            };
        };
    };

    # Set expreimental flags to use flakes
    nix = {
        gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 14d";
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

    # Settings used for polkit
    security = {
        polkit = {
            enable = true;
        };
        rtkit = {
            enable = true;
        };
    };

    # Enable the OpenSSH daemon.
    services = {
        nfs = {
            server = {
                enable = true;
                exports = ''
                    /nfs/docker/compose 10.20.0.0/24(rw,sync,no_subtree_check)
                    /nfs/ebooks 10.20.0.0/24(rw,sync,no_subtree_check)
                    /nfs/Manga  10.20.0.0/24(rw,sync,no_subtree_check)
                    /nfs/Media  10.20.0.0/24(rw,sync,no_subtree_check)
                    /nfs/ROMS   10.20.0.0/24(rw,sync,no_subtree_check)
                '';
            };
        };
        openssh = {
            enable = true;
        };
        tlp = {
            enable = true;
            settings = {
                CPU_SCALING_GOVERNOR_ON_AC = "schedutil";
                NMI_WATCHDOG = "1";
            };
        };
    };

    system = {
        # This option defines the first version of NixOS you have installed on this particular machine,
        # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
        #
        # Most users should NEVER change this value after the initial install, for any reason,
        # even if you've upgraded your system to a new NixOS release.
        #
        # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
        # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
        # to actually do that.
        #
        # This value being lower than the current NixOS release does NOT mean your system is
        # out of date, out of support, or vulnerable.
        #
        # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
        # and migrated your data accordingly.
        #
        # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
        stateVersion = "23.05"; # Did you read the comment?
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
                ]; # Enable ‘sudo’ for the user.
                group = "emil";
                isNormalUser = true;
                openssh = {
                    authorizedKeys = {
                        keys = [
                            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIINWKyIwExthLlL6WFZbnQCtiziwlMZxHB5XBuEYrsob emil@desktop"
                            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINCZWLXnhQrNgPPBvXKqHNmpupG3IHw7Bq4cJOa87fJA emil@laptop"
                        ];
                    };
                };
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

    # Settings for zRam
    zramSwap = {
        enable = true;
        memoryPercent = 75;
    };
}
