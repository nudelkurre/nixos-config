{ stdenv, fetchFromGitea, ... }:
stdenv.mkDerivation {
    pname = "wallpapers";
    version = "2025-08-20";

    src = fetchFromGitea {
        domain = "git.nudelkurre.com";
        owner = "nudelkurre";
        repo = "Wallpapers";
        rev = "2025-08-23";
        hash = "sha256-Cq0NnZ8tkD+glI7nLuDLoPuqncq3w4iny5mA2LhsooI=";
    };

    postInstall = ''
        mkdir -p $out/share/wallpapers
        cp -vr horizontal $out/share/wallpapers
        cp -vr vertical $out/share/wallpapers
    '';
}
