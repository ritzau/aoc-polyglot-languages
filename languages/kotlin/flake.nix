{
  description = "Kotlin environment for AOC solutions";

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
            kotlin
            gradle
          ];

          shellHook = ''
            echo "🎯 Kotlin AOC Environment"
            echo "Available commands:"
            echo "  kotlinc solution.kt -include-runtime -d solution.jar && java -jar solution.jar"
            echo "  kotlin solution.kt"
            echo "  gradle run"
            echo "  kotlin -version: $(kotlin -version)"
          '';
        };
      });
}