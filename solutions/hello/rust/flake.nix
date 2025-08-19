{
  description = "Hello World Rust";

  inputs = {
    base.url = "path:/Users/ritzau/src/slask/aoc-nix/solutions/base";
    rust-lang.url = "path:/Users/ritzau/src/slask/aoc-nix/languages/rust";
  };

  outputs = { self, base, rust-lang }:
    base.inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        baseLib = base.lib.${system};
        package = baseLib.pkgs.rustPlatform.buildRustPackage {
          pname = "hello-rust";
          version = "0.1.0";
          src = ./.;
          cargoLock.lockFile = ./Cargo.lock;
        };
      in
      baseLib.mkSolution {
        language = "rust";
        description = "Hello World Rust";
        languageFlake = rust-lang;
        package = package;
      });
}
