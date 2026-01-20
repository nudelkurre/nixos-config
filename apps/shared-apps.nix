{pkgs, ...}:
{
    home = {
        packages = with pkgs; [
            chatterino2
            imv
            jq
            lm_sensors
            mate.mate-polkit
            mypkgs.freetube
            nemo-with-extensions
            pavucontrol
            python3
            seahorse
            vesktop
            wl-clipboard
            yt-dlp
        ];
    };
}