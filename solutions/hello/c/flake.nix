{
  description = "Hello World C";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    c-lang = {
      url = "path:/Users/ritzau/src/slask/aoc-nix/languages/c";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, nixpkgs, flake-utils, c-lang }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        # Use the language flake's dev shell directly
        devShells.default = c-lang.devShells.${system}.default;

        packages.default = pkgs.stdenv.mkDerivation {
          pname = "hello-c";
          version = "0.1.0";
          src = ./.;
          nativeBuildInputs = [ pkgs.gcc pkgs.gnumake ];
          buildPhase = ''
            make
          '';
          installPhase = ''
            install -D hello-c $out/bin/hello-c
          '';
        };

        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/hello-c";
        };
      });
}
