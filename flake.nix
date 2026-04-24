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
                jellyfin-desktop = "2.0.0";
                yt-dlp = "2026.03.17";
            };
            version-overlay = final: prev: {
                yt-dlp = prev.yt-dlp.overrideAttrs (old: {
                    version = versions.yt-dlp;
                    src = prev.fetchFromGitHub {
                        owner = "yt-dlp";
                        repo = "yt-dlp";
                        rev = versions.yt-dlp;
                        hash = "sha256-A4LUCuKCjpVAOJ8jNoYaC3mRCiKH0/wtcsle0YfZyTA=";
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
                firefox-version = "firefox-esr";
                colors = {
                    variant = "frappe";
                    main = sharedSettings.colors."${sharedSettings.colors.variant}".pink;
                    secondary = sharedSettings.colors."${sharedSettings.colors.variant}".blue;
                    latte = {
                        rosewater = "#dc8a78";
                        flamingo = "#dd7878";
                        pink = "#ea76cb";
                        mauve = "#8839ef";
                        red = "#d20f39";
                        maroon = "#e64553";
                        peach = "#fe640b";
                        yellow = "#df8e1d";
                        green = "#40a02b";
                        teal = "#179299";
                        sky = "#04a5e5";
                        sapphire = "#209fb5";
                        blue = "#1e66f5";
                        lavender = "#7287fd";
                        base = "#eff1f5";
                        mantle = "#e6e9ef";
                        crust = "#dce0e8";
                        text = "#4c4f69";
                        subtext0 = "#6c6f85";
                        subtext1 = "#5c5f77";
                        overlay0 = "#9ca0b0";
                        overlay1 = "#8c8fa1";
                        overlay2 = "#7c7f93";
                        surface0 = "#ccd0da";
                        surface1 = "#bcc0cc";
                        surface2 = "#acb0be";
                    };
                    frappe = {
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
                        mantle = "#292c3c";
                        crust = "#232634";
                        text = "#c6d0f5";
                        subtext0 = "#a5adce";
                        subtext1 = "#b5bfe2";
                        overlay0 = "#737994";
                        overlay1 = "#838ba7";
                        overlay2 = "#949cbb";
                        surface0 = "#414559";
                        surface1 = "#51576d";
                        surface2 = "#626880";
                    };
                    macchiato = {
                        rosewater = "#f4dbd6";
                        flamingo = "#f0c6c6";
                        pink = "#f5bde6";
                        mauve = "#c6a0f6";
                        red = "#ed8796";
                        maroon = "#ee99a0";
                        peach = "#f5a97f";
                        yellow = "#eed49f";
                        green = "#a6da95";
                        teal = "#8bd5ca";
                        sky = "#91d7e3";
                        sapphire = "#7dc4e4";
                        blue = "#8aadf4";
                        lavender = "#b7bdf8";
                        base = "#24273a";
                        mantle = "#1e2030";
                        crust = "#181926";
                        text = "#cad3f5";
                        subtext0 = "#a5adcb";
                        subtext1 = "#b8c0e0";
                        overlay0 = "#6e738d";
                        overlay1 = "#8087a2";
                        overlay2 = "#939ab7";
                        surface0 = "#363a4f";
                        surface1 = "#494d64";
                        surface2 = "#5b6078";
                    };
                    mocha = {
                        rosewater = "#f5e0dc";
                        flamingo = "#f2cdcd";
                        pink = "#f5c2e7";
                        mauve = "#cba6f7";
                        red = "#f38ba8";
                        maroon = "#eba0ac";
                        peach = "#fab387";
                        yellow = "#f9e2af";
                        green = "#a6e3a1";
                        teal = "#94e2d5";
                        sky = "#89dceb";
                        sapphire = "#74c7ec";
                        blue = "#89b4fa";
                        lavender = "#b4befe";
                        base = "#1e1e2e";
                        mantle = "#181825";
                        crust = "#11111b";
                        text = "#cdd6f4";
                        subtext0 = "#a6adc8";
                        subtext1 = "#bac2de";
                        overlay0 = "#6c7086";
                        overlay1 = "#7f849c";
                        overlay2 = "#9399b2";
                        surface0 = "#313244";
                        surface1 = "#45475a";
                        surface2 = "#585b70";
                    };
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
