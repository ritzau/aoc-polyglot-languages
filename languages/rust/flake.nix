{
  description = "Rust environment for AOC solutions";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
        
        rustToolchain = pkgs.rust-bin.stable.latest.default.override {
          extensions = [ "rust-src" "clippy" "rustfmt" ];
        };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            rustToolchain
            cargo-watch
            cargo-edit
            cargo-generate
            bacon
          ];

          shellHook = ''
            echo "🦀 Rust AOC Environment"
            echo "Available commands:"
            echo "  cargo run           - Run the solution"
            echo "  cargo test          - Run tests"
            echo "  cargo watch -x run  - Watch and run on changes"
            echo "  bacon               - Background code checker"
          '';
        };
      });
}