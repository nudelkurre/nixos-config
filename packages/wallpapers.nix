{ stdenvNoCC, fetchgit, ... }:
stdenvNoCC.mkDerivation {
    name = "wallpapers";

    src = fetchgit {
        url = "https://git.nudelkurre.com/nudelkurre/Wallpapers-images";
        rev = "71f6256646cf8e04ccbd8651a346c4fcb2353bf2";
        hash = "sha256-FDOYFg7DNnTKsMvRty3XscKP1mXVPgiiDPAmFl0p86g=";
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
