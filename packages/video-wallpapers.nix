{ stdenvNoCC, fetchgit, ... }:
stdenvNoCC.mkDerivation {
    name = "video-wallpapers";

    src = fetchgit {
        url = "https://git.nudelkurre.com/nudelkurre/Wallpapers-videos";
        rev = "3f1ac46fab3c80414bc9b0d769f34b37d1e17f29";
        hash = "sha256-P69m81HkIh1cxR5fmorC1uUBiclNOpakTXdqNQCkdyQ=";
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
