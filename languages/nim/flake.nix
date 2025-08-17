{
  description = "Nim environment for AOC solutions";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nim
            nimble
            nimlsp
          ];

          shellHook = ''
            echo "👑 Nim AOC Environment"
            echo "Available commands:"
            echo "  nim r solution.nim"
            echo "  nim c solution.nim"
            echo "  nimble build"
            echo "  nimble test"
          '';
        };
      });
}
