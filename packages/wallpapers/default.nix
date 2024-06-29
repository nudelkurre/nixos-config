{pkgs, stdenv, ...}:
stdenv.mkDerivation {
  pname = "wallpapers";
  version = "2024-06-27";
  src = ./images;

  postInstall = ''
  mkdir -p $out/share/wallpapers
  cp -v wallhaven-4dl7m0.jpg $out/share/wallpapers/wallhaven-4dl7m0.jpg
  cp -v wallhaven-ne7jkw.jpg $out/share/wallpapers/wallhaven-ne7jkw.jpg
  cp -v wallhaven-qd56yq.jpg $out/share/wallpapers/wallhaven-qd56yq.jpg
  cp -v wallhaven-qz2qld.jpg $out/share/wallpapers/wallhaven-qz2qld.jpg
  cp -v wallhaven-w8qv5x.jpg $out/share/wallpapers/wallhaven-w8qv5x.jpg
  cp -v wallhaven-z8xqqo.jpg $out/share/wallpapers/wallhaven-z8xqqo.jpg
  '';
}