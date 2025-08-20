{
  inputs.base.url = "path:/Users/ritzau/src/slask/aoc-nix/languages/base";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.rust-overlay.url = "github:oxalica/rust-overlay";

  outputs =
    {
      self,
      base,
      flake-utils,
      rust-overlay,
      nixpkgs,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        baseLib = base.lib.${system};
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ (import rust-overlay) ];
        };
        rustToolchain = pkgs.rust-bin.stable.latest.default.override {
          extensions = [
            "rust-src"
            "clippy"
            "rustfmt"
          ];
        };
      in
      {
        devShells.default = baseLib.mkLanguageShell {
          name = "Rust";
          emoji = "🦀";
          languageTools = [
            rustToolchain
            pkgs.cargo-watch
            pkgs.cargo-edit
            pkgs.cargo-generate
            pkgs.bacon
          ];
        };
        lib.mkSolution =
          args:
          baseLib.mkSolution (
            {
              language = "rust";
              languageFlake = self;
            }
            // args
          );
      }
    )
    // {
      mkStandardOutputs =
        args:
        flake-utils.lib.eachDefaultSystem (
          system:
          let
            pkgs = import nixpkgs {
              inherit system;
              overlays = [ (import rust-overlay) ];
            };
          in
          self.lib.${system}.mkSolution {
            package = base.lib.${system}.buildFunctions.buildSystem (
              buildArgs:
              pkgs.rustPlatform.buildRustPackage (
                {
                  version = "0.1.0";
                  cargoLock.lockFile = "${buildArgs.src}/Cargo.lock";
                }
                // buildArgs
              )
            ) ({ pkgs = base.lib.${system}.pkgs; } // args);
          }
        );
    };
}
