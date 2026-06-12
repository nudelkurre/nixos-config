{
    pkgs,
    lib,
    modulesPath,
    config,
    sharedSettings,
    ...
}:
{
    boot = {
        # Set because of evaluation warning recommend to set it
        zfs.forceImportRoot = false;
    };

    console = {
        keyMap = "sv-latin1";
    };

    environment = {
        systemPackages = with pkgs; [
            btrfs-progs
            git
        ];
    };

    # Select internationalisation properties.
    i18n = {
        defaultLocale = sharedSettings.locale;
    };

    imports = [
        (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
    ];

    nixpkgs = {
        hostPlatform = lib.mkDefault "x86_64-linux";
    };
}
