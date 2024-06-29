{pkgs, lib, stdenv, fetchurl, ...}:
stdenv.mkDerivation rec {
  pname = "pkg2zip";
  version = "2.3";
  src = fetchurl {
    url = "https://github.com/lusid1/pkg2zip/archive/${version}.tar.gz";
    sha256 = "sha256-N4D3j9GCMI7XhUxpx6hcTG1Plx7jqw5Zj1htz37imhU=";
  };

  buildPhase = ''
    make CFLAGS="-DNDEBUG -O2 -Wno-format-truncation"
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -Dm755 pkg2zip $out/bin/pkg2zip
  '';
}