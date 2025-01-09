{pkgs, config, ...}:
{
    services.gnome-keyring = {
        enable = ! config.disable.gnome-keyring;
        components = [ "ssh" "pkcs11" "secrets" ];
    };
}