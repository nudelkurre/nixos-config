{
    description = "A very basic flake";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
        nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager/release-25.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        ngb = {
            url = "github:nudelkurre/ngb";
        };
        wallpapers = {
            url = "git+https://git.nudelkurre.com/nudelkurre/Wallpapers.git";
        };
        sops-nix = {
            url = "github:Mic92/sops-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs =
        {
            self,
            nixpkgs,
            nixpkgs-unstable,
            home-manager,
            ngb,
            wallpapers,
            sops-nix,
            ...
        }:
        let
            system = "x86_64-linux";
            overlay-unstable = final: prev: {
                unstable = nixpkgs-unstable.legacyPackages.${prev.stdenv.hostPlatform.system};
            };
            mypkgs-overlay = final: prev: {
                mypkgs = self.packages.${prev.stdenv.hostPlatform.system};
            };
            wallpapers-overlay = final: prev: {
                wallpapers = wallpapers.packages.${prev.stdenv.hostPlatform.system};
            };
            versions = {
                intel-vaapi-driver = "2.4.5";
                yt-dlp = "2025.12.08";
            };
            version-overlay = final: prev: {
                yt-dlp = prev.yt-dlp.overrideAttrs (old: {
                    version = versions.yt-dlp;
                    src = prev.fetchFromGitHub {
                        owner = "yt-dlp";
                        repo = "yt-dlp";
                        rev = versions.yt-dlp;
                        hash = "sha256-y06MDP+CrlHGrell9hcLOGlHp/gU2OOxs7can4hbj+g=";
                    };
                });
            };
            pkgs = import nixpkgs {
                inherit system;
                overlays = [
                    overlay-unstable
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
                enableIPv6 = false;
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
                colors = {
                    main = sharedSettings.colors.pink;
                    secondary = sharedSettings.colors.blue;
                    rosewater = "#f2d5cf";
                    flamingo = "#eebebe";
                    pink = "#f4b8e4";
                    mauve = "#ca9ee6";
                    red = "#e78284";
                    maroon = "#ea999c";
                    peach = "#ef9f76";
                    yellow = "#e5c890";
                    green = "#a6d189";
                    teal = "#81c8be";
                    sky = "#99d1db";
                    sapphire = "#85c1dc";
                    blue = "#8caaee";
                    lavender = "#babbf1";
                    base = "#303446";
                    text = "#c6d0f5";
                    overlay = "#737994";
                };
            };
        in
        {
            nixosConfigurations = {
                desktop = nixpkgs.lib.nixosSystem {
                    modules = [
                        {
                            nixpkgs.overlays = [
                                (final: prev: {
                                    unstable = nixpkgs-unstable.legacyPackages.${prev.stdenv.hostPlatform.system};
                                })
                            ];
                        }
                        ./machines/desktop/configuration.nix
                        ./machines/desktop/hardware-configuration-desktop.nix
                        sops-nix.nixosModules.sops
                    ];
                    specialArgs = { inherit sharedSettings; };
                };
                laptop = nixpkgs.lib.nixosSystem {
                    modules = [
                        {
                            nixpkgs.overlays = [
                                (final: prev: {
                                    intel-vaapi-driver = prev.intel-vaapi-driver.overrideAttrs (old: {
                                        version = versions.intel-vaapi-driver;
                                        src = prev.fetchFromGitHub {
                                            owner = "irql-notlessorequal";
                                            repo = "intel-vaapi-driver";
                                            rev = versions.intel-vaapi-driver;
                                            hash = "sha256-exQBA42jCmwybE7WIfF83cjmzBdtluDzUtOdqt49HSg=";
                                        };
                                    });
                                })
                                (final: prev: {
                                    unstable = nixpkgs-unstable.legacyPackages.${prev.stdenv.hostPlatform.system};
                                })
                            ];
                        }
                        ./machines/laptop/configuration.nix
                        ./machines/laptop/hardware-configuration-laptop.nix
                        sops-nix.nixosModules.sops
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
                        sops-nix.homeManagerModules.sops
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
                        sops-nix.homeManagerModules.sops
                    ];
                    extraSpecialArgs = { inherit sharedSettings; };
                };
            };
            packages.x86_64-linux = {
                freetube = pkgs.callPackage packages/freetube.nix { };
                pkg2zip = pkgs.callPackage packages/pkg2zip.nix { };
            };

            apps.x86_64-linux = {
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
