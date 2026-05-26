{ stdenvNoCC, fetchgit, ... }:
let
    version = "2026-05-25";
in
stdenvNoCC.mkDerivation {
    pname = "video-wallpapers";
    version = version;

    src = fetchgit {
        url = "https://git.nudelkurre.com/nudelkurre/Wallpapers-videos";
        rev = version;
        hash = "sha256-ENV9ryMCG5enAZOav35S1/tKZZ5ydpA2EmRHZUmd0FM=";
        fetchLFS = true;
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
