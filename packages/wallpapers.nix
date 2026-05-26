{ stdenvNoCC, fetchgit, ... }:
let
    version = "2026-05-26";
in
stdenvNoCC.mkDerivation {
    pname = "wallpapers";
    version = version;

    src = fetchgit {
        url = "https://git.nudelkurre.com/nudelkurre/Wallpapers-images";
        rev = version;
        hash = "sha256-B3BxQPW2Teg/sX+xjC5qNiX7LqwaiDTjZXOGlLyodqQ=";
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
