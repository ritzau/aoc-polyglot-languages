{
  description = "Dart environment for AOC solutions";

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
            dart
            flutter
          ];

          shellHook = ''
            echo "🎯 Dart AOC Environment"
            echo "Available commands:"
            echo "  dart solution.dart"
            echo "  dart compile exe solution.dart"
            echo "  dart create project"
            echo "  dart pub get"
          '';
        };
      });
}
