{pkgs, stdenv, ...}:
stdenv.mkDerivation {
  pname = "wallpapers";
  version = "2025-07-26";
  src = ./images;

  postInstall = ''
  mkdir -p $out/share/wallpapers
  cp -vr horizontal $out/share/wallpapers
  cp -vr vertical $out/share/wallpapers
  '';
}