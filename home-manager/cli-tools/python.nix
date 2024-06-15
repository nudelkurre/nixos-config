{config, pkgs, ...}:
let
    my-python-packages = ps: with ps; [
        yt-dlp
        requests
        psutil
        pytz
        dateutils
        ratelim
        click
        geopy

        (
            buildPythonPackage rec {
                pname = "suntime";
                version = "1.2.5";
                src = fetchPypi {
                    inherit pname version;
                    sha256 = "sha256-5N9lHfzeMy+QXlfaa+SaHMaWSZ8RhT+wOV3ykQQnRkk=";
                };
                doCheck = false;
            }
        )

        (
            buildPythonPackage rec {
                pname = "mangadex-downloader";
                version = "2.10.3";
                src = fetchPypi {
                    inherit pname version;
                    sha256 = "sha256-RM1UCnU7/P913g7HfTCZp166/0msK3OkfExJd9BCpOs=";
                };

                propagatedBuildInputs = [
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
        )
    ];
in
{
    home.packages = with pkgs; [
        (python311.withPackages my-python-packages)
    ];
}