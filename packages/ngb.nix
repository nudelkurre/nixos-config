{pkgs, stdenv, fetchFromGitHub, ...}:
with pkgs.python3Packages;

buildPythonApplication rec {
  pname = "ngb";
  version = "testing";
  pyproject = true;
  src = fetchFromGitHub{
    owner = "nudelkurre";
    repo = "ngb";
    rev = "ce48f4d1d7054f474259f4d6382f9578a02570e1";
    hash = "sha256-q9X8xrsk64mYjkmypn3y1+mZ1IThep0KENwNjpNEo80=";
  };

  build-system = [
    hatchling
  ];

  nativeBuildInputs = with pkgs; [
    wrapGAppsHook
    gobject-introspection
    pkg-config
    makeWrapper
  ];

  buildInputs = with pkgs; [
    gtk4
    gtk4-layer-shell
  ];

  dependencies = [
    geopy
    i3ipc
    meson
    meson-python
    ninja
    psutil
    pygobject3
    pyyaml
    requests
    screeninfo
    shutilwhich
    tzlocal
  ];

  doCheck = false;

  makeWrapperArgs = [
    ''--set LD_LIBRARY_PATH "$out/lib:${pkgs.gtk4-layer-shell}/lib:$LD_LIBRARY_PATH"''
  ];
}