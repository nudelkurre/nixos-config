# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{

  # Set bootloader config
  boot = {
      loader = {
          systemd-boot.enable = false;
          efi.canTouchEfiVariables = false;
          grub = {
              enable = true;
              device = "nodev";
              efiSupport = false;
              useOSProber = true;
          };
      };
      kernelParams = [
          "quiet"
          #"loglevel=0"
      ];
      initrd.systemd.enable = true;
  };

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  networking = {
    hostName = "server";

    usePredictableInterfaceNames = false;
    enableIPv6 = true;

    firewall = {
      enable = true;
      allowedTCPPorts = [
        111
        2049
        4000
        4001
        4002
        20048
      ];
      allowedUDPPorts = [
        111
        2049
        4000
        4001
        4002
        20048
      ];
    };

    interfaces = {
      eth0 = {
        ipv4.addresses = [
          {
            address = "172.16.0.12";
            prefixLength = 24;
          }
        ];
      };
    };
    defaultGateway = "172.16.0.1";
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
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
              openssh.authorizedKeys.keys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIINWKyIwExthLlL6WFZbnQCtiziwlMZxHB5XBuEYrsob emil@desktop"
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINCZWLXnhQrNgPPBvXKqHNmpupG3IHw7Bq4cJOa87fJA emil@laptop"
              ];
          };
      };
      groups = {
          emil = {
              gid = 1000;
          };
      };
  };
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
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

  # Enable the OpenSSH daemon.
  services = {
    nfs = {
      server = {
        enable = true;
        lockdPort = 4001;
        mountdPort = 4002;
        statdPort = 4000;
        exports = ''
          /nfs/docker/compose 172.16.0.132(rw,sync,no_subtree_check)
          /nfs/Media  172.16.0.132(rw,sync,no_subtree_check)
          /nfs/ROMS   172.16.0.132(rw,sync,no_subtree_check)
          /nfs/ebooks 172.16.0.132(rw,sync,no_subtree_check)
          /nfs/Manga  172.16.0.132(rw,sync,no_subtree_check)
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
  system.stateVersion = "23.05"; # Did you read the comment?

}

