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
            protonup-qt
            python3
            qpwgraph
            seahorse
            vesktop
            virt-viewer
            wl-clipboard
            yt-dlp
        ];
    };
}