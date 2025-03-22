{
    description = "A very basic flake";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
        nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager/release-24.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        firefox-addons = {
            url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        m4b-tool = {
            url = "github:sandreas/m4b-tool/5b0821449c529449a188bec521d51e00eefe52a2";
        };
        scripts = {
            url = "github:nudelkurre/scripts";
        };
        eww = {
            url = "github:elkowar/eww/6ee166707fb644d501a6d9151a491d07916ca4ed";
        };
        ngb = {
            url = "path:/home/emil/repos/ngb/0.1.0";
        };
    };

    outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, firefox-addons, m4b-tool, scripts, eww, ngb, ... }: 
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
        mypkgs-overlay = final: prev: {
            mypkgs = self.packages.${system};
        };
        scripts-overlay = final: prev: {
            scripts = scripts.packages.${system};
        };
        eww-overlay = final: prev: {
            eww-git = eww.packages.${system};
        };
        pkgs = import nixpkgs {
            inherit system;
            overlays = [
                overlay-unstable
                m4b-tool-overlay
                firefox-addons-overlay
                mypkgs-overlay
                scripts-overlay
                eww-overlay
                ngb.overlay
            ];
        };
    in {
        nixosConfigurations = {
            desktop = nixpkgs.lib.nixosSystem {
                modules = [
                    ./machines/desktop/configuration.nix
                    ./machines/desktop/hardware-configuration-desktop.nix
                ];
            };
            laptop = nixpkgs.lib.nixosSystem {
                modules = [
                    ./machines/laptop/configuration.nix
                    ./machines/laptop/hardware-configuration-laptop.nix
                ];
            };
            server = nixpkgs.lib.nixosSystem {
                modules = [
                    ./machines/server/configuration.nix
                    ./machines/server/hardware-configuration-server.nix
                ];
            };
        };
        homeConfigurations = {
            "emil@desktop" = home-manager.lib.homeManagerConfiguration {
                inherit pkgs;
                modules = [
                    ./apps
                    ./machines/desktop/home.nix
                    ./options.nix
                    ngb.outputs.homeManagerModules.ngb
                ];
            };
            "emil@laptop" = home-manager.lib.homeManagerConfiguration {
                inherit pkgs;
                modules = [
                    ./machines/laptop/home.nix
                    ./options.nix
                ];
            };
        };
        packages.x86_64-linux = {
            wallpapers = pkgs.callPackage packages/wallpapers {};
            mangadex-downloader = pkgs.python311Packages.callPackage packages/mangadex-dl/mangadex-downloader.nix {};
            freetube = pkgs.callPackage packages/freetube.nix {};
            pkg2zip = pkgs.callPackage packages/pkg2zip.nix {};
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
