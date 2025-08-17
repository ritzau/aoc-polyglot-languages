{
  description = "Hello World Rust";

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
          ];

          shellHook = ''
            echo "🦀 Hello Rust Environment"
            echo "Run: cargo run"
          '';
        };

        packages.default = pkgs.rustPlatform.buildRustPackage {
          pname = "hello-rust";
          version = "0.1.0";
          src = ./.;
          cargoLock.lockFile = ./Cargo.lock;
        };

        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/hello-rust";
        };
      });
}