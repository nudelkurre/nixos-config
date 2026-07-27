{ stdenvNoCC, fetchurl, ... }:
let
    version = "2026-07-27";
in
stdenvNoCC.mkDerivation {
    pname = "video-wallpapers";
    version = version;

    src = fetchurl {
        url = "https://git.nudelkurre.com/nudelkurre/Wallpapers-videos/archive/${version}.tar.gz";
        hash = "sha256-5gAsv+HjLl4pwFeex5RoaYPiAVcrwTKBuIf6vXSm0+Y=";
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
