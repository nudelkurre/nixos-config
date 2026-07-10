{ pkgs, lib, config, ... }:
{
    home.sessionVariables = lib.mkIf config.programs.rbw.enable {
        SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/rbw/ssh-agent-socket";
    };
    programs.rbw = {
        enable = true;
        settings = {
            base_url = "https://bw.nudelkurre.com";
            email = "nudelkurre@protonmail.com";
            lock_timeout = 300;
            pinentry = pkgs.pinentry-gnome3;
        };
    };
}
