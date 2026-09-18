{ stdenvNoCC, fetchurl, ... }:
let
    version = "2026-09-18";
in
stdenvNoCC.mkDerivation {
    pname = "wallpapers";
    version = version;

    src = fetchurl {
        url = "https://git.nudelkurre.com/nudelkurre/Wallpapers-images/archive/${version}.tar.gz";
        hash = "sha256-6BUcbGBJpS869Zw1T9RaiECTIoBzv34rlLSIT02n+00=";
    };

    postInstall = ''
        mkdir -p $out/share/wallpapers
        if [ -d "images/horizontal" ]; then
            cp -vr images/horizontal $out/share/wallpapers
        fi
        if [ -d "images/vertical" ]; then
            cp -vr images/vertical $out/share/wallpapers
        fi
    '';
}
