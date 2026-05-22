{ stdenvNoCC, fetchgit, ... }:
stdenvNoCC.mkDerivation {
    name = "wallpapers";

    src = fetchgit {
        url = "https://git.nudelkurre.com/nudelkurre/Wallpapers-images";
        rev = "af252801f994d15623eb53c0498859c28797ebda";
        hash = "sha256-j9bKOzmc0XzcxjqhtzJhdEzW819x7pRI5jEg338cIR4=";
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
