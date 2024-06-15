{
    description = "A very basic flake";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
        nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager/release-24.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        firefox-addons = {
            url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        m4b-tool = {
            url = "github:sandreas/m4b-tool";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        hyprland = {
            url = "github:hyprwm/Hyprland?ref=v0.40.0";
            inputs.nixpkgs.follows = "nixpkgs-unstable";
        };
        hy3 = {
            url = "github:outfoxxed/hy3?ref=hl0.40.0";
            inputs.hyprland.follows = "hyprland";
        };
        scripts = {
            url = "github:nudelkurre/scripts";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, firefox-addons, m4b-tool, hyprland, hy3, scripts, ... }: 
    let
        system = "x86_64-linux";
        overlay-unstable = final: prev: {
            unstable = nixpkgs-unstable.legacyPackages.${system};
        };
        m4b-tool-overlay = final: prev: {
            m4b-tool = m4b-tool.packages.${system};
        };
        firefox-addons-overlay = final: prev: {
            firefox-addons = firefox-addons.packages.${system};
        };
        hyprland-overlay = final: prev: {
            hyprland = hyprland.packages.${system};
        };
        hy3-overlay = final: prev: {
            hy3 = hy3.packages.${system};
        };
        mypkgs-overlay = final: prev: {
            mypkgs = self.packages.${system};
        };
        scripts-overlay = final: prev: {
            scripts = scripts.packages.${system};
        };
        pkgs = import nixpkgs {
            inherit system;
            overlays = [
                overlay-unstable
                m4b-tool-overlay
                firefox-addons-overlay
                hyprland-overlay
                hy3-overlay
                mypkgs-overlay
                scripts-overlay
            ];
        };
    in {
        nixosConfigurations = {
            desktop = nixpkgs.lib.nixosSystem {
                modules = [
                    ./nixos/configuration-base.nix
                    ./nixos/desktop.nix
                    ./nixos/hardware-configuration-desktop.nix
                ];
            };
            laptop = nixpkgs.lib.nixosSystem {
                modules = [
                    ./nixos/configuration-base.nix
                    ./nixos/laptop.nix
                    ./nixos/hardware-configuration-laptop.nix
                ];
            };
        };
        homeConfigurations = {
            "emil@desktop" = home-manager.lib.homeManagerConfiguration {
                inherit pkgs;
                modules = [
                    hyprland.homeManagerModules.default
                    ./home-manager/home-desktop.nix
                    ./options.nix
                ];
            };
            "emil@laptop" = home-manager.lib.homeManagerConfiguration {
                inherit pkgs;
                modules = [
                    ./home-manager/home-laptop.nix
                    ./options.nix
                ];
            };
        };
        packages.x86_64-linux = {
            wallpapers = pkgs.stdenv.mkDerivation rec {
                pname = "crunchyroll";
                version = "2024-06-07";
                src = ./packages/wallpapers/images;

                postInstall = ''
                mkdir -p $out/share/wallpapers
                cp -v wallhaven-4dl7m0.jpg $out/share/wallpapers/wallhaven-4dl7m0.jpg
                cp -v wallhaven-73oq7v.jpg $out/share/wallpapers/wallhaven-73oq7v.jpg
                cp -v wallhaven-m93r98.png $out/share/wallpapers/wallhaven-m93r98.png
                cp -v wallhaven-ne7jkw.jpg $out/share/wallpapers/wallhaven-ne7jkw.jpg
                cp -v wallhaven-qd56yq.jpg $out/share/wallpapers/wallhaven-qd56yq.jpg
                cp -v wallhaven-qz2qld.jpg $out/share/wallpapers/wallhaven-qz2qld.jpg
                cp -v wallhaven-w8qv5x.jpg $out/share/wallpapers/wallhaven-w8qv5x.jpg
                cp -v wallhaven-z8xqqo.jpg $out/share/wallpapers/wallhaven-z8xqqo.jpg
                '';
            };

            mangadex-downloader = pkgs.python311Packages.buildPythonPackage rec {
                pname = "mangadex-downloader";
                version = "2.10.3";
                src = pkgs.fetchPypi {
                    inherit pname version;
                    sha256 = "sha256-RM1UCnU7/P913g7HfTCZp166/0msK3OkfExJd9BCpOs=";
                };

                dependencies = with pkgs.python311Packages; [
                    requests
                    (
                        buildPythonPackage rec {
                            pname = "requests-doh";
                            version = "0.3.3";
                            src = pkgs.fetchPypi {
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
            };

            pkg2zip = pkgs.stdenv.mkDerivation rec {
                pname = "pkg2zip";
                version = "2.3";
                src = pkgs.fetchurl {
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
            };
        };
    };
}
