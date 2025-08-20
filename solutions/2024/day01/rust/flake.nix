{
  description = "Day 1 Rust solution";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      rust-overlay,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
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
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            rustToolchain
            cargo-watch
            bacon
          ];

          shellHook = ''
            echo "🦀 Day 1 Rust Solution"
            echo "Run: cargo run"
          '';
        };

        packages.default = pkgs.rustPlatform.buildRustPackage {
          pname = "aoc-2024-day01";
          version = "0.1.0";
          src = ./.;
          cargoLock.lockFile = ./Cargo.lock;
        };

        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/aoc-2024-day01";
          meta = {
            description = "AOC 2024 Day 1 solution";
          };
        };

        checks.default = self.packages.${system}.default;
      }
    );
}
