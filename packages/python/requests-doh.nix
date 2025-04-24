{pkgs, buildPythonPackage, fetchPypi, ...}:
buildPythonPackage rec {
  pname = "requests_doh";
  version = "1.0.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-bOi8liRQMKGY7yDSEAtNyzsSCgWljfcD+L4SGnn48vs=";
  };

  dependencies = with pkgs.python3Packages; [
    requests
    dnspython
  ];

  doCheck = false;
}