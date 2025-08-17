{
  description = "Scala environment for AOC solutions";

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
            jdk21
            scala_3
            sbt
            scalafmt
          ];

          shellHook = ''
            echo "🎭 Scala AOC Environment"
            echo "Available commands:"
            echo "  scala solution.scala"
            echo "  scalac solution.scala && scala Solution"
            echo "  sbt run"
            echo "  scalafmt solution.scala"
          '';
        };
      });
}