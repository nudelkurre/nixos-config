# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
    nixpkgs.config.allowUnfree = true;

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
    };

    # Set cpu governor to performance
    powerManagement = {
        cpuFreqGovernor = "performance";
    };

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

    # System packages to install
    environment.systemPackages = with pkgs; [
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
    ];

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

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It's perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "23.05"; # Did you read the comment?

}

