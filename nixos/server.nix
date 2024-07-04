# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  networking = {
    hostName = "server";

    usePredictableInterfaceNames = false;
    enableIPv6 = true;

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
    nameservers = [ "172.16.0.12" "172.16.0.210" ];
  };

  users.users.emil.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIINWKyIwExthLlL6WFZbnQCtiziwlMZxHB5XBuEYrsob emil@desktop"
  ];
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    lm_sensors
  ];

  # Enable the OpenSSH daemon.
  services = {
    nfs = {
      server = {
        enable = true;
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

