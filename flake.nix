{
    description = "A very basic flake";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
        nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager/release-25.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        firefox-addons = {
            url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        ngb = {
            url = "github:nudelkurre/ngb";
        };
        wallpapers = {
            url = "git+https://git.nudelkurre.com/nudelkurre/Wallpapers.git";
        };
    };

    outputs =
        {
            self,
            nixpkgs,
            nixpkgs-unstable,
            home-manager,
            firefox-addons,
            ngb,
            wallpapers,
            ...
        }:
        let
            system = "x86_64-linux";
            overlay-unstable = final: prev: {
                unstable = nixpkgs-unstable.legacyPackages.${system};
            };
            firefox-addons-overlay = final: prev: {
                firefox-addons = firefox-addons.packages.${system};
            };
            mypkgs-overlay = final: prev: {
                mypkgs = self.packages.${system};
            };
            wallpapers-overlay = final: prev: {
                wallpapers = wallpapers.packages.${system};
            };
            versions = {
                yt-dlp = "2025.10.22";
            };
            version-overlay = final: prev: {
                yt-dlp = prev.yt-dlp.overrideAttrs (old: {
                    version = versions.yt-dlp;
                    src = prev.fetchFromGitHub {
                        owner = "yt-dlp";
                        repo = "yt-dlp";
                        rev = versions.yt-dlp;
                        hash = "sha256-jQaENEflaF9HzY/EiMXIHgUehAJ3nnDT9IbaN6bDcac=";
                    };
                });
            };
            pkgs = import nixpkgs {
                inherit system;
                overlays = [
                    overlay-unstable
                    firefox-addons-overlay
                    mypkgs-overlay
                    ngb.overlay
                    wallpapers-overlay
                    version-overlay
                ];
            };
            sharedSettings = {
                groupId = 1000;
                locale = "en_DK.UTF-8";
                serverIP = "10.10.0.12";
                timeZone = "Europe/Stockholm";
                u2f = {
                    authFile = pkgs.writeText "u2f-mappings" (
                        nixpkgs.lib.concatStrings [
                            "${sharedSettings.userName}"
                            ":TmhcVuAwLzXUVz+fZhF8KXSRDSV6qV0xWTTqGsiCYmz+15MHMUQC0I92eIGF8GuaNvOuegzX8TzBXTaxZ8z67A==,2ZD3OVnwUE6K9JqjJuc83TxfwcuPnZk2T42QzCyctq3Xc0gmKSPxxTg11ID5h6rsfwHaTjYUYEK2FStqtnWiZA==,es256,+presence"
                            ":i2SEXzssJ4SHNufLn5floulKQirWCW+NB0rrN5PgZmhEkn1mUhV1G1wAFzWKEfBzh8wfnWafBgds1kK5QXjQrA==,2TXrz7rEza+OP5OLLoOdTfLA6SgnlIL0UYVLYA3DTzRd3Bgvz6Oag7R5nLLR9griaVMh/Z9Eqo1CzxmkhmV55g==,es256,+presence"
                        ]
                    );
                    origin = "pam://yubikey";
                };
                userName = "emil";
            };
        in
        {
            nixosConfigurations = {
                desktop = nixpkgs.lib.nixosSystem {
                    modules = [
                        {
                            nixpkgs.overlays = [
                                (final: prev: {
                                    unstable = nixpkgs-unstable.legacyPackages.${prev.system};
                                })
                            ];
                        }
                        ./machines/desktop/configuration.nix
                        ./machines/desktop/hardware-configuration-desktop.nix
                    ];
                    specialArgs = { inherit sharedSettings; };
                };
                laptop = nixpkgs.lib.nixosSystem {
                    modules = [
                        ./machines/laptop/configuration.nix
                        ./machines/laptop/hardware-configuration-laptop.nix
                    ];
                    specialArgs = { inherit sharedSettings; };
                };
                server = nixpkgs.lib.nixosSystem {
                    modules = [
                        ./machines/server/configuration.nix
                        ./machines/server/hardware-configuration-server.nix
                    ];
                    specialArgs = { inherit sharedSettings; };
                };
            };
            homeConfigurations = {
                "${sharedSettings.userName}@desktop" = home-manager.lib.homeManagerConfiguration {
                    inherit pkgs;
                    modules = [
                        ./apps
                        ./machines/desktop/home.nix
                        ./options.nix
                        ngb.outputs.homeManagerModules.ngb
                    ];
                    extraSpecialArgs = { inherit sharedSettings; };
                };
                "${sharedSettings.userName}@laptop" = home-manager.lib.homeManagerConfiguration {
                    inherit pkgs;
                    modules = [
                        ./apps
                        ./machines/laptop/home.nix
                        ./options.nix
                        ngb.outputs.homeManagerModules.ngb
                    ];
                    extraSpecialArgs = { inherit sharedSettings; };
                };
            };
            packages.x86_64-linux = {
                mangadex-downloader =
                    pkgs.python3Packages.callPackage packages/python/mangadex-dl/mangadex-downloader.nix
                        { };
                requests-doh = pkgs.python3Packages.callPackage packages/python/requests-doh.nix { };
                freetube = pkgs.callPackage packages/freetube.nix { };
                pkg2zip = pkgs.callPackage packages/pkg2zip.nix { };
            };

            apps.x86_64-linux = {
                mangadex-downloader = {
                    type = "app";
                    program = "${self.packages.x86_64-linux.mangadex-downloader}/bin/mangadex-downloader";
                };
                freetube = {
                    type = "app";
                    program = "${self.packages.x86_64-linux.freetube}/bin/freetube";
                };
                pkg2zip = {
                    type = "app";
                    program = "${self.packages.x86_64-linux.pkg2zip}/bin/pkg2zip";
                };
            };
        };
}
