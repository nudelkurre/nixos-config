{pkgs, lib, stdenv, fetchurl, ...}:
stdenv.mkDerivation rec {
  pname = "pkg2zip";
  version = "2.6";
  src = fetchurl {
    url = "https://github.com/lusid1/pkg2zip/archive/${version}.tar.gz";
    sha256 = "sha256-qql3Cm/ThGdFnW41rKKoMlcyJHp5o75NXF/nneK12I8=";
  };

  buildPhase = ''
    make CFLAGS="-DNDEBUG -O2 -Wno-format-truncation"
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -Dm755 pkg2zip $out/bin/pkg2zip
  '';
}