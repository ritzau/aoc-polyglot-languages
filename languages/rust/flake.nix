{
  description = "Rust environment for AOC solutions";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
    base = {
      url = "path:/Users/ritzau/src/slask/aoc-nix/languages/base";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay, base }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          overlays = [ (import rust-overlay) ];
          pkgs = import nixpkgs {
            inherit system overlays;
          };
          baseLib = base.lib.${system};

          rustToolchain = pkgs.rust-bin.stable.latest.default.override {
            extensions = [ "rust-src" "clippy" "rustfmt" ];
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

          # Export mkSolution for Rust solutions to use
          lib = {
            # Wrapper that provides the language name automatically
            mkSolution = args: baseLib.mkSolution ({
              language = "rust";
              languageFlake = self;
            } // args);
            inherit pkgs;
          };
        }) // {
      # Complete solution outputs - eliminates all boilerplate
      mkStandardOutputs = { src ? ./., pname ? "hello-rust", ... }@args:
        flake-utils.lib.eachDefaultSystem (system:
          let
            overlays = [ (import rust-overlay) ];
            pkgs = import nixpkgs {
              inherit system overlays;
            };
            # Default package that uses cargo build
            defaultPackage = pkgs.rustPlatform.buildRustPackage {
              pname = pname;
              version = "0.1.0";
              src = src;
              cargoLock = {
                lockFile = "${src}/Cargo.lock";
              };
            };
            # Remove src and pname from args to pass to mkSolution
            cleanArgs = builtins.removeAttrs args [ "src" "pname" ];
          in
          self.lib.${system}.mkSolution ({
            package = defaultPackage;
          } // cleanArgs));
    };
}
