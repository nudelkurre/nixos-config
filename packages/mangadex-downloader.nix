{pkgs, buildPythonPackage, fetchPypi, ...}:
buildPythonPackage rec {
  pname = "mangadex-downloader";
  version = "2.10.3";
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-RM1UCnU7/P913g7HfTCZp166/0msK3OkfExJd9BCpOs=";
  };

  patches = [
    ./mangadex-dl.patch
  ];

  dependencies = with pkgs.python311Packages; [
    requests
    (
      buildPythonPackage rec {
        pname = "requests-doh";
        version = "0.3.3";
        src = fetchPypi {
          inherit pname version;
          sha256 = "sha256-P11hy9sodrp7ERRCy/5bMlYfLbkWb/MnhxGTfrPWYuE=";
        };

        propagatedBuildInputs = [
          requests
          dnspython
        ];            

        doCheck = false;
      }
    )
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