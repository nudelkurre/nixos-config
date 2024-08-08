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
            url = "github:sandreas/m4b-tool/5b0821449c529449a188bec521d51e00eefe52a2";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        scripts = {
            url = "github:nudelkurre/scripts";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, firefox-addons, m4b-tool, scripts, ... }: 
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
        pkgs = import nixpkgs {
            inherit system;
            overlays = [
                overlay-unstable
                m4b-tool-overlay
                firefox-addons-overlay
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
            server = nixpkgs.lib.nixosSystem {
                modules = [
                    ./nixos/configuration-base.nix
                    ./nixos/server.nix
                    ./nixos/hardware-configuration-server.nix
                ];
            };
        };
        homeConfigurations = {
            "emil@desktop" = home-manager.lib.homeManagerConfiguration {
                inherit pkgs;
                modules = [
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
            wallpapers = pkgs.callPackage packages/wallpapers {};
            mangadex-downloader = pkgs.python311Packages.callPackage packages/mangadex-downloader.nix {};
            freetube = pkgs.callPackage packages/freetube.nix {};
            pkg2zip = pkgs.callPackage packages/pkg2zip.nix {};
        };
    };
}
