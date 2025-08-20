{pkgs, stdenv, ...}:
stdenv.mkDerivation {
  pname = "wallpapers";
  version = "2025-07-26";
  src = fetchGit {
    url = "ssh://git@git.nudelkurre.com:2222/nudelkurre/Wallpapers.git";
    rev = "88ac60fd46f5689af0e03408f01b1386b605c8d2";
  };

  postInstall = ''
  mkdir -p $out/share/wallpapers
  cp -vr horizontal $out/share/wallpapers
  cp -vr vertical $out/share/wallpapers
  '';
}