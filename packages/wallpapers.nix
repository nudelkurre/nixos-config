{ stdenvNoCC, fetchurl, ... }:
let
    version = "2026-05-29";
in
stdenvNoCC.mkDerivation {
    pname = "wallpapers";
    version = version;

    src = fetchurl {
        url = "https://git.nudelkurre.com/nudelkurre/Wallpapers-images/archive/${version}.tar.gz";
        hash = "sha256-I9JPpy1WQFbkXrjjO15zha9TC1A0LrVfdro6CZh1+Hk=";
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
