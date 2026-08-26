{ stdenvNoCC, fetchurl, ... }:
let
    version = "2026-08-26";
in
stdenvNoCC.mkDerivation {
    pname = "video-wallpapers";
    version = version;

    src = fetchurl {
        url = "https://git.nudelkurre.com/nudelkurre/Wallpapers-videos/archive/${version}.tar.gz";
        hash = "sha256-Ylt2Y3m8jwDrZcvTLtpV96fbv3vddgTfIq3TratYrrg=";
    };

    postInstall = ''
        mkdir -p $out/share/wallpapers
        if [ -d "videos/horizontal" ]; then
            cp -vr videos/horizontal $out/share/wallpapers
        fi
        if [ -d "videos/vertical" ]; then
            cp -vr videos/vertical $out/share/wallpapers
        fi
    '';
}
