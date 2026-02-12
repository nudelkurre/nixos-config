{pkgs, ...}:
{
    home = {
        packages = with pkgs; [
            chatterino2
            imv
            jellyfin-desktop
            jq
            lm_sensors
            mate.mate-polkit
            mypkgs.freetube
            nemo-with-extensions
            pavucontrol
            python3
            seahorse
            wl-clipboard
            yt-dlp
        ];
    };
}