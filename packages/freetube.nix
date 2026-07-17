{
    stdenv,
    fetchurl,
    appimageTools,
    makeWrapper,
    electron_41,
    nixosTests,
}:

stdenv.mkDerivation rec {
    pname = "freetube";
    version = "0.25.0";

    src = fetchurl {
        url = "https://github.com/FreeTubeApp/FreeTube/releases/download/v${version}-beta/freetube-${version}-beta-amd64.AppImage";
        hash = "sha256-DjNdP1Pjww2DjuOMsgEqHWIgaf/7KUaAlkvv0UCE/a4=";
    };

    passthru.tests = nixosTests.freetube;

    appimageContents = appimageTools.extractType2 { inherit pname version src; };

    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;

    nativeBuildInputs = [ makeWrapper ];

    installPhase = ''
        runHook preInstall

        mkdir -p $out/bin $out/share/${pname} $out/share/applications $out/share/icons/hicolor/scalable/apps

        cp -a ${appimageContents}/{locales,resources} $out/share/${pname}
        cp -a ${appimageContents}/freetube.desktop $out/share/applications/${pname}.desktop

        substituteInPlace $out/share/applications/${pname}.desktop \
          --replace 'Exec=AppRun' 'Exec=${pname}'

        runHook postInstall
    '';

    postFixup = ''
        makeWrapper ${electron_41}/bin/electron $out/bin/${pname} \
          --add-flags $out/share/${pname}/resources/app.asar \
          --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--enable-features=UseOzonePlatform --ozone-platform=wayland}}"
    '';
}
