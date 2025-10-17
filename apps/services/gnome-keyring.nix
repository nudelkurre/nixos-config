{ ... }:
{
    services.gnome-keyring = {
        enable = true;
        components = [
            "ssh"
            "pkcs11"
            "secrets"
        ];
    };
}
