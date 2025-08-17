{
  description = "Hello World C++";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    cpp-lang = {
      url = "path:/Users/ritzau/src/slask/aoc-nix/languages/cpp";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, nixpkgs, flake-utils, cpp-lang }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        # Use the language flake's dev shell directly
        devShells.default = cpp-lang.devShells.${system}.default;

        packages.default = pkgs.stdenv.mkDerivation {
          pname = "hello-cpp";
          version = "0.1.0";
          src = ./.;
          nativeBuildInputs = [ pkgs.cmake pkgs.gcc ];
          buildPhase = ''
            cmake .
            make
          '';
          installPhase = ''
            install -D hello-cpp $out/bin/hello-cpp
          '';
        };

        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/hello-cpp";
        };
      });
}
