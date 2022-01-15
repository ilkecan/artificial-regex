{
  description = "Artificial - Regex fun";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nix-filter.url = "github:ilkecan/nix-filter";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";

    statix = {
      url = "github:nerdypepper/statix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        fenix.follows = "deadnix/fenix";
      };
    };

    deadnix = {
      url = "github:astro/deadnix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "flake-utils";
      };
    };
  };

  outputs = { nixpkgs, ... }@inputs:
    let
      inherit (inputs.flake-utils.lib)
        defaultSystems
        eachSystem
      ;

      supportedSystems = defaultSystems;
    in
    eachSystem supportedSystems (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (final: prev: { nix-filter = inputs.nix-filter.lib; })
            (import ./nix/haskell)
            inputs.deadnix.overlay
            inputs.statix.overlay
          ];
        };

        inherit (pkgs)
          callPackage
          haskellPackages
        ;
      in
      rec {
        packages = {
          inherit (haskellPackages) artificial-regex;
        };

        defaultPackage = packages.artificial-regex;

        devShell = callPackage ./nix/shell.nix { };
      }
    );
}
