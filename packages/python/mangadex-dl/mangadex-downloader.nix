{
    pkgs,
    buildPythonPackage,
    fetchPypi,
    ...
}:
buildPythonPackage rec {
    pname = "mangadex_downloader";
    version = "3.1.4";
    src = fetchPypi {
        inherit pname version;
        sha256 = "sha256-653lHYQPFZ3I9+bqMRxGcSyJv1MEqPvYbbX0j/SATyo=";
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
