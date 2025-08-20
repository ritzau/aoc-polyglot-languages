{
  description = "Polyglot language environments for Advent of Code solutions";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # Import base functionality
        base = import ./lib/base.nix { inherit pkgs; };
        buildFunctions = import ./lib/build-functions.nix { inherit pkgs; };

        # Combine base functionality
        baseLib = base // {
          inherit buildFunctions;
          mkJustfile = base.mkJustfile self;
        };

        # Import all language definitions
        languages = {
          c = import ./languages/c.nix {
            inherit pkgs;
            base = baseLib;
          };
          python = import ./languages/python.nix {
            inherit pkgs;
            base = baseLib;
          };
          rust = import ./languages/rust.nix {
            inherit pkgs;
            base = baseLib;
          };
          go = import ./languages/go.nix {
            inherit pkgs;
            base = baseLib;
          };
          # TODO: Add all other languages here
        };

      in
      {
        # Expose each language as separate dev shell outputs
        devShells = builtins.mapAttrs (_: lang: lang.devShell) languages;

        # Expose solution builders for each language
        lib = builtins.mapAttrs (_: lang: {
          mkStandardOutputs = lang.mkStandardOutputs;
        }) languages;

        # Also expose the base functionality for custom use
        baseLib = baseLib;
      }
    );
}
