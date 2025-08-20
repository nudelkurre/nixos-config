{
    pkgs,
    buildPythonPackage,
    fetchPypi,
    ...
}:
buildPythonPackage rec {
    pname = "mangadex_downloader";
    version = "3.1.3";
    src = fetchPypi {
        inherit pname version;
        sha256 = "sha256-LmxR9VQGyLrHbza/CeXwoNf02ywnqO7JFu0wmPF5PUM=";
    };

    dependencies = with pkgs.python3Packages; [
        requests
        pkgs.mypkgs.requests-doh
        pysocks
        tqdm
        pathvalidate
        packaging
        pyjwt
        beautifulsoup4
        pillow
        chardet
    ];

    doCheck = false;
}
