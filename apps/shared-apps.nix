{pkgs, ...}:
{
    home = {
        packages = with pkgs; [
            imv
            jellyfin-desktop
            jq
            lm_sensors
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